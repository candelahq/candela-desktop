import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';
import 'package:candela_desktop/widgets/process_logs_dialog.dart';
import 'package:candela_desktop/theme/candela_theme.dart';

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
  return ManagedProcess(
    name: name,
    displayName: displayName,
    icon: icon,
    state: state,
    recentLogs: logs,
  );
}

Widget _wrapDialog(List<ManagedProcess> processes,
        {String processName = 'proxy'}) =>
    ProviderScope(
      overrides: [
        processManagerProvider
            .overrideWithValue(ProcessManagerState(processes: processes)),
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
      await tester.pumpWidget(_wrapDialog([], processName: 'nonexistent'));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.text('Process no longer exists.'), findsOneWidget);
    });

    testWidgets('shows "No logs available yet." when logs are empty',
        (tester) async {
      await tester.pumpWidget(_wrapDialog([_makeProcess(logs: [])]));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.text('No logs available yet.'), findsOneWidget);
    });

    testWidgets('shows process displayName in title', (tester) async {
      await tester.pumpWidget(_wrapDialog([
        _makeProcess(displayName: 'Candela Proxy', icon: '🕯️'),
      ]));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.textContaining('Candela Proxy'), findsOneWidget);
      expect(find.textContaining('Logs'), findsOneWidget);
    });

    testWidgets('renders log text in dark terminal area', (tester) async {
      await tester.pumpWidget(_wrapDialog([
        _makeProcess(logs: ['Line 1 from stdout', 'Line 2 from stderr']),
      ]));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.textContaining('Line 1 from stdout'), findsOneWidget);
      expect(find.textContaining('Line 2 from stderr'), findsOneWidget);
    });

    testWidgets('copy button exists', (tester) async {
      await tester.pumpWidget(_wrapDialog([
        _makeProcess(logs: ['hello'])
      ]));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets('close button dismisses dialog', (tester) async {
      await tester.pumpWidget(_wrapDialog([
        _makeProcess(logs: ['hello'])
      ]));
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
