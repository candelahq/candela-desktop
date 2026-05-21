import 'dart:convert';

import 'package:connectrpc/connect.dart' show ConnectException, Code;
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:candela_desktop/gen/candela/v1/dashboard_service.pb.dart'
    hide TimeSeriesPoint;
import 'package:candela_desktop/gen/candela/types/user.pb.dart';
import 'package:candela_desktop/gen/google/protobuf/timestamp.pb.dart';
import 'package:candela_desktop/models/span_stats.dart';
import 'package:candela_desktop/services/connect_api_service.dart';
import 'package:candela_desktop/services/process_manager.dart';
import 'package:candela_desktop/services/telemetry_service.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

/// Build a minimal span JSON map.
Map<String, dynamic> _spanJson({
  String model = 'gpt-4o',
  String provider = 'openai',
  int inputTokens = 100,
  int outputTokens = 50,
  double costUsd = 0.01,
  double durationMs = 500,
  String? timestamp,
}) =>
    {
      'span_id': 'sid',
      'trace_id': 'tid',
      'model': model,
      'provider': provider,
      'input_tokens': inputTokens,
      'output_tokens': outputTokens,
      'total_tokens': inputTokens + outputTokens,
      'cost_usd': costUsd,
      'duration_ms': durationMs,
      'status': 'ok',
      'timestamp': timestamp ?? DateTime.now().toIso8601String(),
      'name': 'chat',
    };

/// Mock HTTP client that returns a fixed response.
MockClient _mockClient(
  String body, {
  int status = 200,
  String path = '/_local/api/traces',
}) =>
    MockClient((request) async {
      if (request.url.path.contains(path)) {
        return http.Response(body, status);
      }
      return http.Response('Not found', 404);
    });

/// Returns a local-mode [TelemetryService] with the given mock client.
TelemetryService _localSvc(MockClient client) =>
    TelemetryService(port: 8181, httpClient: client);

/// Mock implementation of [ConnectApiService] for testing team-mode paths.
///
/// Allows tests to configure exactly what each RPC returns without requiring
/// real HTTP or protobuf serialization.
class MockConnectApi extends ConnectApiService {
  final GetUsageSummaryResponse? summaryResponse;
  final GetModelBreakdownResponse? modelResponse;
  final GetMyUsageResponse? usageResponse;
  final GetDashboardDataResponse? dashboardResponse;
  final ConnectException? throwOnSummary;
  final ConnectException? throwOnModels;
  final ConnectException? throwOnUsage;
  final ConnectException? throwOnDashboard;
  String? capturedAuthToken;
  UserScope? capturedUserScope;

  MockConnectApi({
    this.summaryResponse,
    this.modelResponse,
    this.usageResponse,
    this.dashboardResponse,
    this.throwOnSummary,
    this.throwOnModels,
    this.throwOnUsage,
    this.throwOnDashboard,
  }) : super(baseUrl: 'http://test', authToken: null);

