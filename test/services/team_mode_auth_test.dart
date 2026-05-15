import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:candela_desktop/services/telemetry_service.dart';
import 'package:candela_desktop/models/span_stats.dart';

/// Tests for Team mode auth — verifies that the TelemetryService correctly
/// sends Bearer tokens and handles auth failures in team mode, which is the
/// root cause of "no data in desktop, but data in web."

void main() {
  group('Team mode — auth token handling', () {
    test('sends Bearer token in Authorization header', () async {
      String? capturedAuth;
      final client = MockClient((req) async {
        capturedAuth ??= req.headers['Authorization'];
        return http.Response(jsonEncode({'models': []}), 200);
      });
      final svc = TelemetryService(
        remoteUrl: 'https://candela.example.com',
        authToken: 'id-token-from-gcloud',
        httpClient: client,
      );
      await svc.fetch(TokenTimeRange.h24);
      expect(capturedAuth, 'Bearer id-token-from-gcloud');
    });

    test('ID token (JWT) is accepted as authToken', () async {
      // Simulate an ID token (3-part JWT format)
      final header =
          base64Url.encode(utf8.encode('{"alg":"RS256","typ":"JWT"}'));
      final payload = base64Url
          .encode(utf8.encode('{"exp":4102444800,"email":"user@corp.com"}'));
      final idToken = '$header.$payload.signature';

      String? capturedAuth;
      final client = MockClient((req) async {
        capturedAuth ??= req.headers['Authorization'];
        return http.Response(jsonEncode({'models': []}), 200);
      });
      final svc = TelemetryService(
        remoteUrl: 'https://candela.example.com',
        authToken: idToken,
        httpClient: client,
      );
      await svc.fetch(TokenTimeRange.h24);
      expect(capturedAuth, 'Bearer $idToken');
    });

    test('401 response returns authExpired error', () async {
      final client =
          MockClient((req) async => http.Response('Unauthorized', 401));
      final svc = TelemetryService(
        remoteUrl: 'https://candela.example.com',
        authToken: 'expired-token',
        httpClient: client,
      );
      final result = await svc.fetch(TokenTimeRange.h24);
      expect(result!.error, TelemetryErrorKind.authExpired);
      expect(result.hasData, isFalse);
    });

    test('null authToken omits Authorization header', () async {
      bool hasAuthHeader = false;
      final client = MockClient((req) async {
        hasAuthHeader = req.headers.containsKey('Authorization');
        return http.Response(
            jsonEncode({'cost_over_time': [], 'tokens_over_time': []}), 200);
      });
      final svc = TelemetryService(
        remoteUrl: 'https://candela.example.com',
        authToken: null,
        httpClient: client,
      );
      await svc.fetch(TokenTimeRange.h24);
      expect(hasAuthHeader, isFalse);
    });
  });

  group('Team mode — budget and grants parsing', () {
    test('parses budget from GetMyUsage response', () async {
      final usageBody = jsonEncode({
        'budget': {
          'limit_usd': 10.0,
          'spent_usd': 3.50,
          'tokens_used': 150000,
          'period_end': DateTime.now()
              .toUtc()
              .add(const Duration(hours: 12))
              .toIso8601String(),
        },
        'active_grants': [
          {
            'id': 'grant-1',
            'amount_usd': 25.0,
            'spent_usd': 5.0,
            'reason': 'Onboarding bonus',
            'granted_by': 'admin@corp.com',
          }
        ],
        'total_remaining_usd': 26.50,
      });

      final client = MockClient((req) async {
        if (req.url.path.contains('GetMyUsage')) {
          return http.Response(usageBody, 200);
        }
        return http.Response(jsonEncode({'models': []}), 200);
      });

      final svc = TelemetryService(
        remoteUrl: 'https://candela.example.com',
        authToken: 'valid-token',
        httpClient: client,
      );
      final result = await svc.fetch(TokenTimeRange.h24);

      expect(result, isNotNull);
      expect(result!.budget, isNotNull);
      expect(result.budget!.limitUsd, 10.0);
      expect(result.budget!.spentUsd, 3.50);
      expect(result.activeGrants.length, 1);
      expect(result.activeGrants.first.reason, 'Onboarding bonus');
      expect(result.totalRemainingUsd, 26.50);
    });

    test('handles missing budget gracefully', () async {
      final client = MockClient((req) async {
        if (req.url.path.contains('GetMyUsage')) {
          return http.Response(jsonEncode({}), 200);
        }
        return http.Response(jsonEncode({'models': []}), 200);
      });

      final svc = TelemetryService(
        remoteUrl: 'https://candela.example.com',
        authToken: 'valid-token',
        httpClient: client,
      );
      final result = await svc.fetch(TokenTimeRange.h24);

      expect(result, isNotNull);
      expect(result!.budget, isNull);
      expect(result.activeGrants, isEmpty);
    });

    test('GetMyUsage failure is non-fatal', () async {
      final modelsBody = jsonEncode({
        'models': [
          {
            'model': 'claude-sonnet-4',
            'provider': 'anthropic',
            'call_count': 3,
            'input_tokens': 1000,
            'output_tokens': 500,
            'cost_usd': 0.05,
            'avg_latency_ms': 800.0,
          }
        ]
      });

      final client = MockClient((req) async {
        if (req.url.path.contains('GetMyUsage')) {
          return http.Response('Internal Error', 500);
        }
        if (req.url.path.contains('GetModelBreakdown')) {
          return http.Response(modelsBody, 200);
        }
        return http.Response(
            jsonEncode({'cost_over_time': [], 'tokens_over_time': []}), 200);
      });

      final svc = TelemetryService(
        remoteUrl: 'https://candela.example.com',
        authToken: 'valid-token',
        httpClient: client,
      );
      final result = await svc.fetch(TokenTimeRange.d7);

      // Should still have span data even though budget call failed.
      expect(result, isNotNull);
      expect(result!.budget, isNull);
      expect(result.spans, isNotEmpty);
    });
  });

  group('Team mode — ConnectRPC endpoints', () {
    test('calls correct ConnectRPC paths', () async {
      final paths = <String>[];
      final client = MockClient((req) async {
        paths.add(req.url.path);
        return http.Response(jsonEncode({'models': []}), 200);
      });

      final svc = TelemetryService(
        remoteUrl: 'https://candela.example.com',
        authToken: 'token',
        httpClient: client,
      );
      await svc.fetch(TokenTimeRange.h24);

      expect(paths, contains('/candela.v1.DashboardService/GetUsageSummary'));
      expect(paths, contains('/candela.v1.DashboardService/GetModelBreakdown'));
      expect(paths, contains('/candela.v1.DashboardService/GetMyUsage'));
    });

    test('sends Connect-Protocol-Version header', () async {
      String? protocolVersion;
      final client = MockClient((req) async {
        protocolVersion ??= req.headers['Connect-Protocol-Version'];
        return http.Response(jsonEncode({'models': []}), 200);
      });

      final svc = TelemetryService(
        remoteUrl: 'https://candela.example.com',
        authToken: 'token',
        httpClient: client,
      );
      await svc.fetch(TokenTimeRange.h24);
      expect(protocolVersion, '1');
    });
  });
}
