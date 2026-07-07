import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';
import 'package:candela_desktop/widgets/process_logs_dialog.dart';
import 'package:candela_desktop/theme/candela_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Build a test harness with a real [ProcessManagerNotifier] so that the
/// dialog can call `notifier.getLogs()` (logs are no longer stored in state).
Widget _buildHarness(ProviderContainer container,
    {String processName = 'proxy'}) {
  return UncontrolledProviderScope(
    container: container,
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
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('ProcessLogsDialog', () {
    testWidgets('shows "Process no longer exists." when process is null',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      // Don't configure — looking up 'nonexistent' returns null.

      await tester
          .pumpWidget(_buildHarness(container, processName: 'nonexistent'));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.text('Process no longer exists.'), findsOneWidget);
    });

    testWidgets('shows "No logs available yet." when logs are empty',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(processManagerProvider.notifier)
          .configure(providerNames: []);

      await tester.pumpWidget(_buildHarness(container));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.text('No logs available yet.'), findsOneWidget);
    });

    testWidgets('shows process displayName in title', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(processManagerProvider.notifier)
          .configure(providerNames: []);

      await tester.pumpWidget(_buildHarness(container));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.textContaining('Candela Proxy'), findsOneWidget);
      expect(find.textContaining('Logs'), findsOneWidget);
    });

    testWidgets('renders empty log state in terminal area', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(processManagerProvider.notifier)
          .configure(providerNames: []);

      await tester.pumpWidget(_buildHarness(container));
      await tester.tap(find.text('Open'));
      await tester.pump();

      // Logs are now in a private buffer — with no process output,
      // the dialog shows the empty-state message.
      expect(find.text('No logs available yet.'), findsOneWidget);
    });

    testWidgets('copy button exists', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(processManagerProvider.notifier)
          .configure(providerNames: []);

      await tester.pumpWidget(_buildHarness(container));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets('close button dismisses dialog', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(processManagerProvider.notifier)
          .configure(providerNames: []);

      await tester.pumpWidget(_buildHarness(container));
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
