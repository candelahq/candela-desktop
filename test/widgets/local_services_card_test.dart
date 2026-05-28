import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';
import 'package:candela_desktop/providers.dart';
import 'package:candela_desktop/widgets/local_services_card.dart';
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
  ProcessState state = ProcessState.stopped,
  String? errorMessage,
  String? port,
}) {
  final p = ManagedProcess(
    name: name,
    displayName: displayName,
    icon: icon,
    state: state,
    port: port,
  );
  p.errorMessage = errorMessage;
  return p;
}

Widget _wrap(FakeProcessManager pm) => ProviderScope(
      overrides: [
        processManagerProvider.overrideWithValue(pm),
      ],
      child: MaterialApp(
        theme: CandelaTheme.dark,
        home: const Scaffold(
            body: SingleChildScrollView(child: LocalServicesCard())),
      ),
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('LocalServicesCard', () {
    testWidgets('returns SizedBox.shrink when no processes', (tester) async {
      await tester.pumpWidget(_wrap(FakeProcessManager()));
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text('Local Services'), findsNothing);
    });

    testWidgets('renders Local Services header', (tester) async {
      final pm = FakeProcessManager([_makeProcess()]);
      await tester.pumpWidget(_wrap(pm));
      expect(find.text('Local Services'), findsOneWidget);
    });

    testWidgets('shows process row with displayName and icon', (tester) async {
      final pm = FakeProcessManager([
        _makeProcess(displayName: 'Ollama', icon: '🦙'),
      ]);
      await tester.pumpWidget(_wrap(pm));
      expect(find.text('Ollama'), findsOneWidget);
      expect(find.text('🦙'), findsOneWidget);
    });

    testWidgets('shows RUNNING badge (green) when running', (tester) async {
      final pm = FakeProcessManager([
        _makeProcess(state: ProcessState.running),
      ]);
      await tester.pumpWidget(_wrap(pm));
      expect(find.text('RUNNING'), findsOneWidget);
    });

    testWidgets('shows STOPPED badge when stopped', (tester) async {
      final pm = FakeProcessManager([
        _makeProcess(state: ProcessState.stopped),
      ]);
      await tester.pumpWidget(_wrap(pm));
      expect(find.text('STOPPED'), findsOneWidget);
    });

    testWidgets('shows ERROR badge and error message when errored',
        (tester) async {
      final pm = FakeProcessManager([
        _makeProcess(
          state: ProcessState.error,
          errorMessage: 'Health check failed',
        ),
      ]);
      await tester.pumpWidget(_wrap(pm));
      expect(find.text('ERROR'), findsOneWidget);
      expect(find.text('Health check failed'), findsOneWidget);
    });

    testWidgets(
        'shows MISSING badge and "Not installed" message when notInstalled',
        (tester) async {
      final pm = FakeProcessManager([
        _makeProcess(state: ProcessState.notInstalled),
      ]);
      await tester.pumpWidget(_wrap(pm));
      expect(find.text('MISSING'), findsOneWidget);
      expect(find.text('Not installed or not found in PATH'), findsOneWidget);
    });

    testWidgets('shows play button when stopped', (tester) async {
      final pm = FakeProcessManager([
        _makeProcess(state: ProcessState.stopped),
      ]);
      await tester.pumpWidget(_wrap(pm));
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('shows stop and restart buttons when running', (tester) async {
      final pm = FakeProcessManager([
        _makeProcess(state: ProcessState.running),
      ]);
      await tester.pumpWidget(_wrap(pm));
      expect(find.byIcon(Icons.stop), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('hides play button when notInstalled', (tester) async {
      final pm = FakeProcessManager([
        _makeProcess(state: ProcessState.notInstalled),
      ]);
      await tester.pumpWidget(_wrap(pm));
      expect(find.byIcon(Icons.play_arrow), findsNothing);
    });
  });
}
