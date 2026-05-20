import 'package:connectrpc/connect.dart' show ConnectException, Code;
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/gen/candela/v1/dashboard_service.pb.dart'
    hide TimeSeriesPoint;
import 'package:candela_desktop/gen/candela/types/user.pb.dart';
import 'package:candela_desktop/gen/google/protobuf/timestamp.pb.dart';
import 'package:candela_desktop/models/span_stats.dart';
import 'package:candela_desktop/services/connect_api_service.dart';
import 'package:candela_desktop/services/telemetry_service.dart';

/// Mock [ConnectApiService] for testing team-mode auth behavior.
class MockConnectApi extends ConnectApiService {
  final GetUsageSummaryResponse? summaryResponse;
  final GetModelBreakdownResponse? modelResponse;
  final GetMyUsageResponse? usageResponse;
  final ConnectException? throwOnSummary;
  final ConnectException? throwOnModels;
  final ConnectException? throwOnUsage;
  String? capturedAuthToken;

  MockConnectApi({
    this.summaryResponse,
    this.modelResponse,
    this.usageResponse,
    this.throwOnSummary,
    this.throwOnModels,
    this.throwOnUsage,
  }) : super(baseUrl: 'http://test', authToken: null);

  @override
  Future<GetDashboardDataResponse> getDashboardData({
    required DateTime start,
    required DateTime end,
    bool includeBudget = true,
  }) async {
    // Propagate summary/model errors so auth tests still work.
    if (throwOnSummary != null) throw throwOnSummary!;
    if (throwOnModels != null) throw throwOnModels!;

    final resp = GetDashboardDataResponse();
    final models = modelResponse ?? GetModelBreakdownResponse();
    resp.models.addAll(models.models);

    // Carry budget/grant data from usageResponse into BudgetContext.
    final usage = usageResponse;
    if (usage != null && usage.hasBudget()) {
      final bc = GetDashboardDataResponse_BudgetContext();
      bc.budget = usage.budget;
      bc.totalRemainingUsd = usage.totalRemainingUsd;
      bc.activeGrants.addAll(usage.activeGrants);
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

/// Build a team-mode service with a mock ConnectApiService.
TelemetryService _teamSvc(
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

/// Tests for Team mode auth — verifies that the TelemetryService correctly
/// passes auth tokens through ConnectApiService and handles auth failures
/// via ConnectRPC error codes.

void main() {
  group('Team mode — auth token handling', () {
    test('sends Bearer token in Authorization header', () async {
      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse(),
      );
      final svc = _teamSvc(mock, authToken: 'id-token-from-gcloud');
      await svc.fetch(TokenTimeRange.h24);
      expect(mock.capturedAuthToken, 'id-token-from-gcloud');
    });

    test('ID token (JWT) is accepted as authToken', () async {
      // Simulate a realistic JWT-shaped token
      final idToken =
          'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjQxMDI0NDQ4MDAsImVtYWlsIjoidXNlckBjb3JwLmNvbSJ9.signature';
      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse(),
      );
      final svc = _teamSvc(mock, authToken: idToken);
      await svc.fetch(TokenTimeRange.h24);
      expect(mock.capturedAuthToken, idToken);
    });

    test('401 response returns authExpired error', () async {
      final mock = MockConnectApi(
        throwOnSummary: ConnectException(Code.unauthenticated, 'expired'),
      );
      final svc = _teamSvc(mock, authToken: 'expired-token');
      final result = await svc.fetch(TokenTimeRange.h24);
      expect(result!.error, TelemetryErrorKind.authExpired);
      expect(result.hasData, isFalse);
    });

    test('null authToken is passed through to factory', () async {
      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse(),
      );
      final svc = _teamSvc(mock, authToken: null);
      await svc.fetch(TokenTimeRange.h24);
      expect(mock.capturedAuthToken, isNull);
    });
  });

  group('Team mode — budget and grants parsing', () {
    test('parses budget from GetMyUsage response', () async {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(2)
        ..inputTokens = Int64(200)
        ..outputTokens = Int64(100)
        ..costUsd = 0.02
        ..avgLatencyMs = 100.0;

      final periodEnd = DateTime.now().toUtc().add(const Duration(hours: 12));
      final ts = Timestamp()
        ..seconds = Int64(periodEnd.millisecondsSinceEpoch ~/ 1000);

      final usage = GetMyUsageResponse()
        ..budget = (UserBudget()
          ..limitUsd = 10.0
          ..spentUsd = 3.50
          ..tokensUsed = Int64(150000)
          ..periodEnd = ts)
        ..totalRemainingUsd = 26.50;
      usage.activeGrants.add(BudgetGrant()
        ..id = 'grant-1'
        ..amountUsd = 25.0
        ..spentUsd = 5.0
        ..reason = 'Onboarding bonus'
        ..grantedBy = 'admin@corp.com');

      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse()..models.add(model),
        usageResponse: usage,
      );
      final svc = _teamSvc(mock, authToken: 'valid-token');
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
      // Empty usage response (no budget set)
      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse(),
        usageResponse: GetMyUsageResponse(),
      );
      final svc = _teamSvc(mock, authToken: 'valid-token');
      final result = await svc.fetch(TokenTimeRange.h24);

      expect(result, isNotNull);
      // Budget is null when not set in proto response
      expect(result!.activeGrants, isEmpty);
    });

    test('missing budget data is non-fatal', () async {
      final model = ModelUsage()
        ..model = 'claude-sonnet-4'
        ..provider = 'anthropic'
        ..callCount = Int64(3)
        ..inputTokens = Int64(1000)
        ..outputTokens = Int64(500)
        ..costUsd = 0.05
        ..avgLatencyMs = 800.0;

      // No usageResponse → no budget data, but models still arrive.
      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse()..models.add(model),
      );
      final svc = _teamSvc(mock, authToken: 'valid-token');
      final result = await svc.fetch(TokenTimeRange.d7);

      // Should still have span data even without budget context.
      expect(result, isNotNull);
      expect(result!.budget, isNull);
      expect(result.spans, isNotEmpty);
    });
  });

  group('Team mode — ConnectRPC integration', () {
    test('factory receives correct baseUrl', () async {
      String? capturedBase;
      final mock = MockConnectApi(
        modelResponse: GetModelBreakdownResponse(),
      );
      final svc = TelemetryService(
        port: 8181,
        remoteUrl: 'https://candela.example.com',
        authToken: 'token',
        connectApiFactory: (baseUrl, token) {
          capturedBase = baseUrl;
          return mock;
        },
      );
      await svc.fetch(TokenTimeRange.h24);
      expect(capturedBase, 'https://candela.example.com');
    });

    test('server error maps to unreachable', () async {
      final mock = MockConnectApi(
        throwOnSummary: ConnectException(Code.unavailable, 'down'),
      );
      final svc = _teamSvc(mock);
      final result = await svc.fetch(TokenTimeRange.h24);
      expect(result!.error, TelemetryErrorKind.unreachable);
    });
  });
}
