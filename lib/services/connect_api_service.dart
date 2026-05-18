import 'dart:io' as io;

import 'package:connectrpc/connect.dart';
import 'package:connectrpc/io.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as connect_protocol;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';

import '../gen/candela/types/user.pb.dart';
import '../gen/candela/v1/dashboard_service.connect.client.dart';
import '../gen/candela/v1/dashboard_service.pb.dart';
import '../gen/candela/types/common.pb.dart' as common;
import '../gen/google/protobuf/timestamp.pb.dart' as ts;
import '../models/budget_info.dart';
import '../models/span_stats.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

ts.Timestamp _toTimestamp(DateTime dt) {
  final utc = dt.toUtc();
  return ts.Timestamp()
    ..seconds = Int64(utc.millisecondsSinceEpoch ~/ 1000)
    ..nanos = (utc.millisecondsSinceEpoch % 1000) * 1000000;
}

/// Convert a proto Timestamp to a Dart [DateTime].
DateTime _fromTimestamp(ts.Timestamp t) {
  return DateTime.fromMillisecondsSinceEpoch(
    t.seconds.toInt() * 1000 + t.nanos ~/ 1000000,
    isUtc: true,
  );
}

// ── Service ──────────────────────────────────────────────────────────────────

/// Creates a Connect protocol transport for the Candela backend.
///
/// Uses [io.HttpClient] for desktop (HTTP/1.1).
Transport createCandelaTransport({required String baseUrl}) {
  return connect_protocol.Transport(
    baseUrl: baseUrl,
    codec: const ProtoCodec(),
    httpClient: createHttpClient(io.HttpClient()),
  );
}

/// Type-safe ConnectRPC client for the Candela backend.
///
/// Wraps the generated [DashboardServiceClient] stubs, providing a clean
/// Dart-idiomatic API that returns domain models directly.
class ConnectApiService {
  final DashboardServiceClient _dashboard;
  final String? _authToken;

  ConnectApiService({
    required String baseUrl,
    String? authToken,
  })  : _authToken = authToken,
        _dashboard = DashboardServiceClient(
          createCandelaTransport(baseUrl: baseUrl),
        );

  /// Injectable constructor for testing with a custom transport.
  @visibleForTesting
  ConnectApiService.withTransport(Transport transport, {String? authToken})
      : _authToken = authToken,
        _dashboard = DashboardServiceClient(transport);

  Headers? get _headers {
    if (_authToken == null) return null;
    final h = Headers();
    h['authorization'] = 'Bearer $_authToken';
    return h;
  }

  common.TimeRange _makeTimeRange(DateTime start, DateTime end) {
    return common.TimeRange()
      ..start = _toTimestamp(start)
      ..end = _toTimestamp(end);
  }

  /// Fetch usage summary for the given time range.
  Future<GetUsageSummaryResponse> getUsageSummary({
    required DateTime start,
    required DateTime end,
  }) {
    final req = GetUsageSummaryRequest()
      ..timeRange = _makeTimeRange(start, end);
    return _dashboard.getUsageSummary(req, headers: _headers);
  }

  /// Fetch model-level breakdown for the given time range.
  Future<GetModelBreakdownResponse> getModelBreakdown({
    required DateTime start,
    required DateTime end,
  }) {
    final req = GetModelBreakdownRequest()
      ..timeRange = _makeTimeRange(start, end);
    return _dashboard.getModelBreakdown(req, headers: _headers);
  }

  /// Fetch the current user's personal usage (budget, grants, models).
  @Deprecated('Use getDashboardData instead')
  Future<GetMyUsageResponse> getMyUsage({
    required DateTime start,
    required DateTime end,
  }) {
    final req = GetMyUsageRequest()..timeRange = _makeTimeRange(start, end);
    return _dashboard.getMyUsage(req, headers: _headers);
  }

  /// Fetch a consolidated dashboard snapshot: usage summary, model breakdown,
  /// and (optionally) budget context — all in a single RPC round-trip.
  ///
  /// Replaces the concurrent fan-out of [getUsageSummary] +
  /// [getModelBreakdown] + [getMyUsage].
  Future<GetDashboardDataResponse> getDashboardData({
    required DateTime start,
    required DateTime end,
    bool includeBudget = true,
  }) {
    final req = GetDashboardDataRequest()
      ..timeRange = _makeTimeRange(start, end)
      ..includeBudget = includeBudget;
    return _dashboard.getDashboardData(req, headers: _headers);
  }

