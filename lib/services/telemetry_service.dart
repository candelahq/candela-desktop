import 'dart:convert';

import 'package:connectrpc/connect.dart' show ConnectException, Code;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/budget_info.dart';
import '../models/span_stats.dart';
import '../gen/candela/v1/dashboard_service.pb.dart' hide TimeSeriesPoint;
import 'connect_api_service.dart';

// ── Error kinds ───────────────────────────────────────────────────────────────

/// Typed errors surfaced from [TelemetryService.fetch].
enum TelemetryErrorKind {
  /// Server returned 401 — token is expired or missing.
  authExpired,

  /// Network / timeout / parse failure.
  unreachable,
}

// ── Service ───────────────────────────────────────────────────────────────────

/// Fetches token/cost telemetry for the dashboard.
///
/// Two mutually-exclusive modes, selected at construction time:
///
/// **Local mode** (`remoteUrl == null`)
///   Reads from `/_local/api/traces` on the candela sidecar (SQLite).
///
/// **Team mode** (`remoteUrl != null`)
///   Calls ConnectRPC `GetUsageSummary` + `GetModelBreakdown` + `GetMyUsage`
///   on the candela-analysis server. Uses a gcloud ADC Bearer token.
///
/// Inject [httpClient] in tests to avoid real network calls.
class TelemetryService {
  /// Local proxy port. Must be 1–65535. Used in local mode only.
  final int port;

  /// ConnectRPC base URL, e.g. `https://candela.example.com`.
  /// When set, team mode is active; local source is skipped.
  final String? remoteUrl;

  /// ADC Bearer token for team mode requests.
  final String? authToken;

  // H5: injectable client enables testing without network.
  final http.Client _client;

  /// Factory for creating a [ConnectApiService]. Injected in tests.
  final ConnectApiService Function(String baseUrl, String? authToken)
      _connectApiFactory;

  // Security / resource limits.
  static const _maxBodyBytes = 5 * 1024 * 1024; // C5/H1: 5 MB response cap
  static const _localTimeout = Duration(seconds: 5);

  TelemetryService({
    this.port = 8181,
    this.remoteUrl,
    this.authToken,
    http.Client? httpClient,
    ConnectApiService Function(String baseUrl, String? authToken)?
        connectApiFactory,
  })  : _client = httpClient ?? http.Client(),
        _connectApiFactory = connectApiFactory ??
            ((baseUrl, authToken) =>
                ConnectApiService(baseUrl: baseUrl, authToken: authToken)) {
    // H6: validate port range at construction time.
    if (port <= 0 || port > 65535) {
      throw ArgumentError.value(port, 'port', 'Must be 1–65535');
    }
  }

  bool get isTeamMode => remoteUrl != null;

  /// Release the underlying HTTP connection pool.
  /// Call when the service is no longer needed (e.g., in dispose()).
  void dispose() => _client.close();