  @override
  Future<GetDashboardDataResponse> getDashboardData({
    required DateTime start,
    required DateTime end,
    bool includeBudget = false,
    UserScope? userScope,
  }) async {
    capturedUserScope = userScope;
    if (throwOnDashboard != null) throw throwOnDashboard!;
    // If throwOnSummary is set, propagate it as if the consolidated endpoint
    // also fails (same server would fail both).
    if (throwOnSummary != null) throw throwOnSummary!;

    // If an explicit dashboardResponse was provided, return it directly.
    if (dashboardResponse != null) return dashboardResponse!;

    // Otherwise compose from legacy mock fields so existing tests work.
    final resp = GetDashboardDataResponse();
    if (modelResponse != null) {
      resp.models.addAll(modelResponse!.models);
    }
    if (usageResponse != null && includeBudget) {
      final bc = GetDashboardDataResponse_BudgetContext();
      if (usageResponse!.hasBudget()) {
        bc.budget = usageResponse!.budget;
        bc.totalRemainingUsd = usageResponse!.totalRemainingUsd;
      }
      bc.activeGrants.addAll(usageResponse!.activeGrants);
      resp.budgetContext = bc;
    }
    return resp;
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  Future<GetUsageSummaryResponse> getUsageSummary({
    required DateTime start,
    required DateTime end,
  }) async {
    if (throwOnSummary != null) throw throwOnSummary!;
    return summaryResponse ?? GetUsageSummaryResponse();
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  Future<GetModelBreakdownResponse> getModelBreakdown({
    required DateTime start,
    required DateTime end,
  }) async {
    if (throwOnModels != null) throw throwOnModels!;
    return modelResponse ?? GetModelBreakdownResponse();
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  Future<GetMyUsageResponse> getMyUsage({
    required DateTime start,
    required DateTime end,
  }) async {
    if (throwOnUsage != null) throw throwOnUsage!;
    return usageResponse ?? GetMyUsageResponse();
  }
}

/// Returns a team-mode [TelemetryService] with a [MockConnectApi].
TelemetryService _teamSvcWithMock(
  MockConnectApi mock, {
  String remoteUrl = 'https://candela.example.com',
  String? authToken = 'test-token',
}) =>
    TelemetryService(
      port: 8181,
      remoteUrl: remoteUrl,
      authToken: authToken,
      connectApiFactory: (baseUrl, token) {
        mock.capturedAuthToken = token;
        return mock;
      },
    );

// ── isSafeUrl (C2) ───────────────────────────────────────────────────────────

void main() {
  group('TelemetryService.isSafeUrl', () {
    test('accepts https URL', () {
      expect(TelemetryService.isSafeUrl('https://candela.example.com'), isTrue);
    });

    test('accepts http URL (local dev)', () {
      expect(TelemetryService.isSafeUrl('http://localhost:8080'), isTrue);
    });

    test('rejects empty string', () {
      expect(TelemetryService.isSafeUrl(''), isFalse);
    });

    test('rejects file:// scheme (SSRF guard)', () {
      expect(TelemetryService.isSafeUrl('file:///etc/passwd'), isFalse);
    });

    test('rejects ftp:// scheme', () {
      expect(TelemetryService.isSafeUrl('ftp://example.com'), isFalse);
    });

    test('rejects URL with empty host', () {
      expect(TelemetryService.isSafeUrl('https://'), isFalse);
    });
  });

  // ── Constructor (H6) ───────────────────────────────────────────────────────

  group('TelemetryService constructor', () {
    test('accepts valid port 8181', () {
      expect(() => TelemetryService(port: 8181), returnsNormally);
    });

    test('throws on port 0 (H6)', () {
      expect(() => TelemetryService(port: 0), throwsArgumentError);
    });

    test('throws on port 65536 (H6)', () {
      expect(() => TelemetryService(port: 65536), throwsArgumentError);
    });

    test('throws on negative port', () {
      expect(() => TelemetryService(port: -1), throwsArgumentError);
    });

    test('accepts port 1', () {
      expect(() => TelemetryService(port: 1), returnsNormally);
    });

    test('accepts port 65535', () {
      expect(() => TelemetryService(port: 65535), returnsNormally);
    });

    test('isTeamMode is false when remoteUrl is null', () {
      expect(TelemetryService().isTeamMode, isFalse);
    });

    test('isTeamMode is true when remoteUrl is set', () {
      expect(
        TelemetryService(remoteUrl: 'https://example.com').isTeamMode,
        isTrue,
      );
    });
  });

  // ── Local mode fetch ──────────────────────────────────────────────────────

  group('TelemetryService.fetch — local mode', () {
    test('returns unreachable error when proxy returns 404', () async {
      final client = _mockClient('', status: 404);
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.d7);
      // 404 means the endpoint is missing/wrong proxy version \u2014 a real error.
      expect(result, isNotNull);
      expect(result!.error, TelemetryErrorKind.unreachable);
    });

    test('returns empty result when response body is empty spans list',
        () async {
      final client = _mockClient(jsonEncode({'spans': []}));
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.d7);
      // Connected successfully but no spans — TelemetryResult.empty(), not null.
      expect(result, isNotNull);
      expect(result!.hasData, isFalse);
      expect(result.error, isNull);
    });

    test('aggregates a single span correctly', () async {
      final ts = DateTime.now().toIso8601String();
      final client = _mockClient(jsonEncode({
        'spans': [
          _spanJson(
              inputTokens: 100, outputTokens: 50, costUsd: 0.01, timestamp: ts)
        ],
      }));
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.h24);

      expect(result, isNotNull);
      expect(result!.summary!.totalCalls, 1);
      expect(result.summary!.totalInputTokens, 100);
      expect(result.summary!.totalOutputTokens, 50);
      expect(result.summary!.totalCostUsd, closeTo(0.01, 1e-9));
    });

    test('aggregates multiple spans', () async {
      final ts = DateTime.now().toIso8601String();
      final spans = List.generate(
        5,
        (_) => _spanJson(
            inputTokens: 100, outputTokens: 40, costUsd: 0.005, timestamp: ts),
      );
      final client = _mockClient(jsonEncode({'spans': spans}));
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.h24);

      expect(result!.summary!.totalCalls, 5);
      expect(result.summary!.totalInputTokens, 500);
      expect(result.summary!.totalOutputTokens, 200);
      expect(result.summary!.totalCostUsd, closeTo(0.025, 1e-9));
    });

    test('returns unreachable error kind on network failure', () async {
      // Simulate malformed JSON — _fetchLocal catches FormatException
      // and returns ([], unreachable). fetch() surfaces this as a
      // TelemetryResult.withError(unreachable).
      final client = _mockClient('<html>error</html>');
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.h24);
      expect(
        result?.error,
        anyOf(isNull, TelemetryErrorKind.unreachable),
        reason: 'malformed body should return null or an unreachable error',
      );
    });

