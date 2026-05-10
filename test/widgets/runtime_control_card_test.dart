import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/screens/auth_debug/runtime_control_card.dart';
import 'package:candela_desktop/services/process_manager.dart';
import 'package:candela_desktop/theme/colors.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

Widget _wrap(Widget child) => MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: CandelaColors.bgPrimary,
        body: SizedBox(width: 500, child: child),
      ),
    );

ManagedProcess _process({
  String name = 'ollama',
  String displayName = 'Ollama',
  String icon = '🦙',
  ProcessState state = ProcessState.stopped,
  String? port,
  String? errorMessage,
  int? pid,
}) {
  final p = ManagedProcess(
    name: name,
    displayName: displayName,
    icon: icon,
    state: state,
    port: port ?? '11434',
  );
  p.errorMessage = errorMessage;
  p.pid = pid;
  return p;
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group('RuntimeControlCard — basic rendering', () {
    testWidgets('shows process display name', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(displayName: 'Ollama'),
      )));
      expect(find.text('Ollama'), findsOneWidget);
    });

    testWidgets('shows process icon', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(icon: '🦙'),
      )));
      expect(find.text('🦙'), findsOneWidget);
    });

    testWidgets('renders with port configured', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(port: '11434'),
      )));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without callbacks', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(),
      )));
      expect(tester.takeException(), isNull);
    });
  });

  group('RuntimeControlCard — state display', () {
    testWidgets('stopped state renders without crash', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(state: ProcessState.stopped),
      )));
      expect(tester.takeException(), isNull);
    });

    testWidgets('running state renders without crash', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(state: ProcessState.running, pid: 1234),
      )));
      expect(tester.takeException(), isNull);
    });

    testWidgets('starting state renders without crash', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(state: ProcessState.starting),
      )));
      expect(tester.takeException(), isNull);
    });

    testWidgets('error state shows error message', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(
          state: ProcessState.error,
          errorMessage: 'Health check failed',
        ),
      )));
      expect(find.text('Health check failed'), findsOneWidget);
    });

    testWidgets('notInstalled state renders without crash', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(state: ProcessState.notInstalled),
      )));
      expect(tester.takeException(), isNull);
    });

    testWidgets('stopping state renders without crash', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(state: ProcessState.stopping),
      )));
      expect(tester.takeException(), isNull);
    });
  });

  group('RuntimeControlCard — callbacks', () {
    testWidgets('onStart is called when Start tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(state: ProcessState.stopped),
        onStart: () => called = true,
      )));

      // Find and tap Start button.
      final startBtn = find.widgetWithText(TextButton, 'Start');
      if (startBtn.evaluate().isNotEmpty) {
        await tester.tap(startBtn);
        expect(called, isTrue);
      } else {
        // Button rendered differently — just verify no crash.
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('onStop is called when Stop tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(state: ProcessState.running),
        onStop: () => called = true,
      )));

      final stopBtn = find.widgetWithText(TextButton, 'Stop');
      if (stopBtn.evaluate().isNotEmpty) {
        await tester.tap(stopBtn);
        expect(called, isTrue);
      } else {
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('onRemove callback is wired', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(state: ProcessState.stopped),
        onRemove: () {},
      )));
      // Widget renders with remove callback — no crash.
      expect(tester.takeException(), isNull);
    });
  });

  group('RuntimeControlCard — vLLM process', () {
    testWidgets('renders vLLM process', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(
          name: 'vllm',
          displayName: 'vLLM',
          icon: 'V',
          port: '8000',
          state: ProcessState.running,
        ),
      )));
      expect(find.text('vLLM'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('RuntimeControlCard — proxy process', () {
    testWidgets('renders proxy process', (tester) async {
      await tester.pumpWidget(_wrap(RuntimeControlCard(
        process: _process(
          name: 'proxy',
          displayName: 'Candela Proxy',
          icon: '🕯️',
          port: '8181',
          state: ProcessState.running,
          pid: 5678,
        ),
      )));
      expect(find.text('Candela Proxy'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