  /// Validate that [url] has a safe scheme and non-empty host (C2: SSRF guard).
  static bool isSafeUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }

  // ── Public API ──────────────────────────────────────────────────────────────

  /// Fetch telemetry for [range]. Returns `null` when no data is available.
  ///
  /// The returned [TelemetryResult] may carry a [TelemetryErrorKind] to let
  /// the UI show actionable error messages (e.g. "token expired").
  Future<TelemetryResult?> fetch(TokenTimeRange range) async {
    // C2: reject unsafe remote URLs before making any request.
    if (remoteUrl != null && !isSafeUrl(remoteUrl!)) {
      return const TelemetryResult.withError(
        isTeamMode: true,
        error: TelemetryErrorKind.unreachable,
      );
    }

    // H3: single stable `now` reference used throughout this fetch cycle.
    final now = DateTime.now();

    List<SpanRecord> spans;
    TelemetryErrorKind? errorKind;
    BudgetInfo? budget;
    List<GrantInfo> grants = [];
    double? totalRemainingUsd;

    if (isTeamMode) {
      (spans, errorKind, budget, grants, totalRemainingUsd) =
          await _fetchRemote(range, now);
    } else {
      (spans, errorKind) = await _fetchLocal(range);
    }

    if (spans.isEmpty) {
      if (errorKind != null) {
        return TelemetryResult.withError(
            isTeamMode: isTeamMode, error: errorKind);
      }
      // Return zeroed summary rather than null so the UI shows an empty state
      // ("no calls yet") rather than a misleading "cannot reach backend" error.
      return TelemetryResult.empty(
        isTeamMode: isTeamMode,
        budget: budget,
        activeGrants: grants,
        totalRemainingUsd: totalRemainingUsd,
      );
    }

    final cutoff = range.startFrom(now);
    final filtered = spans.where((s) => s.timestamp.isAfter(cutoff)).toList();

    // Return empty-state result if all spans fall outside the requested window.
    if (filtered.isEmpty) {
      return errorKind != null
          ? TelemetryResult.withError(isTeamMode: isTeamMode, error: errorKind)
          : TelemetryResult.empty(
              isTeamMode: isTeamMode,
              budget: budget,
              activeGrants: grants,
              totalRemainingUsd: totalRemainingUsd,
            );
    }

    return TelemetryResult(
      summary: buildSummary(filtered, range, now),
      models: _buildModelBreakdown(filtered),
      spans: filtered,
      isTeamMode: isTeamMode,
      budget: budget,
      activeGrants: grants,
      totalRemainingUsd: totalRemainingUsd,
    );
  }

  // ── Local ───────────────────────────────────────────────────────────────────

  Future<(List<SpanRecord>, TelemetryErrorKind?)> _fetchLocal(
      TokenTimeRange range) async {
    // Use a larger limit for longer ranges — 500 is not enough for 7d/30d views.
    final limit =
        range == TokenTimeRange.h24 || range == TokenTimeRange.todayUtc
            ? 500
            : 2000;
    try {
      final uri = Uri.http(
          'localhost:$port', '/_local/api/traces', {'limit': '$limit'});
      final resp = await _client.get(uri).timeout(_localTimeout);

      // H1: reject oversized responses before decoding.
      if (resp.bodyBytes.length > _maxBodyBytes) {
        return (<SpanRecord>[], TelemetryErrorKind.unreachable);
      }
      // Non-200 means the proxy endpoint is missing/wrong version —
      // treat as unreachable so the UI shows an actionable error.
      if (resp.statusCode != 200) {
        return (<SpanRecord>[], TelemetryErrorKind.unreachable);
      }

      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final spans = (body['spans'] as List<dynamic>? ?? [])
          .map((e) => SpanRecord.fromJson(e as Map<String, dynamic>))
          .toList();
      return (spans, null);
    } catch (_) {
      return (<SpanRecord>[], TelemetryErrorKind.unreachable);
    }
  }

  // ── Team / ConnectRPC ───────────────────────────────────────────────────────

  Future<
      (
        List<SpanRecord>,
        TelemetryErrorKind?,
        BudgetInfo?,
        List<GrantInfo>,
        double?
      )> _fetchRemote(TokenTimeRange range, DateTime now) async {
    final base = remoteUrl!.replaceAll(RegExp(r'/$'), '');
    final start = range.startFrom(now);

    final api = _connectApiFactory(base, authToken);

    try {
      // Fire RPCs concurrently. GetMyUsage is non-fatal.
      final summaryFuture = api.getUsageSummary(start: start, end: now);
      final modelsFuture = api.getModelBreakdown(start: start, end: now);
      final usageFuture = api
          .getMyUsage(start: start, end: now)
          .then<GetMyUsageResponse?>((r) => r)
          .catchError((Object e) {
        debugPrint('[TelemetryService] GetMyUsage failed (non-fatal): $e');
        return null;
      });

      final results = await Future.wait([
        summaryFuture,
        modelsFuture,
        usageFuture,
      ]);

      final modelsResp = results[1] as GetModelBreakdownResponse;
      final usageResp = results[2] as GetMyUsageResponse?;

      // Parse budget/grant data from GetMyUsage (non-fatal if missing/error).
      BudgetInfo? budget;
      List<GrantInfo> grants = [];
      double? totalRemainingUsd;
      if (usageResp != null) {
        try {
          budget = ConnectApiService.budgetFromProto(usageResp);
          grants = ConnectApiService.grantsFromProto(usageResp);
          final rawRemaining = usageResp.totalRemainingUsd;
          // Clamp server value: must be non-negative and finite.
          if (!rawRemaining.isNaN && !rawRemaining.isInfinite) {
            totalRemainingUsd = rawRemaining.clamp(0.0, 1e9);
          }
        } catch (_) {
          // Budget data is display-only — swallow parse errors.
        }
      }

      // Convert proto ModelUsage → SpanRecord for the chart pipeline.
      final spans =
          ConnectApiService.spansFromModels(modelsResp.models, start, now);
      return (spans, null, budget, grants, totalRemainingUsd);
    } on ConnectException catch (e) {
      // C1/C3: distinguish 401 (auth expired) from other errors.
      if (e.code == Code.unauthenticated) {
        return (
          <SpanRecord>[],
          TelemetryErrorKind.authExpired,
          null,
          <GrantInfo>[],
          null
        );
      }

      return (
        <SpanRecord>[],
        TelemetryErrorKind.unreachable,
        null,
        <GrantInfo>[],
        null
      );
    } catch (_) {
      return (
        <SpanRecord>[],
        TelemetryErrorKind.unreachable,
        null,
        <GrantInfo>[],
        null
      );
    }
  }

  // ── Aggregation ─────────────────────────────────────────────────────────────

  /// H3: [now] is passed in from [fetch] to ensure consistent bucket alignment.
  UsageSummary buildSummary(
      List<SpanRecord> spans, TokenTimeRange range, DateTime now) {
    int totalIn = 0, totalOut = 0;
    double totalCost = 0, totalMs = 0;
    for (final s in spans) {
      totalIn += s.inputTokens;
      totalOut += s.outputTokens;
      totalCost += s.costUsd;
      totalMs += s.durationMs;
    }
    return UsageSummary(
      totalCalls: spans.length,
      totalInputTokens: totalIn,
      totalOutputTokens: totalOut,
      totalCostUsd: totalCost,
      avgLatencyMs: spans.isEmpty ? 0.0 : totalMs / spans.length,
      costOverTime: _series(spans, range, now, (s) => s.costUsd),
      tokensOverTime:
          _series(spans, range, now, (s) => s.totalTokens.toDouble()),
      callsOverTime: _series(spans, range, now, (_) => 1.0),
    );
  }

  List<ModelBreakdown> _buildModelBreakdown(List<SpanRecord> spans) {
    final map = <String, _Accum>{};
    for (final s in spans) {
      final a = map.putIfAbsent('${s.provider}::${s.model}',
          () => _Accum(model: s.model, provider: s.provider));
      a.callCount++;
      a.inputTokens += s.inputTokens;
      a.outputTokens += s.outputTokens;
      a.costUsd += s.costUsd;
      a.latencySum += s.durationMs;
    }
    return map.values
        .map((a) => ModelBreakdown(
              model: a.model,
              provider: a.provider,
              callCount: a.callCount,
              inputTokens: a.inputTokens,
              outputTokens: a.outputTokens,
              costUsd: a.costUsd,
              avgLatencyMs: a.callCount == 0 ? 0 : a.latencySum / a.callCount,
            ))
        .toList()
      ..sort((a, b) => b.costUsd.compareTo(a.costUsd));
  }

  /// H3: [now] is passed in to ensure bucket timestamps are stable.
  List<TimeSeriesPoint> _series(
    List<SpanRecord> spans,
    TokenTimeRange range,
    DateTime now,
    double Function(SpanRecord) val,
  ) {
    const n = 24;
    final start = range.startFrom(now);
    final bucketMs = range.duration.inMilliseconds ~/ n;

    final sums = List<double>.filled(n, 0.0);
    for (final s in spans) {
      final off = s.timestamp.difference(start).inMilliseconds;
      if (off < 0) continue;
      sums[(off / bucketMs).floor().clamp(0, n - 1)] += val(s);
    }

    return List.generate(n, (i) {
      final t = start.add(Duration(milliseconds: bucketMs * i));
      return TimeSeriesPoint(label: _label(t, range), value: sums[i]);
    });
  }

  String _label(DateTime t, TokenTimeRange r) {
    if (r == TokenTimeRange.h24 || r == TokenTimeRange.todayUtc) {
      return '${t.hour.toString().padLeft(2, '0')}:'
          '${t.minute.toString().padLeft(2, '0')}';
    }
    const mo = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${mo[t.month - 1]} ${t.day}';
  }
}