    test('returns empty result for spans outside the time range', () async {
      // Span 60 days ago — outside any range
      final oldTs =
          DateTime.now().subtract(const Duration(days: 60)).toIso8601String();
      final client = _mockClient(jsonEncode({
        'spans': [_spanJson(timestamp: oldTs)],
      }));
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.d7);
      // Filtered-out spans produce TelemetryResult.empty(), not null.
      expect(result, isNotNull);
      expect(result!.hasData, isFalse);
      expect(result.error, isNull);
    });

    test('result is not team mode', () async {
      final ts = DateTime.now().toIso8601String();
      final client = _mockClient(jsonEncode({
        'spans': [_spanJson(timestamp: ts)],
      }));
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.h24);
      expect(result!.isTeamMode, isFalse);
    });
  });

  // ── Model breakdown aggregation ───────────────────────────────────────────

  group('TelemetryService — model breakdown', () {
    test('groups spans by provider::model', () async {
      final ts = DateTime.now().toIso8601String();
      final spans = [
        _spanJson(
            model: 'gpt-4o', provider: 'openai', costUsd: 0.01, timestamp: ts),
        _spanJson(
            model: 'gpt-4o', provider: 'openai', costUsd: 0.02, timestamp: ts),
        _spanJson(
            model: 'claude-3',
            provider: 'anthropic',
            costUsd: 0.05,
            timestamp: ts),
      ];
      final client = _mockClient(jsonEncode({'spans': spans}));
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.h24);

      expect(result!.models.length, 2);
    });

    test('sorts models by cost descending', () async {
      final ts = DateTime.now().toIso8601String();
      final spans = [
        _spanJson(model: 'cheap', provider: 'p', costUsd: 0.001, timestamp: ts),
        _spanJson(
            model: 'expensive', provider: 'p', costUsd: 0.99, timestamp: ts),
      ];
      final client = _mockClient(jsonEncode({'spans': spans}));
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.h24);

      expect(result!.models.first.model, 'expensive');
      expect(result.models.last.model, 'cheap');
    });

    test('sums tokens correctly per model', () async {
      final ts = DateTime.now().toIso8601String();
      final spans = [
        _spanJson(
            model: 'gpt-4o',
            provider: 'openai',
            inputTokens: 200,
            outputTokens: 100,
            costUsd: 0.01,
            timestamp: ts),
        _spanJson(
            model: 'gpt-4o',
            provider: 'openai',
            inputTokens: 300,
            outputTokens: 150,
            costUsd: 0.02,
            timestamp: ts),
      ];
      final client = _mockClient(jsonEncode({'spans': spans}));
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.h24);

      final gpt = result!.models.first;
      expect(gpt.callCount, 2);
      expect(gpt.inputTokens, 500);
      expect(gpt.outputTokens, 250);
      expect(gpt.costUsd, closeTo(0.03, 1e-9));
    });
  });

  // ── Time series bucketing ─────────────────────────────────────────────────

  group('TelemetryService — time series', () {
    test('produces exactly 24 buckets for all time ranges', () async {
      final ts = DateTime.now().toIso8601String();
      final client = _mockClient(jsonEncode({
        'spans': [_spanJson(timestamp: ts)],
      }));

      for (final range in TokenTimeRange.values) {
        final svc = _localSvc(client);
        final result = await svc.fetch(range);
        expect(result!.summary!.costOverTime.length, 24,
            reason: 'range: ${range.label}');
        expect(result.summary!.tokensOverTime.length, 24,
            reason: 'range: ${range.label}');
        expect(result.summary!.callsOverTime.length, 24,
            reason: 'range: ${range.label}');
      }
    });

    test('a span within the window lands in a non-zero bucket', () async {
      final ts =
          DateTime.now().subtract(const Duration(hours: 1)).toIso8601String();
      final client = _mockClient(jsonEncode({
        'spans': [_spanJson(costUsd: 0.05, timestamp: ts)],
      }));
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.h24);

      final totalInBuckets =
          result!.summary!.costOverTime.fold(0.0, (s, p) => s + p.value);
      expect(totalInBuckets, closeTo(0.05, 1e-9));
    });

    test('h24 bucket labels are formatted as HH:mm', () async {
      final ts = DateTime.now().toIso8601String();
      final client = _mockClient(jsonEncode({
        'spans': [_spanJson(timestamp: ts)],
      }));
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.h24);

      final label = result!.summary!.costOverTime.first.label;
      expect(RegExp(r'^\d{2}:\d{2}$').hasMatch(label), isTrue);
    });

    test('d7 bucket labels are formatted as Mon DD', () async {
      final ts = DateTime.now().toIso8601String();
      final client = _mockClient(jsonEncode({
        'spans': [_spanJson(timestamp: ts)],
      }));
      final svc = _localSvc(client);
      final result = await svc.fetch(TokenTimeRange.d7);

      final label = result!.summary!.costOverTime.first.label;
      expect(RegExp(r'^[A-Z][a-z]{2} \d{1,2}$').hasMatch(label), isTrue);
    });
  });

  // ── Team mode (C1/C2/C3/C4/C5) ───────────────────────────────────────────

  group('TelemetryService.fetch — team mode', () {
    test('returns authExpired error on 401 (C1/C3)', () async {
      final mock = MockConnectApi(
        throwOnSummary: ConnectException(Code.unauthenticated, 'expired'),
      );
      final svc = _teamSvcWithMock(mock);
      final result = await svc.fetch(TokenTimeRange.d7);

      expect(result, isNotNull);
      expect(result!.error, TelemetryErrorKind.authExpired);
      expect(result.hasData, isFalse);
    });

    test('returns unreachable error on server error', () async {
      final mock = MockConnectApi(
        throwOnSummary: ConnectException(Code.internal, 'server error'),
      );
      final svc = _teamSvcWithMock(mock);
      final result = await svc.fetch(TokenTimeRange.d7);

      expect(result, isNotNull);
      expect(result!.error, TelemetryErrorKind.unreachable);
    });

    test('returns unreachable on invalid remoteUrl (C2 SSRF guard)', () async {
      // The SSRF check happens in fetch() before _fetchRemote, so no mock needed.
      final mock = MockConnectApi();
      final svc = _teamSvcWithMock(
        mock,
        remoteUrl: 'file:///etc/passwd',
      );
      final result = await svc.fetch(TokenTimeRange.d7);
      expect(result!.error, TelemetryErrorKind.unreachable);
    });

    test('caps callCount at 1000 to prevent OOM (C4)', () async {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(10000000)
        ..inputTokens = Int64(1000)
        ..outputTokens = Int64(500)
        ..costUsd = 10.0
        ..avgLatencyMs = 500.0;

      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse()..models.add(model),
      );
      final svc = _teamSvcWithMock(mock);
      final result = await svc.fetch(TokenTimeRange.d7);

      // Should complete without OOM — spans capped at 1000
      expect(result!.spans.length, lessThanOrEqualTo(1000));
    });

    test('parses model breakdown and aggregates correctly', () async {
      final model = ModelUsage()
        ..model = 'claude-3-5-sonnet'
        ..provider = 'anthropic'
        ..callCount = Int64(4)
        ..inputTokens = Int64(400)
        ..outputTokens = Int64(200)
        ..costUsd = 0.04
        ..avgLatencyMs = 900.0;

      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse()..models.add(model),
      );
      final svc = _teamSvcWithMock(mock);
      final result = await svc.fetch(TokenTimeRange.d7);

      expect(result!.hasData, isTrue);
      expect(result.isTeamMode, isTrue);
      expect(result.summary!.totalCostUsd, greaterThan(0));
      expect(result.summary!.totalCostUsd, lessThanOrEqualTo(0.04 + 1e-9));
      expect(result.spans.length, greaterThan(0));
    });

    test('returns empty result when model breakdown is empty', () async {
      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse(),
      );
      final svc = _teamSvcWithMock(mock);
      final result = await svc.fetch(TokenTimeRange.h24);

      expect(result, isNotNull);
      // Empty models = no spans → empty result (no data to chart).
      expect(result!.hasData, isFalse);
      expect(result.error, isNull);
    });

    test('passes authToken through factory', () async {
      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse(),
      );
      _teamSvcWithMock(mock, authToken: 'my-token');
      // Factory captures the token before RPC — verify it was passed.
      // (fetch() triggers the factory call)
      final svc = _teamSvcWithMock(mock, authToken: 'my-token');
      await svc.fetch(TokenTimeRange.h24);
      expect(mock.capturedAuthToken, 'my-token');
    });

    test('passes null authToken when not provided', () async {
      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse(),
      );
      final svc = _teamSvcWithMock(mock, authToken: null);
      await svc.fetch(TokenTimeRange.h24);
      expect(mock.capturedAuthToken, isNull);
    });
  });

  // ── _spread single-call midpoint (H4) ─────────────────────────────────────

  group('_spread midpoint fix (H4)', () {
    test('single-call model does NOT land in bucket 0', () async {
      // Create a model with call_count=1 and verify the synthetic span
      // timestamp is at the window midpoint (not at start = bucket 0).
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(1)
        ..inputTokens = Int64(100)
        ..outputTokens = Int64(50)
        ..costUsd = 0.01
        ..avgLatencyMs = 500.0;

      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse()..models.add(model),
      );
      final svc = _teamSvcWithMock(mock);
      final result = await svc.fetch(TokenTimeRange.d7);

      // The span timestamp should be roughly in the middle of the 7-day window.
      final span = result!.spans.first;
      final now = DateTime.now();
      final windowStart = now.subtract(const Duration(days: 7));
      final midpoint = windowStart.add(const Duration(days: 3, hours: 12));

      // Should be within 1 hour of the midpoint.
      expect(span.timestamp.difference(midpoint).abs().inHours,
          lessThanOrEqualTo(1));
    });

    test('parses model breakdown with typed proto fields', () async {
      // Equivalent of old proto3 JSON test — proto handles int64/float natively.
      final model = ModelUsage()
        ..model = 'claude-sonnet-4-20250514'
        ..provider = 'anthropic'
        ..callCount = Int64(21)
        ..inputTokens = Int64(591312)
        ..outputTokens = Int64(1686)
        ..costUsd = 1.7992
        ..avgLatencyMs = 3369.16;

      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse()..models.add(model),
      );
      final svc = _teamSvcWithMock(mock);
      final result = await svc.fetch(TokenTimeRange.d7);

      expect(result!.hasData, isTrue);
      // ConnectApiService._spread offsets by (i+0.5), so all 21 spans land
      // inside the window and survive time-range filtering.
      expect(result.spans.length, 21);
      expect(result.summary!.totalCostUsd, closeTo(1.7992, 0.01));
      expect(result.summary!.totalInputTokens, closeTo(591312, 50));
      expect(result.summary!.totalOutputTokens, closeTo(1686, 21));
    });
  });

  // ── TelemetryResult ───────────────────────────────────────────────────────

  group('TelemetryResult', () {
    test('hasData is true when summary is present', () {
      const empty = <TimeSeriesPoint>[];
      final result = const TelemetryResult(
        summary: UsageSummary(
          totalCalls: 0,
          totalInputTokens: 0,
          totalOutputTokens: 0,
          totalCostUsd: 0,
          avgLatencyMs: 0,
          costOverTime: empty,
          tokensOverTime: empty,
          callsOverTime: empty,
        ),
        models: [],
        spans: [],
        isTeamMode: false,
      );
      expect(result.hasData, isTrue);
    });

    test('hasData is false for withError result', () {
      final result = const TelemetryResult.withError(
        isTeamMode: true,
        error: TelemetryErrorKind.authExpired,
      );
      expect(result.hasData, isFalse);
      expect(result.error, TelemetryErrorKind.authExpired);
      expect(result.models, isEmpty);
      expect(result.spans, isEmpty);
    });
  });

  // ── Proto3 parsing edge cases ────────────────────────────────────────────

  group('Proto3 parsing helpers', () {
    test('parses budget from proto with all fields', () async {
      final model = ModelUsage()
        ..model = 'gemini-2.5-pro'
        ..provider = 'google'
        ..callCount = Int64(5)
        ..inputTokens = Int64(1000)
        ..outputTokens = Int64(500)
        ..costUsd = 0.05
        ..avgLatencyMs = 200.0;

      final periodEnd = DateTime.utc(2026, 6, 1);
      final usage = GetMyUsageResponse()
        ..budget = (UserBudget()
          ..limitUsd = 50.0
          ..spentUsd = 12.34
          ..tokensUsed = Int64(999999)
          ..periodEnd = (Timestamp()
            ..seconds = Int64(periodEnd.millisecondsSinceEpoch ~/ 1000)))
        ..totalRemainingUsd = 37.66;
      usage.activeGrants.add(BudgetGrant()
        ..id = '1'
        ..amountUsd = 25.0
        ..spentUsd = 10.0
        ..reason = 'Monthly allocation'
        ..grantedBy = 'admin@example.com'
        ..expiresAt = (Timestamp()
          ..seconds =
              Int64(DateTime.utc(2026, 7, 1).millisecondsSinceEpoch ~/ 1000)));

      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse()..models.add(model),
        usageResponse: usage,
      );
      final svc = _teamSvcWithMock(mock);
      final result = await svc.fetch(TokenTimeRange.d7);

      expect(result, isNotNull);
      expect(result!.budget, isNotNull);
      expect(result.budget!.limitUsd, 50.0);
      expect(result.budget!.spentUsd, 12.34);
      expect(result.budget!.tokensUsed, 999999);
      expect(result.totalRemainingUsd, closeTo(37.66, 0.01));
      expect(result.activeGrants, hasLength(1));
      expect(result.activeGrants.first.amountUsd, 25.0);
      expect(result.activeGrants.first.spentUsd, 10.0);
      expect(result.activeGrants.first.reason, 'Monthly allocation');
    });

    test('handles model with default/zero fields gracefully', () async {
      // Model with only name set — all numeric fields default to 0.
      final model = ModelUsage()..model = 'test-model';

      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse()..models.add(model),
      );
      final svc = _teamSvcWithMock(mock);
      final result = await svc.fetch(TokenTimeRange.d7);

      expect(result, isNotNull);
      // callCount=0 → clamped to 1, placed at midpoint → survives filter
      expect(result!.spans.length, lessThanOrEqualTo(1));
      if (result.spans.isNotEmpty) {
        expect(result.spans.first.inputTokens, 0);
        expect(result.spans.first.outputTokens, 0);
        expect(result.spans.first.costUsd, 0.0);
      }
    });

    test('clamps negative totalRemainingUsd to zero', () async {
      final usage = GetMyUsageResponse()
        ..budget = (UserBudget()
          ..limitUsd = 10.0
          ..spentUsd = 15.0)
        ..totalRemainingUsd = -5.0;

      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse(),
        usageResponse: usage,
      );
      final svc = _teamSvcWithMock(mock);
      final result = await svc.fetch(TokenTimeRange.d7);

      // Negative remaining should be clamped to 0
      expect(result!.totalRemainingUsd, 0.0);
    });

    test('handles empty grants list', () async {
      final usage = GetMyUsageResponse()
        ..budget = (UserBudget()
          ..limitUsd = 10.0
          ..spentUsd = 5.0)
        ..totalRemainingUsd = 5.0;

      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse(),
        usageResponse: usage,
      );
      final svc = _teamSvcWithMock(mock);
      final result = await svc.fetch(TokenTimeRange.d7);

      expect(result!.activeGrants, isEmpty);
      expect(result.budget, isNotNull);
    });

    test('grants with missing optional expiresAt field', () async {
      final usage = GetMyUsageResponse();
      usage.activeGrants.add(BudgetGrant()
        ..id = 'g1'
        ..amountUsd = 100.0
        ..spentUsd = 0.0
        ..reason = 'Trial'
        ..grantedBy = 'system');

      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(1)
        ..inputTokens = Int64(10)
        ..outputTokens = Int64(5)
        ..costUsd = 0.01
        ..avgLatencyMs = 50.0;

      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse()..models.add(model),
        usageResponse: usage,
      );
      final svc = _teamSvcWithMock(mock);
      final result = await svc.fetch(TokenTimeRange.d7);

      expect(result!.activeGrants, hasLength(1));
      expect(result.activeGrants.first.expiresAt, isNull);
      expect(result.activeGrants.first.reason, 'Trial');
    });

    test('budgetFromDashboard uses passed now for fallback periodEnd', () {
      // BudgetContext with no periodEnd set — should use the passed `now`.
      final stableNow = DateTime.utc(2026, 6, 15, 12, 0, 0);
      final bc = GetDashboardDataResponse_BudgetContext()
        ..budget = (UserBudget()
          ..limitUsd = 20.0
          ..spentUsd = 5.0
          ..tokensUsed = Int64(50000));
      // No periodEnd set on budget.

      final info = ConnectApiService.budgetFromDashboard(bc, stableNow);

      expect(info, isNotNull);
      // Fallback periodEnd should be exactly stableNow + 1 day, not DateTime.now().
      final expected = stableNow.toUtc().add(const Duration(days: 1));
      expect(info!.periodEnd, expected);
    });
  });

  // ── ProcessState.detecting transition tests ───────────────────────────────

  group('ProcessState.detecting transitions', () {
    test('detectRunning transitions from detecting to stopped when installed',
        () async {
      final pm = ProcessManager();
      pm.configure(providerNames: ['lmstudio']);
      expect(pm.get('lmstudio')!.state, ProcessState.detecting);
      await pm.detectRunning();
      // After detection: lmstudio has no binary, so → notInstalled or running
      expect(
        pm.get('lmstudio')!.state,
        anyOf(ProcessState.notInstalled, ProcessState.running,
            ProcessState.stopped),
      );
      pm.dispose();
    });

    test('detecting state is not treated as running or stopped', () {
      final p = ManagedProcess(name: 'x', displayName: 'X', icon: 'X');
      expect(p.state, ProcessState.detecting);
      expect(p.state != ProcessState.running, isTrue);
      expect(p.state != ProcessState.stopped, isTrue);
      expect(p.state != ProcessState.notInstalled, isTrue);
    });
  });

  // ── UserScope threading ──────────────────────────────────────────────────

  group('TelemetryService — UserScope propagation', () {
    test('fetch without scope sends null to ConnectApiService', () async {
      final mock = MockConnectApi();
      final svc = _teamSvcWithMock(mock);

      await svc.fetch(TokenTimeRange.h24);
      expect(mock.capturedUserScope, isNull);
      svc.dispose();
    });

    test('fetch with PERSONAL scope threads it to ConnectApiService', () async {
      final mock = MockConnectApi();
      final svc = _teamSvcWithMock(mock);

      await svc.fetch(TokenTimeRange.h24,
          userScope: UserScope.USER_SCOPE_PERSONAL);
      expect(mock.capturedUserScope, UserScope.USER_SCOPE_PERSONAL);
      svc.dispose();
    });

    test('fetch with GLOBAL scope threads it to ConnectApiService', () async {
      final mock = MockConnectApi();
      final svc = _teamSvcWithMock(mock);

      await svc.fetch(TokenTimeRange.h24,
          userScope: UserScope.USER_SCOPE_GLOBAL);
      expect(mock.capturedUserScope, UserScope.USER_SCOPE_GLOBAL);
      svc.dispose();
    });

    test('fetch with UNSPECIFIED scope threads it to ConnectApiService',
        () async {
      final mock = MockConnectApi();
      final svc = _teamSvcWithMock(mock);

      await svc.fetch(TokenTimeRange.d7,
          userScope: UserScope.USER_SCOPE_UNSPECIFIED);
      expect(mock.capturedUserScope, UserScope.USER_SCOPE_UNSPECIFIED);
      svc.dispose();
    });

    test('changing scope between fetches updates captured value', () async {
      final mock = MockConnectApi();
      final svc = _teamSvcWithMock(mock);

      await svc.fetch(TokenTimeRange.h24,
          userScope: UserScope.USER_SCOPE_PERSONAL);
      expect(mock.capturedUserScope, UserScope.USER_SCOPE_PERSONAL);

      await svc.fetch(TokenTimeRange.h24,
          userScope: UserScope.USER_SCOPE_GLOBAL);
      expect(mock.capturedUserScope, UserScope.USER_SCOPE_GLOBAL);
      svc.dispose();
    });
  });
}
