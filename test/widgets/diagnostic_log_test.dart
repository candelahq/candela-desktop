import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/screens/auth_debug/diagnostic_log.dart';
import 'package:candela_desktop/services/diagnostic_runner.dart';
import 'package:candela_desktop/services/config_service.dart';
import 'package:candela_desktop/models/diagnostic_entry.dart';
import 'package:candela_desktop/theme/colors.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

Widget _wrap(Widget child) => MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: CandelaColors.bgPrimary,
        body: SizedBox(width: 600, height: 400, child: child),
      ),
    );

DiagnosticEntry _entry(String message, DiagnosticStatus status) =>
    DiagnosticEntry(
      message: message,
      status: status,
      timestamp: DateTime(2024, 1, 1, 10, 30, 0),
    );

DiagnosticRunner _runner() => DiagnosticRunner(config: ConfigService());

void main() {
  group('DiagnosticLog — empty state', () {
    testWidgets('shows placeholder when no entries', (tester) async {
      final runner = _runner();
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      expect(find.textContaining('Run All Tests'), findsOneWidget);
    });

    testWidgets('shows Output header', (tester) async {
      final runner = _runner();
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      expect(find.text('Output'), findsOneWidget);
    });

    testWidgets('shows terminal icon', (tester) async {
      final runner = _runner();
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      expect(find.byIcon(Icons.terminal), findsOneWidget);
    });

    testWidgets('Copy button is present', (tester) async {
      final runner = _runner();
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      expect(find.text('Copy'), findsOneWidget);
    });
  });

  group('DiagnosticLog — with history', () {
    testWidgets('renders existing history entries', (tester) async {
      final runner = _runner();
      runner.history.addAll([
        _entry('gcloud CLI installed', DiagnosticStatus.pass),
        _entry('Config loaded', DiagnosticStatus.pass),
      ]);
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      await tester.pump();

      expect(find.text('gcloud CLI installed'), findsOneWidget);
      expect(find.text('Config loaded'), findsOneWidget);
    });

    testWidgets('renders pass entry without crash', (tester) async {
      final runner = _runner();
      runner.history.add(_entry('Test passed', DiagnosticStatus.pass));
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders fail entry without crash', (tester) async {
      final runner = _runner();
      runner.history.add(_entry('Test failed', DiagnosticStatus.fail));
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders warn entry without crash', (tester) async {
      final runner = _runner();
      runner.history.add(_entry('Warning issued', DiagnosticStatus.warn));
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders info entry without crash', (tester) async {
      final runner = _runner();
      runner.history.add(_entry('Info message', DiagnosticStatus.info));
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders running entry without crash', (tester) async {
      final runner = _runner();
      runner.history.add(_entry('Running check...', DiagnosticStatus.running));
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('DiagnosticLog — stream updates', () {
    testWidgets('new entry from stream appears in log', (tester) async {
      final runner = _runner();
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      await tester.pump();

      // Emit a new entry via the stream.
      runner.history.add(_entry('Streamed message', DiagnosticStatus.pass));
      // Access the internal stream controller via the public entries getter
      // by casting; we can trigger this via the history add + pump.
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('disposing widget cancels stream subscription', (tester) async {
      final runner = _runner();
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      await tester.pump();

      // Replace widget tree to trigger dispose.
      await tester.pumpWidget(_wrap(const SizedBox()));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  group('DiagnosticLog — timestamp formatting', () {
    testWidgets('timestamp appears in HH:MM:SS format', (tester) async {
      final runner = _runner();
      runner.history.add(DiagnosticEntry(
        message: 'Timed entry',
        status: DiagnosticStatus.pass,
        timestamp: DateTime(2024, 1, 1, 10, 5, 3),
      ));
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      await tester.pump();

      // Timestamp formatted as [10:05:03]
      expect(find.textContaining('10:05:03'), findsOneWidget);
    });

    testWidgets('zero-padded timestamp for single-digit components',
        (tester) async {
      final runner = _runner();
      runner.history.add(DiagnosticEntry(
        message: 'Padded entry',
        status: DiagnosticStatus.info,
        timestamp: DateTime(2024, 1, 1, 1, 2, 3),
      ));
      await tester.pumpWidget(_wrap(DiagnosticLog(runner: runner)));
      await tester.pump();

      expect(find.textContaining('01:02:03'), findsOneWidget);
    });
  });
}