  // ── Domain conversions ───────────────────────────────────────────────────

  /// Convert proto [ModelUsage] list → [SpanRecord] list for the chart
  /// pipeline.
  ///
  /// Distributes calls evenly across the time window so charts have data.
  static List<SpanRecord> spansFromModels(
    List<ModelUsage> models,
    DateTime start,
    DateTime end, {
    int maxSyntheticSpans = 1000,
  }) {
    final spans = <SpanRecord>[];
    for (final m in models) {
      final callCount = m.callCount.toInt().clamp(1, maxSyntheticSpans);
      final inputTok = m.inputTokens.toInt();
      final outputTok = m.outputTokens.toInt();
      final cost = m.costUsd;
      final latency = m.avgLatencyMs;
      final model = m.model.isEmpty ? 'unknown' : m.model;
      final provider = m.provider.isEmpty ? 'team' : m.provider;

      for (var i = 0; i < callCount; i++) {
        spans.add(SpanRecord(
          spanId: 'r-$model-$i',
          traceId: 'r-$model',
          model: model,
          provider: provider,
          inputTokens: (inputTok / callCount).round(),
          outputTokens: (outputTok / callCount).round(),
          totalTokens: ((inputTok + outputTok) / callCount).round(),
          costUsd: cost / callCount,
          durationMs: latency,
          status: 'ok',
          timestamp: _spread(start, end, i, callCount),
          name: 'chat $model',
        ));
      }
    }
    return spans;
  }

  /// Convert proto [GetMyUsageResponse] → domain [BudgetInfo].
  static BudgetInfo? budgetFromProto(
    GetMyUsageResponse resp, {
    DateTime? referenceNow,
  }) {
    if (!resp.hasBudget()) return null;
    return _budgetFromUserBudget(resp.budget, referenceNow: referenceNow);
  }

  /// Convert proto [GetDashboardDataResponse] → domain [BudgetInfo].
  static BudgetInfo? budgetFromDashboard(
    GetDashboardDataResponse resp, {
    DateTime? referenceNow,
  }) {
    if (!resp.hasBudgetContext() || !resp.budgetContext.hasBudget()) {
      return null;
    }
    return _budgetFromUserBudget(
      resp.budgetContext.budget,
      referenceNow: referenceNow,
    );
  }

  /// Shared conversion from proto [UserBudget] → domain [BudgetInfo].
  static BudgetInfo _budgetFromUserBudget(
    UserBudget b, {
    DateTime? referenceNow,
  }) {
    final now = referenceNow ?? DateTime.now().toUtc();
    return BudgetInfo(
      limitUsd: b.limitUsd,
      spentUsd: b.spentUsd,
      tokensUsed: b.tokensUsed.toInt(),
      period: BudgetPeriodKind.daily,
      periodEnd: b.hasPeriodEnd()
          ? _fromTimestamp(b.periodEnd)
          : now.add(const Duration(days: 1)),
    );
  }

  /// Convert proto [BudgetGrant] list → domain [GrantInfo] list.
  static List<GrantInfo> grantsFromProto(GetMyUsageResponse resp) {
    return resp.activeGrants.map(_grantFromBudgetGrant).toList();
  }

  /// Convert grants from [GetDashboardDataResponse] → domain [GrantInfo] list.
  static List<GrantInfo> grantsFromDashboard(GetDashboardDataResponse resp) {
    if (!resp.hasBudgetContext()) return [];
    return resp.budgetContext.activeGrants.map(_grantFromBudgetGrant).toList();
  }

  /// Shared conversion from a single proto [BudgetGrant] → domain [GrantInfo].
  static GrantInfo _grantFromBudgetGrant(BudgetGrant g) {
    return GrantInfo(
      id: g.id,
      amountUsd: g.amountUsd,
      spentUsd: g.spentUsd,
      reason: g.reason,
      grantedBy: g.grantedBy,
      expiresAt: g.hasExpiresAt() ? _fromTimestamp(g.expiresAt) : null,
    );
  }

  /// Evenly spread synthetic spans across a time window.
  static DateTime _spread(DateTime start, DateTime end, int i, int total) {
    if (total <= 1) {
      return start.add(Duration(
        milliseconds: end.difference(start).inMilliseconds ~/ 2,
      ));
    }
    final step = end.difference(start).inMilliseconds / total;
    return start.add(Duration(milliseconds: (step * (i + 0.5)).round()));
  }
}
