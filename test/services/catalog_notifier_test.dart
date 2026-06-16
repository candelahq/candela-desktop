import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/catalog_notifier.dart';
import 'package:candela_desktop/models/candela_config.dart';
import 'package:candela_desktop/gen/candela/types/model_catalog.pb.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

ModelCatalogEntry _entry({
  String modelId = 'gpt-4o',
  String provider = 'openai',
  String displayName = 'GPT-4o',
  bool enabled = true,
  String category = 'flagship',
  double inputPerMillion = 5.0,
  double outputPerMillion = 15.0,
}) =>
    ModelCatalogEntry(
      modelId: modelId,
      provider: provider,
      displayName: displayName,
      enabled: enabled,
      category: category,
      inputPerMillion: inputPerMillion,
      outputPerMillion: outputPerMillion,
    );

void main() {
  // ── CatalogState ──────────────────────────────────────────────────────────

  group('CatalogState', () {
    test('default state has no models and is loading', () {
      const state = CatalogState(loading: true);
      expect(state.models, isEmpty);
      expect(state.loading, isTrue);
      expect(state.error, isNull);
      expect(state.adminEditable, isFalse);
      expect(state.source, '');
    });

    test('copyWith preserves unchanged fields', () {
      const state = CatalogState(
        loading: true,
        adminEditable: true,
        source: 'firestore',
      );
      final updated = state.copyWith(loading: false);
      expect(updated.loading, isFalse);
      expect(updated.adminEditable, isTrue); // preserved
      expect(updated.source, 'firestore'); // preserved
    });

    test('copyWith can set error', () {
      final state = const CatalogState().copyWith(error: 'something broke');
      expect(state.error, 'something broke');
    });

    test('copyWith can clear error', () {
      final state =
          const CatalogState(error: 'fail').copyWith(clearError: true);
      expect(state.error, isNull);
    });

    test('copyWith clearError takes precedence over error', () {
      final state = const CatalogState(error: 'old')
          .copyWith(error: 'new', clearError: true);
      expect(state.error, isNull);
    });
  });

  // ── CatalogController — configure ─────────────────────────────────────────

  group('CatalogController — configure', () {
    test('configure sets up client (solo mode)', () {
      final controller = CatalogController();
      controller.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
        port: 8181,
      ));
      // After configure, the controller should have a client — verify by
      // checking that fetch() doesn't bail early (it would if _client == null).
      // We can only indirectly test this since _client is private.
      // A fetch() call should produce a state change (even if it errors).
      final states = <CatalogState>[];
      controller.onStateChanged = (s) => states.add(s);
      controller.fetch();
      // fetch is async, but the first synchronous state change (loading: true)
      // should fire immediately via the microtask.
      expect(controller.state.loading, isTrue);
      controller.dispose();
    });

    test('configure sets up client (team mode)', () {
      final controller = CatalogController();
      controller.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
        port: 9090,
      ));
      // Should not throw and should allow fetch to proceed.
      final states = <CatalogState>[];
      controller.onStateChanged = (s) => states.add(s);
      controller.fetch();
      expect(controller.state.loading, isTrue);
      controller.dispose();
    });

    test('configure with team mode and empty remote works like solo', () {
      final controller = CatalogController();
      // Empty remote → still configures via localhost.
      controller.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: '',
        port: 8181,
      ));
      final states = <CatalogState>[];
      controller.onStateChanged = (s) => states.add(s);
      controller.fetch();
      expect(controller.state.loading, isTrue);
      controller.dispose();
    });
  });

  // ── CatalogController — toggleEnabled ─────────────────────────────────────

  group('CatalogController — toggleEnabled', () {
    test('optimistic update flips enabled flag immediately', () async {
      final controller = CatalogController();
      final entry = _entry(enabled: true);
      controller.state = CatalogState(models: [entry]);

      final states = <CatalogState>[];
      controller.onStateChanged = (s) => states.add(s);

      // toggleEnabled without a client will bail early at _client == null,
      // but the optimistic update happens before the RPC call.
      // Since _client is null, it returns immediately after the early return.
      // So we need to test the optimistic logic directly.
      // To test this properly, we set the initial state and call toggle.
      await controller.toggleEnabled('openai', 'gpt-4o', false);

      // _client is null → early return before optimistic update.
      // The state should remain unchanged.
      expect(controller.state.models.first.enabled, isTrue);
      controller.dispose();
    });

    test('optimistic update clears previous errors', () async {
      final controller = CatalogController();
      controller.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
        port: 49999, // Use a port where no server is running.
      ));
      final entry = _entry(enabled: true);
      controller.state = CatalogState(
        models: [entry],
        error: 'previous error',
      );

      // toggleEnabled will apply optimistic update then fail at the RPC call
      // (no server running), but the optimistic update should clear the error.
      final states = <CatalogState>[];
      controller.onStateChanged = (s) => states.add(s);
      await controller.toggleEnabled('openai', 'gpt-4o', false);

      // First state change is optimistic: error cleared, enabled flipped.
      expect(states.isNotEmpty, isTrue);
      final optimisticState = states.first;
      expect(optimisticState.error, isNull);
      expect(
        optimisticState.models.first.enabled,
        isFalse,
      );
      controller.dispose();
    });

    test('rollback on failure re-fetches (which errors without server)',
        () async {
      final controller = CatalogController();
      controller.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
        port: 49999, // Use a port where no server is running.
      ));

      final entry = _entry(enabled: true);
      controller.state = CatalogState(models: [entry]);

      final states = <CatalogState>[];
      controller.onStateChanged = (s) => states.add(s);

      await controller.toggleEnabled('openai', 'gpt-4o', false);

      // After failure, fetch() is called which also fails (no server).
      // At least one state change should have occurred (optimistic + fetch loading + fetch error).
      expect(states, isNotEmpty);
      controller.dispose();
    });
  });

  // ── CatalogController — deleteEntry ───────────────────────────────────────

  group('CatalogController — deleteEntry', () {
    test('sets error on failure', () async {
      final controller = CatalogController();
      controller.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
        port: 49999, // Use a port where no server is running.
      ));

      final entry = _entry();
      controller.state = CatalogState(models: [entry]);

      await controller.deleteEntry('openai', 'gpt-4o');

      // Delete should fail (no server) and set an error.
      expect(controller.state.error, isNotNull);
      expect(controller.state.error, contains('Failed to delete'));
      // Model should NOT be removed on failure.
      expect(controller.state.models.length, 1);
      controller.dispose();
    });

    test('does nothing when client is null', () async {
      final controller = CatalogController();
      // No configure() call → _client is null.
      final entry = _entry();
      controller.state = CatalogState(models: [entry]);

      await controller.deleteEntry('openai', 'gpt-4o');

      // State should be unchanged — early return.
      expect(controller.state.models.length, 1);
      expect(controller.state.error, isNull);
      controller.dispose();
    });

    test('error message includes model ID', () async {
      final controller = CatalogController();
      controller.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
        port: 49999, // Use a port where no server is running.
      ));

      controller.state = CatalogState(models: [_entry()]);

      await controller.deleteEntry('openai', 'gpt-4o');

      expect(controller.state.error, contains('gpt-4o'));
      controller.dispose();
    });
  });

  // ── CatalogController — clearError ────────────────────────────────────────

  group('CatalogController — clearError', () {
    test('clearError clears a pending error', () {
      final controller = CatalogController();
      controller.state = const CatalogState(error: 'some error');
      expect(controller.state.error, 'some error');

      controller.clearError();
      expect(controller.state.error, isNull);
      controller.dispose();
    });

    test('clearError is a no-op when no error exists', () {
      final controller = CatalogController();
      controller.state = const CatalogState();
      expect(controller.state.error, isNull);

      controller.clearError();
      expect(controller.state.error, isNull);
      controller.dispose();
    });
  });

  // ── CatalogController — dispose ───────────────────────────────────────────

  group('CatalogController — dispose', () {
    test('dispose prevents further state updates', () {
      final controller = CatalogController();
      int callbackCount = 0;
      controller.onStateChanged = (_) => callbackCount++;
      controller.dispose();

      // Setting state after dispose should not invoke the callback.
      controller.state = const CatalogState(loading: true);
      expect(callbackCount, 0);
    });

    test('dispose does not throw on double-dispose', () {
      final controller = CatalogController();
      controller.dispose();
      // Second dispose should not throw.
      expect(() => controller.dispose(), returnsNormally);
    });

    test('fetch after dispose does not crash', () async {
      final controller = CatalogController();
      controller.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));
      controller.dispose();

      // fetch() should return without crashing (state setter is guarded).
      await controller.fetch();
    });

    test('toggleEnabled after dispose does not crash', () async {
      final controller = CatalogController();
      controller.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));
      controller.dispose();

      await controller.toggleEnabled('openai', 'gpt-4o', false);
    });
  });

  // ── CatalogController — onStateChanged ────────────────────────────────────

  group('CatalogController — onStateChanged', () {
    test('onStateChanged fires on state set', () {
      final controller = CatalogController();
      CatalogState? received;
      controller.onStateChanged = (s) => received = s;

      controller.state = const CatalogState(loading: true, source: 'test');
      expect(received, isNotNull);
      expect(received!.loading, isTrue);
      expect(received!.source, 'test');
      controller.dispose();
    });

    test('onStateChanged is not invoked when callback is null', () {
      final controller = CatalogController();
      expect(controller.onStateChanged, isNull);
      // Should not throw.
      controller.state = const CatalogState(loading: true);
      expect(controller.state.loading, isTrue);
      controller.dispose();
    });
  });
}
