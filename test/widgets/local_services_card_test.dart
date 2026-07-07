import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';
import 'package:candela_desktop/widgets/local_services_card.dart';
import 'package:candela_desktop/theme/candela_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ManagedProcess _makeProcess({
  String name = 'proxy',
  String displayName = 'Candela Proxy',
  String icon = '🕯️',
  ProcessState state = ProcessState.stopped,
  String? errorMessage,
  String? port,
}) {
  return ManagedProcess(
    name: name,
    displayName: displayName,
    icon: icon,
    state: state,
    port: port,
    errorMessage: errorMessage,
  );
}

/// Creates a test Notifier that immediately emits the given processes.
/// Uses overrideWith so .notifier access works in the widget.
Widget _wrap(List<ManagedProcess> processes) => ProviderScope(
      overrides: [
        processManagerProvider.overrideWith(() {
          return _TestProcessManagerNotifier(processes);
        }),
      ],
      child: MaterialApp(
        theme: CandelaTheme.dark,
        home: const Scaffold(
            body: SingleChildScrollView(child: LocalServicesCard())),
      ),
    );

/// A test-only notifier that seeds itself with the given processes.
class _TestProcessManagerNotifier extends ProcessManagerNotifier {
  final List<ManagedProcess> _initialProcesses;

  _TestProcessManagerNotifier(this._initialProcesses);

  @override
  ProcessManagerState build() {
    return ProcessManagerState(processes: _initialProcesses);
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('LocalServicesCard', () {
    testWidgets('returns SizedBox.shrink when no processes', (tester) async {
      await tester.pumpWidget(_wrap([]));
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text('Local Services'), findsNothing);
    });

    testWidgets('renders Local Services header', (tester) async {
      await tester.pumpWidget(_wrap([_makeProcess()]));
      expect(find.text('Local Services'), findsOneWidget);
    });

    testWidgets('shows process row with displayName and icon', (tester) async {
      await tester.pumpWidget(_wrap([
        _makeProcess(displayName: 'Ollama', icon: '🦙'),
      ]));
      expect(find.text('Ollama'), findsOneWidget);
      expect(find.text('🦙'), findsOneWidget);
    });

    testWidgets('shows RUNNING badge (green) when running', (tester) async {
      await tester.pumpWidget(_wrap([
        _makeProcess(state: ProcessState.running),
      ]));
      expect(find.text('RUNNING'), findsOneWidget);
    });

    testWidgets('shows STOPPED badge when stopped', (tester) async {
      await tester.pumpWidget(_wrap([
        _makeProcess(state: ProcessState.stopped),
      ]));
      expect(find.text('STOPPED'), findsOneWidget);
    });

    testWidgets('shows ERROR badge and error message when errored',
        (tester) async {
      await tester.pumpWidget(_wrap([
        _makeProcess(
          state: ProcessState.error,
          errorMessage: 'Health check failed',
        ),
      ]));
      expect(find.text('ERROR'), findsOneWidget);
      expect(find.text('Health check failed'), findsOneWidget);
    });

    testWidgets(
        'shows MISSING badge and "Not installed" message when notInstalled',
        (tester) async {
      await tester.pumpWidget(_wrap([
        _makeProcess(state: ProcessState.notInstalled),
      ]));
      expect(find.text('MISSING'), findsOneWidget);
      expect(find.text('Not installed or not found in PATH'), findsOneWidget);
    });

    testWidgets('shows play button when stopped', (tester) async {
      await tester.pumpWidget(_wrap([
        _makeProcess(state: ProcessState.stopped),
      ]));
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('shows stop and restart buttons when running', (tester) async {
      await tester.pumpWidget(_wrap([
        _makeProcess(state: ProcessState.running),
      ]));
      expect(find.byIcon(Icons.stop), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('hides play button when notInstalled', (tester) async {
      await tester.pumpWidget(_wrap([
        _makeProcess(state: ProcessState.notInstalled),
      ]));
      expect(find.byIcon(Icons.play_arrow), findsNothing);
    });
  });
}
