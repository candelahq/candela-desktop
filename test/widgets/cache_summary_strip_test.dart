import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/data/cache_efficiency.dart';
import 'package:candela_desktop/theme/colors.dart';
import 'package:candela_desktop/widgets/cache_summary_strip.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: ThemeData.dark(),
  home: Scaffold(
    backgroundColor: CandelaColors.bgPrimary,
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

void main() {
  group('CacheSummaryStrip', () {
    testWidgets('renders read, write, hit rate with tier and cache cost', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const CacheSummaryStrip(
            cache: CacheTelemetry(
              readTokens: 1200,
              creationTokens: 300,
              promptTokens: 4000,
              costUsd: 0.42,
            ),
          ),
        ),
      );

      expect(find.text('CACHE'), findsOneWidget);
      expect(find.text('Read'), findsOneWidget);
      expect(find.text('1.2k'), findsOneWidget);
      expect(find.text('Write'), findsOneWidget);
      expect(find.text('300'), findsOneWidget);
      expect(find.text('Hit rate'), findsOneWidget);
      expect(find.text('30.0% Good'), findsOneWidget);
      expect(find.text('Cache cost'), findsOneWidget);
      expect(find.text('\$0.42'), findsOneWidget);
    });

    testWidgets('dashes the hit rate when the prompt size is unknown', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const CacheSummaryStrip(
            cache: CacheTelemetry(readTokens: 800, costUsd: 0.03),
          ),
        ),
      );

      expect(find.text('Hit rate'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
      expect(find.text('\$0.03'), findsOneWidget);
    });

    testWidgets('dashes the cache cost when the span has no cost', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const CacheSummaryStrip(
            cache: CacheTelemetry(readTokens: 500, promptTokens: 1000),
          ),
        ),
      );

      expect(find.text('50.0% Excellent'), findsOneWidget);
      expect(find.text('Cache cost'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
    });

    testWidgets('shows the proxy TTL only when one is supplied', (
      tester,
    ) async {
      const cache = CacheTelemetry(
        readTokens: 500,
        creationTokens: 100,
        promptTokens: 1000,
      );

      await tester.pumpWidget(_wrap(const CacheSummaryStrip(cache: cache)));
      expect(find.text('Proxy cache TTL'), findsNothing);

      await tester.pumpWidget(
        _wrap(CacheSummaryStrip(cache: cache.withTtl('1h'))),
      );
      expect(find.text('Proxy cache TTL'), findsOneWidget);
      expect(find.text('1h'), findsOneWidget);
    });

    testWidgets('renders nothing when no cache tokens were recorded', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const CacheSummaryStrip(
            cache: CacheTelemetry(promptTokens: 1000, ttl: '5m'),
          ),
        ),
      );

      expect(find.text('CACHE'), findsNothing);
      expect(find.text('Cache cost'), findsNothing);
      expect(find.text('Proxy cache TTL'), findsNothing);
    });

    testWidgets('creation-only activity shows an unknown rate', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CacheSummaryStrip(
            cache: CacheTelemetry(creationTokens: 900, promptTokens: 1000),
          ),
        ),
      );

      expect(find.text('900'), findsOneWidget);
      expect(find.textContaining('%'), findsNothing);
      expect(find.text('—'), findsNWidgets(2));
    });
  });
}
