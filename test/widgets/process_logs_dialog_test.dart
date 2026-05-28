import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';
import 'package:candela_desktop/providers.dart';
import 'package:candela_desktop/widgets/process_logs_dialog.dart';
import 'package:candela_desktop/theme/candela_theme.dart';

// ---------------------------------------------------------------------------
// Hand-rolled fake — no mockito/mocktail.
// ---------------------------------------------------------------------------

class FakeProcessManager extends ProcessManager {
  final List<ManagedProcess> _fakeProcesses;

  FakeProcessManager([List<ManagedProcess>? processes])
      : _fakeProcesses = processes ?? [];

  @override
  List<ManagedProcess> get all => _fakeProcesses;

  @override
  ManagedProcess? get(String name) =>
      _fakeProcesses.where((p) => p.name == name).firstOrNull;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ManagedProcess _makeProcess({
  String name = 'proxy',
  String displayName = 'Candela Proxy',
  String icon = '🕯️',
  ProcessState state = ProcessState.running,
  List<String> logs = const [],
}) {
  final p = ManagedProcess(
    name: name,
    displayName: displayName,
    icon: icon,
    state: state,
  );
  for (final line in logs) {
    p.recentLogs.addLast(line);
  }
  return p;
}

Widget _wrapDialog(FakeProcessManager pm, {String processName = 'proxy'}) =>
    ProviderScope(
      overrides: [
        processManagerProvider.overrideWithValue(pm),
      ],
      child: MaterialApp(
        theme: CandelaTheme.dark,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => ProcessLogsDialog(processName: processName),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('ProcessLogsDialog', () {
    testWidgets('shows "Process no longer exists." when process is null',
        (tester) async {
      final pm = FakeProcessManager(); // no processes at all
      await tester.pumpWidget(_wrapDialog(pm, processName: 'nonexistent'));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.text('Process no longer exists.'), findsOneWidget);
    });

    testWidgets('shows "No logs available yet." when logs are empty',
        (tester) async {
      final pm = FakeProcessManager([_makeProcess(logs: [])]);
      await tester.pumpWidget(_wrapDialog(pm));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.text('No logs available yet.'), findsOneWidget);
    });

    testWidgets('shows process displayName in title', (tester) async {
      final pm = FakeProcessManager([
        _makeProcess(displayName: 'Candela Proxy', icon: '🕯️'),
      ]);
      await tester.pumpWidget(_wrapDialog(pm));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.textContaining('Candela Proxy'), findsOneWidget);
      expect(find.textContaining('Logs'), findsOneWidget);
    });

    testWidgets('renders log text in dark terminal area', (tester) async {
      final pm = FakeProcessManager([
        _makeProcess(logs: ['Line 1 from stdout', 'Line 2 from stderr']),
      ]);
      await tester.pumpWidget(_wrapDialog(pm));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.textContaining('Line 1 from stdout'), findsOneWidget);
      expect(find.textContaining('Line 2 from stderr'), findsOneWidget);
    });

    testWidgets('copy button exists', (tester) async {
      final pm = FakeProcessManager([
        _makeProcess(logs: ['hello'])
      ]);
      await tester.pumpWidget(_wrapDialog(pm));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets('close button dismisses dialog', (tester) async {
      final pm = FakeProcessManager([
        _makeProcess(logs: ['hello'])
      ]);
      await tester.pumpWidget(_wrapDialog(pm));
      await tester.tap(find.text('Open'));
      await tester.pump();

      // Dialog is visible
      expect(find.byType(AlertDialog), findsOneWidget);

      // Tap close icon
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Dialog is dismissed
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
