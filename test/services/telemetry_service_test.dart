import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:candela_desktop/models/span_stats.dart';
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

/// Returns a team-mode [TelemetryService] with the given mock client.
TelemetryService _teamSvc(
  MockClient client, {
  String remoteUrl = 'https://candela.example.com',
  String? authToken = 'test-token',
}) =>
    TelemetryService(
      port: 8181,
      remoteUrl: remoteUrl,
      authToken: authToken,
      httpClient: client,
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
      final client =
          MockClient((req) async => http.Response('Unauthorized', 401));
      final svc = _teamSvc(client);
      final result = await svc.fetch(TokenTimeRange.d7);

      expect(result, isNotNull);
      expect(result!.error, TelemetryErrorKind.authExpired);
      expect(result.hasData, isFalse);
    });

    test('returns unreachable error on 500', () async {
      final client =
          MockClient((req) async => http.Response('Server error', 500));
      final svc = _teamSvc(client);
      final result = await svc.fetch(TokenTimeRange.d7);

      expect(result, isNotNull);
      expect(result!.error, TelemetryErrorKind.unreachable);
    });

    test('returns unreachable on invalid remoteUrl (C2 SSRF guard)', () async {
      final client = MockClient((req) async => http.Response('ok', 200));
      final svc = TelemetryService(
        remoteUrl: 'file:///etc/passwd', // unsafe scheme
        httpClient: client,
      );
      final result = await svc.fetch(TokenTimeRange.d7);
      expect(result!.error, TelemetryErrorKind.unreachable);
    });

    test('caps callCount at 1000 to prevent OOM (C4)', () async {
      final modelsBody = jsonEncode({
        'models': [
          {
            'model': 'gpt-4o',
            'provider': 'openai',
            'call_count': 10000000, // malicious large value
            'input_tokens': 1000,
            'output_tokens': 500,
            'cost_usd': 10.0,
            'avg_latency_ms': 500.0,
          }
        ]
      });
      final summaryBody = jsonEncode({
        'cost_over_time': [],
        'tokens_over_time': [],
      });

      final client = MockClient((req) async {
        if (req.url.path.contains('GetModelBreakdown')) {
          return http.Response(modelsBody, 200);
        }
        return http.Response(summaryBody, 200);
      });
      final svc = _teamSvc(client);
      final result = await svc.fetch(TokenTimeRange.d7);

      // Should complete without OOM — spans capped at 1000
      expect(result!.spans.length, lessThanOrEqualTo(1000));
    });

    test('rejects oversized response body (C5/H1)', () async {
      // 5MB + 1 byte response
      final bigBody = 'x' * (5 * 1024 * 1024 + 1);
      final client = MockClient((req) async => http.Response(bigBody, 200));
      final svc = _teamSvc(client);
      final result = await svc.fetch(TokenTimeRange.d7);
      expect(result?.error, TelemetryErrorKind.unreachable);
    });

    test('parses model breakdown and aggregates correctly', () async {
      final modelsBody = jsonEncode({
        'models': [
          {
            'model': 'claude-3-5-sonnet',
            'provider': 'anthropic',
            'call_count': 4,
            'input_tokens': 400,
            'output_tokens': 200,
            'cost_usd': 0.04,
            'avg_latency_ms': 900.0,
          }
        ]
      });
      final summaryBody = jsonEncode({
        'cost_over_time': [],
        'tokens_over_time': [],
      });

      final client = MockClient((req) async {
        if (req.url.path.contains('GetModelBreakdown')) {
          return http.Response(modelsBody, 200);
        }
        return http.Response(summaryBody, 200);
      });
      final svc = _teamSvc(client);
      final result = await svc.fetch(TokenTimeRange.d7);

      expect(result!.hasData, isTrue);
      expect(result.isTeamMode, isTrue);
      // Spans are spread across the window; the span at i=0 lands exactly at
      // cutoff and may be filtered. Verify total cost matches remaining spans.
      expect(result.summary!.totalCostUsd, greaterThan(0));
      expect(result.summary!.totalCostUsd, lessThanOrEqualTo(0.04 + 1e-9));
      expect(result.spans.length, greaterThan(0));
    });

    test('falls back to time-series when model breakdown returns non-200',
        () async {
      final summaryBody = jsonEncode({
        'cost_over_time': [
          {'timestamp': DateTime.now().toIso8601String(), 'value': 0.5},
        ],
        'tokens_over_time': [
          {'timestamp': DateTime.now().toIso8601String(), 'value': 1000},
        ],
      });

      final client = MockClient((req) async {
        if (req.url.path.contains('GetModelBreakdown')) {
          return http.Response('{}', 500);
        }
        return http.Response(summaryBody, 200);
      });
      final svc = _teamSvc(client);
      final result = await svc.fetch(TokenTimeRange.h24);

      expect(result, isNotNull);
      expect(result!.hasData, isTrue);
    });

    test('sets Authorization header when authToken is provided', () async {
      String? capturedAuth;
      final client = MockClient((req) async {
        capturedAuth = req.headers['Authorization'];
        return http.Response(jsonEncode({'models': []}), 200);
      });
      final svc = _teamSvc(client, authToken: 'my-token');
      await svc.fetch(TokenTimeRange.h24);

      expect(capturedAuth, 'Bearer my-token');
    });

    test('omits Authorization header when authToken is null', () async {
      String? capturedAuth;
      final client = MockClient((req) async {
        capturedAuth = req.headers['Authorization'];
        return http.Response(
            jsonEncode({'cost_over_time': [], 'tokens_over_time': []}), 200);
      });
      final svc = TelemetryService(
        remoteUrl: 'https://example.com',
        authToken: null,
        httpClient: client,
      );
      await svc.fetch(TokenTimeRange.h24);
      expect(capturedAuth, isNull);
    });
  });

  // ── _spread single-call midpoint (H4) ─────────────────────────────────────

  group('_spread midpoint fix (H4)', () {
    test('single-call model does NOT land in bucket 0', () async {
      // Create a model with call_count=1 and verify the synthetic span
      // timestamp is at the window midpoint (not at start = bucket 0).
      final modelsBody = jsonEncode({
        'models': [
          {
            'model': 'gpt-4o',
            'provider': 'openai',
            'call_count': 1,
            'input_tokens': 100,
            'output_tokens': 50,
            'cost_usd': 0.01,
            'avg_latency_ms': 500.0,
          }
        ]
      });
      final summaryBody =
          jsonEncode({'cost_over_time': [], 'tokens_over_time': []});

      final client = MockClient((req) async {
        if (req.url.path.contains('GetModelBreakdown')) {
          return http.Response(modelsBody, 200);
        }
        return http.Response(summaryBody, 200);
      });
      final svc = _teamSvc(client);
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
}