// ── Result ────────────────────────────────────────────────────────────────────

class TelemetryResult {
  final UsageSummary? summary;
  final List<ModelBreakdown> models;
  final List<SpanRecord> spans;
  final bool isTeamMode;
  // C1/C3: typed error so UI can show actionable messages.
  final TelemetryErrorKind? error;

  /// Budget for the current period. Null in solo/local mode or when not
  /// configured on the server.
  final BudgetInfo? budget;

  /// Active grants (earliest-expiry first, matching server deduction order).
  final List<GrantInfo> activeGrants;

  /// Server-computed total remaining across budget + all grants.
  final double? totalRemainingUsd;

  const TelemetryResult({
    required this.summary,
    required this.models,
    required this.spans,
    required this.isTeamMode,
    this.error,
    this.budget,
    this.activeGrants = const [],
    this.totalRemainingUsd,
  });

  /// Convenience constructor for error-only results.
  const TelemetryResult.withError({
    required this.isTeamMode,
    required TelemetryErrorKind this.error,
  })  : summary = null,
        models = const [],
        spans = const [],
        budget = null,
        activeGrants = const [],
        totalRemainingUsd = null;

  /// Connected successfully but no spans in the selected time range.
  const TelemetryResult.empty({
    required this.isTeamMode,
    this.budget,
    this.activeGrants = const [],
    this.totalRemainingUsd,
  })  : summary = null,
        models = const [],
        spans = const [],
        error = null;

  bool get hasData => summary != null;
}

// ── Internal accumulator ──────────────────────────────────────────────────────

class _Accum {
  final String model;
  final String provider;
  int callCount = 0;
  int inputTokens = 0;
  int outputTokens = 0;
  double costUsd = 0;
  double latencySum = 0;
  _Accum({required this.model, required this.provider});
}
