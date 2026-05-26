import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/gen/candela/v1/dashboard_service.pb.dart';
import 'package:candela_desktop/gen/candela/types/user.pb.dart';
import 'package:candela_desktop/gen/google/protobuf/timestamp.pb.dart';
import 'package:candela_desktop/models/budget_info.dart';
import 'package:candela_desktop/services/connect_api_service.dart';

/// Unit tests for [ConnectApiService] static domain-conversion helpers.
///
/// These methods contain all the proto → domain-model mapping logic that
/// replaced the old manual JSON parsing.

void main() {
  // ── spansFromModels ─────────────────────────────────────────────────────

  group('ConnectApiService.spansFromModels', () {
    final start = DateTime.utc(2026, 5, 10);
    final end = DateTime.utc(2026, 5, 17);

    test('returns empty list for empty models', () {
      final spans = ConnectApiService.spansFromModels([], start, end);
      expect(spans, isEmpty);
    });

    test('produces correct span count matching callCount', () {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(5)
        ..inputTokens = Int64(500)
        ..outputTokens = Int64(250)
        ..costUsd = 0.05
        ..avgLatencyMs = 200.0;

      final spans = ConnectApiService.spansFromModels([model], start, end);
      expect(spans.length, 5);
    });

    test('distributes tokens evenly across spans', () {
      final model = ModelUsage()
        ..model = 'claude-3'
        ..provider = 'anthropic'
        ..callCount = Int64(4)
        ..inputTokens = Int64(400)
        ..outputTokens = Int64(200)
        ..costUsd = 0.04
        ..avgLatencyMs = 100.0;

      final spans = ConnectApiService.spansFromModels([model], start, end);
      expect(spans.every((s) => s.inputTokens == 100), isTrue);
      expect(spans.every((s) => s.outputTokens == 50), isTrue);
      expect(spans.every((s) => s.totalTokens == 150), isTrue);
    });

    test('distributes cost evenly across spans', () {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(4)
        ..inputTokens = Int64(100)
        ..outputTokens = Int64(50)
        ..costUsd = 1.0
        ..avgLatencyMs = 100.0;

      final spans = ConnectApiService.spansFromModels([model], start, end);
      expect(spans.every((s) => s.costUsd == 0.25), isTrue);
    });

    test('clamps callCount to maxSyntheticSpans', () {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(999999)
        ..inputTokens = Int64(100)
        ..outputTokens = Int64(50)
        ..costUsd = 1.0
        ..avgLatencyMs = 100.0;

      final spans = ConnectApiService.spansFromModels([model], start, end);
      expect(spans.length, 1000);
    });

    test('custom maxSyntheticSpans is respected', () {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(500)
        ..inputTokens = Int64(100)
        ..outputTokens = Int64(50)
        ..costUsd = 1.0
        ..avgLatencyMs = 100.0;

      final spans = ConnectApiService.spansFromModels(
        [model],
        start,
        end,
        maxSyntheticSpans: 100,
      );
      expect(spans.length, 100);
    });

    test('defaults empty model name to "unknown"', () {
      final model = ModelUsage()
        ..model = ''
        ..provider = 'openai'
        ..callCount = Int64(1)
        ..inputTokens = Int64(10)
        ..outputTokens = Int64(5)
        ..costUsd = 0.01
        ..avgLatencyMs = 50.0;

      final spans = ConnectApiService.spansFromModels([model], start, end);
      expect(spans.first.model, 'unknown');
    });

    test('defaults empty provider to "team"', () {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = ''
        ..callCount = Int64(1)
        ..inputTokens = Int64(10)
        ..outputTokens = Int64(5)
        ..costUsd = 0.01
        ..avgLatencyMs = 50.0;

      final spans = ConnectApiService.spansFromModels([model], start, end);
      expect(spans.first.provider, 'team');
    });

    test('spreads timestamps across the window', () {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(3)
        ..inputTokens = Int64(30)
        ..outputTokens = Int64(15)
        ..costUsd = 0.03
        ..avgLatencyMs = 100.0;

      final spans = ConnectApiService.spansFromModels([model], start, end);
      // All timestamps should be within the window.
      for (final s in spans) {
        expect(s.timestamp.isAfter(start) || s.timestamp == start, isTrue);
        expect(s.timestamp.isBefore(end), isTrue);
      }
      // Timestamps should be in ascending order.
      for (var i = 1; i < spans.length; i++) {
        expect(spans[i].timestamp.isAfter(spans[i - 1].timestamp), isTrue);
      }
    });

    test('single callCount places span at window midpoint', () {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(1)
        ..inputTokens = Int64(10)
        ..outputTokens = Int64(5)
        ..costUsd = 0.01
        ..avgLatencyMs = 50.0;

      final spans = ConnectApiService.spansFromModels([model], start, end);
      final midpoint = start.add(
          Duration(milliseconds: end.difference(start).inMilliseconds ~/ 2));
      expect(
        spans.first.timestamp.difference(midpoint).abs().inMinutes,
        lessThan(1),
      );
    });

    test('handles multiple models correctly', () {
      final m1 = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(2)
        ..inputTokens = Int64(200)
        ..outputTokens = Int64(100)
        ..costUsd = 0.02
        ..avgLatencyMs = 100.0;
      final m2 = ModelUsage()
        ..model = 'claude-3'
        ..provider = 'anthropic'
        ..callCount = Int64(3)
        ..inputTokens = Int64(300)
        ..outputTokens = Int64(150)
        ..costUsd = 0.06
        ..avgLatencyMs = 200.0;

      final spans = ConnectApiService.spansFromModels([m1, m2], start, end);
      expect(spans.length, 5);
      expect(spans.where((s) => s.model == 'gpt-4o').length, 2);
      expect(spans.where((s) => s.model == 'claude-3').length, 3);
    });

    test('callCount of 0 is clamped to 1', () {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(0)
        ..inputTokens = Int64(10)
        ..outputTokens = Int64(5)
        ..costUsd = 0.01
        ..avgLatencyMs = 50.0;

      final spans = ConnectApiService.spansFromModels([model], start, end);
      expect(spans.length, 1);
    });
  });

  // ── budgetFromProto ───────────────────────────────────────────────────────

  group('ConnectApiService.budgetFromProto', () {
    test('returns null when budget is not set', () {
      final resp = GetMyUsageResponse();
      expect(ConnectApiService.budgetFromProto(resp), isNull);
    });

    test('parses budget fields correctly', () {
      final periodEnd = DateTime.utc(2026, 5, 17, 12, 0);
      final resp = GetMyUsageResponse()
        ..budget = (UserBudget()
          ..limitUsd = 50.0
          ..spentUsd = 12.5
          ..tokensUsed = Int64(500000)
          ..periodEnd = (Timestamp()
            ..seconds = Int64(periodEnd.millisecondsSinceEpoch ~/ 1000)));

      final budget = ConnectApiService.budgetFromProto(resp);
      expect(budget, isNotNull);
      expect(budget!.limitUsd, 50.0);
      expect(budget.spentUsd, 12.5);
      expect(budget.tokensUsed, 500000);
      expect(budget.period, BudgetPeriodKind.daily);
    });

    test('defaults periodEnd when not set', () {
      final resp = GetMyUsageResponse()
        ..budget = (UserBudget()
          ..limitUsd = 10.0
          ..spentUsd = 0.0
          ..tokensUsed = Int64(0));

      final budget = ConnectApiService.budgetFromProto(resp);
      expect(budget, isNotNull);
      // Should default to approximately now + 1 day.
      expect(
        budget!.periodEnd.isAfter(DateTime.now().toUtc()),
        isTrue,
      );
    });
  });

  // ── grantsFromProto ───────────────────────────────────────────────────────

  group('ConnectApiService.grantsFromProto', () {
    test('returns empty list when no grants', () {
      final resp = GetMyUsageResponse();
      expect(ConnectApiService.grantsFromProto(resp), isEmpty);
    });

    test('parses grant fields correctly', () {
      final expiresAt = DateTime.utc(2026, 6, 1);
      final resp = GetMyUsageResponse();
      resp.activeGrants.add(BudgetGrant()
        ..id = 'g-1'
        ..amountUsd = 100.0
        ..spentUsd = 25.0
        ..reason = 'Project allocation'
        ..grantedBy = 'admin@co.com'
        ..expiresAt = (Timestamp()
          ..seconds = Int64(expiresAt.millisecondsSinceEpoch ~/ 1000)));

      final grants = ConnectApiService.grantsFromProto(resp);
      expect(grants.length, 1);
      expect(grants.first.id, 'g-1');
      expect(grants.first.amountUsd, 100.0);
      expect(grants.first.spentUsd, 25.0);
      expect(grants.first.reason, 'Project allocation');
      expect(grants.first.grantedBy, 'admin@co.com');
      expect(grants.first.expiresAt, isNotNull);
    });

    test('handles grant without expiresAt', () {
      final resp = GetMyUsageResponse();
      resp.activeGrants.add(BudgetGrant()
        ..id = 'g-2'
        ..amountUsd = 50.0
        ..spentUsd = 0.0
        ..reason = 'Trial');

      final grants = ConnectApiService.grantsFromProto(resp);
      expect(grants.first.expiresAt, isNull);
    });

    test('parses multiple grants', () {
      final resp = GetMyUsageResponse();
      resp.activeGrants.addAll([
        BudgetGrant()
          ..id = 'g-1'
          ..amountUsd = 10.0
          ..spentUsd = 5.0
          ..reason = 'A',
        BudgetGrant()
          ..id = 'g-2'
          ..amountUsd = 20.0
          ..spentUsd = 0.0
          ..reason = 'B',
        BudgetGrant()
          ..id = 'g-3'
          ..amountUsd = 30.0
          ..spentUsd = 15.0
          ..reason = 'C',
      ]);

      final grants = ConnectApiService.grantsFromProto(resp);
      expect(grants.length, 3);
      expect(grants.map((g) => g.id).toList(), ['g-1', 'g-2', 'g-3']);
    });
  });

  // ── modelBreakdownsFromProto ─────────────────────────────────────────────

  group('ConnectApiService.modelBreakdownsFromProto', () {
    test('returns empty list for empty models', () {
      final result = ConnectApiService.modelBreakdownsFromProto([]);
      expect(result, isEmpty);
    });

    test('converts single ModelUsage correctly', () {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(42)
        ..inputTokens = Int64(10000)
        ..outputTokens = Int64(5000)
        ..costUsd = 1.25
        ..avgLatencyMs = 300.0
        ..cacheReadTokens = Int64(2000)
        ..cacheCreationTokens = Int64(500);

      final result = ConnectApiService.modelBreakdownsFromProto([model]);
      expect(result.length, 1);
      expect(result.first.model, 'gpt-4o');
      expect(result.first.provider, 'openai');
      expect(result.first.callCount, 42);
      expect(result.first.inputTokens, 10000);
      expect(result.first.outputTokens, 5000);
      expect(result.first.costUsd, 1.25);
      expect(result.first.avgLatencyMs, 300.0);
      expect(result.first.cacheReadTokens, 2000);
      expect(result.first.cacheCreationTokens, 500);
    });

    test('aggregates same model with different providers into one row', () {
      final m1 = ModelUsage()
        ..model = 'claude-sonnet-4-20250514'
        ..provider = 'anthropic'
        ..callCount = Int64(1000)
        ..inputTokens = Int64(100000)
        ..outputTokens = Int64(50000)
        ..costUsd = 30.0
        ..avgLatencyMs = 200.0;

      final m2 = ModelUsage()
        ..model = 'claude-sonnet-4-20250514'
        ..provider = 'team'
        ..callCount = Int64(46)
        ..inputTokens = Int64(4600)
        ..outputTokens = Int64(2300)
        ..costUsd = 1.38
        ..avgLatencyMs = 250.0;

      final result = ConnectApiService.modelBreakdownsFromProto([m1, m2]);
      expect(result.length, 1, reason: 'same model should be merged');
      expect(result.first.model, 'claude-sonnet-4-20250514');
      expect(result.first.callCount, 1046);
      expect(result.first.inputTokens, 104600);
      expect(result.first.outputTokens, 52300);
      expect(result.first.costUsd, closeTo(31.38, 0.01));
    });

    test('weighted average latency is computed correctly', () {
      final m1 = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(100)
        ..inputTokens = Int64(1000)
        ..outputTokens = Int64(500)
        ..costUsd = 1.0
        ..avgLatencyMs = 200.0;

      final m2 = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'azure'
        ..callCount = Int64(100)
        ..inputTokens = Int64(1000)
        ..outputTokens = Int64(500)
        ..costUsd = 1.0
        ..avgLatencyMs = 400.0;

      final result = ConnectApiService.modelBreakdownsFromProto([m1, m2]);
      // (100*200 + 100*400) / 200 = 300
      expect(result.first.avgLatencyMs, closeTo(300.0, 0.01));
    });

    test('results are sorted by cost descending', () {
      final cheap = ModelUsage()
        ..model = 'gemini-flash'
        ..provider = 'google'
        ..callCount = Int64(100)
        ..inputTokens = Int64(1000)
        ..outputTokens = Int64(500)
        ..costUsd = 0.01
        ..avgLatencyMs = 50.0;

      final expensive = ModelUsage()
        ..model = 'claude-opus'
        ..provider = 'anthropic'
        ..callCount = Int64(10)
        ..inputTokens = Int64(500)
        ..outputTokens = Int64(250)
        ..costUsd = 5.0
        ..avgLatencyMs = 500.0;

      final result =
          ConnectApiService.modelBreakdownsFromProto([cheap, expensive]);
      expect(result.first.model, 'claude-opus');
      expect(result.last.model, 'gemini-flash');
    });

    test('defaults empty model name to "unknown"', () {
      final model = ModelUsage()
        ..model = ''
        ..provider = 'openai'
        ..callCount = Int64(1)
        ..inputTokens = Int64(10)
        ..outputTokens = Int64(5)
        ..costUsd = 0.01
        ..avgLatencyMs = 50.0;

      final result = ConnectApiService.modelBreakdownsFromProto([model]);
      expect(result.first.model, 'unknown');
    });

    test('defaults empty provider to "team"', () {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = ''
        ..callCount = Int64(1)
        ..inputTokens = Int64(10)
        ..outputTokens = Int64(5)
        ..costUsd = 0.01
        ..avgLatencyMs = 50.0;

      final result = ConnectApiService.modelBreakdownsFromProto([model]);
      expect(result.first.provider, 'team');
    });

    test('preserves real call count above 1000 (no clamping)', () {
      final model = ModelUsage()
        ..model = 'gpt-4o'
        ..provider = 'openai'
        ..callCount = Int64(5000)
        ..inputTokens = Int64(500000)
        ..outputTokens = Int64(250000)
        ..costUsd = 50.0
        ..avgLatencyMs = 100.0;

      final result = ConnectApiService.modelBreakdownsFromProto([model]);
      expect(result.first.callCount, 5000,
          reason: 'real call count must not be clamped to 1000');
    });
  });
}
