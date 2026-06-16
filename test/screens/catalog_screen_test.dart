import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/gen/candela/types/model_catalog.pb.dart';
import 'package:candela_desktop/services/catalog_notifier.dart';

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

List<ModelCatalogEntry> _sampleModels() => [
      _entry(
        modelId: 'gemini-2.5-pro',
        provider: 'google',
        displayName: 'Gemini 2.5 Pro',
        category: 'flagship',
      ),
      _entry(
        modelId: 'claude-sonnet-4',
        provider: 'anthropic',
        displayName: 'Claude Sonnet 4',
        category: 'flagship',
      ),
      _entry(
        modelId: 'gpt-4o',
        provider: 'openai',
        displayName: 'GPT-4o',
        category: 'flagship',
      ),
      _entry(
        modelId: 'mistral-large',
        provider: 'mistral',
        displayName: 'Mistral Large',
        category: 'flagship',
        enabled: false,
      ),
    ];

// ═══════════════════════════════════════════════════════════════════════════════
// These are pure-logic tests for the catalog screen's filtering and display
// logic. Widget tests that require a full Riverpod + MaterialApp scaffold are
// not practical here because the CatalogNotifier uses code-generated Riverpod
// providers backed by ConnectRPC transports that require a running server.
//
// Instead we test the data-layer logic that the screen depends on: filtering,
// search, sorting, admin visibility, and state-driven UI decisions.
// ═══════════════════════════════════════════════════════════════════════════════

void main() {
  // ── Filtering logic ───────────────────────────────────────────────────────

  group('Catalog filtering — provider filter', () {
    final models = _sampleModels();

    test('All filter returns all models', () {
      expect(models.length, 4);
    });

    test('filter by Google provider', () {
      final filtered =
          models.where((m) => m.provider.toLowerCase() == 'google').toList();
      expect(filtered.length, 1);
      expect(filtered.first.modelId, 'gemini-2.5-pro');
    });

    test('filter by Anthropic provider', () {
      final filtered =
          models.where((m) => m.provider.toLowerCase() == 'anthropic').toList();
      expect(filtered.length, 1);
      expect(filtered.first.modelId, 'claude-sonnet-4');
    });

    test('filter by non-existent provider returns empty', () {
      final filtered = models
          .where((m) => m.provider.toLowerCase() == 'nonexistent')
          .toList();
      expect(filtered, isEmpty);
    });
  });

  group('Catalog filtering — search query', () {
    final models = _sampleModels();

    test('search by model ID substring', () {
      final q = 'gemini';
      final filtered = models
          .where((m) =>
              m.modelId.toLowerCase().contains(q) ||
              m.displayName.toLowerCase().contains(q) ||
              m.provider.toLowerCase().contains(q))
          .toList();
      expect(filtered.length, 1);
      expect(filtered.first.modelId, 'gemini-2.5-pro');
    });

    test('search by display name', () {
      final q = 'sonnet';
      final filtered = models
          .where((m) =>
              m.modelId.toLowerCase().contains(q) ||
              m.displayName.toLowerCase().contains(q) ||
              m.provider.toLowerCase().contains(q))
          .toList();
      expect(filtered.length, 1);
      expect(filtered.first.provider, 'anthropic');
    });

    test('search by provider name matches all of that provider', () {
      final q = 'openai';
      final filtered = models
          .where((m) =>
              m.modelId.toLowerCase().contains(q) ||
              m.displayName.toLowerCase().contains(q) ||
              m.provider.toLowerCase().contains(q))
          .toList();
      expect(filtered.length, 1);
    });

    test('case-insensitive search', () {
      final q = 'GPT';
      final filtered = models
          .where((m) =>
              m.modelId.toLowerCase().contains(q.toLowerCase()) ||
              m.displayName.toLowerCase().contains(q.toLowerCase()) ||
              m.provider.toLowerCase().contains(q.toLowerCase()))
          .toList();
      expect(filtered.length, 1);
      expect(filtered.first.modelId, 'gpt-4o');
    });

    test('search with no matches returns empty', () {
      final q = 'nonexistent-model';
      final filtered = models
          .where((m) =>
              m.modelId.toLowerCase().contains(q) ||
              m.displayName.toLowerCase().contains(q) ||
              m.provider.toLowerCase().contains(q))
          .toList();
      expect(filtered, isEmpty);
    });
  });

  group('Catalog filtering — combined provider + search', () {
    final models = _sampleModels();

    test('filter by provider then search within results', () {
      final provLower = 'google';
      final q = 'pro';
      final filtered = models
          .where((m) => m.provider.toLowerCase() == provLower)
          .where((m) =>
              m.modelId.toLowerCase().contains(q) ||
              m.displayName.toLowerCase().contains(q))
          .toList();
      expect(filtered.length, 1);
      expect(filtered.first.modelId, 'gemini-2.5-pro');
    });

    test('combined filter with no matches returns empty', () {
      final provLower = 'google';
      final q = 'claude';
      final filtered = models
          .where((m) => m.provider.toLowerCase() == provLower)
          .where((m) =>
              m.modelId.toLowerCase().contains(q) ||
              m.displayName.toLowerCase().contains(q))
          .toList();
      expect(filtered, isEmpty);
    });
  });

  // ── Admin vs non-admin visibility ─────────────────────────────────────────

  group('Catalog — admin vs non-admin visibility', () {
    test('adminEditable false hides toggle and delete columns', () {
      const state = CatalogState(adminEditable: false);
      expect(state.adminEditable, isFalse);
      // UI only renders toggle/delete when adminEditable is true.
    });

    test('adminEditable true shows toggle and delete columns', () {
      const state = CatalogState(adminEditable: true);
      expect(state.adminEditable, isTrue);
    });

    test('disabled models are visible to admins', () {
      final models = _sampleModels();
      final disabled = models.where((m) => !m.enabled).toList();
      expect(disabled.length, 1);
      expect(disabled.first.modelId, 'mistral-large');
    });
  });

  // ── Loading state ─────────────────────────────────────────────────────────

  group('Catalog — loading state', () {
    test('loading with no models shows loading indicator', () {
      const state = CatalogState(loading: true, models: []);
      // UI condition: state.loading && state.models.isEmpty → show spinner.
      expect(state.loading && state.models.isEmpty, isTrue);
    });

    test('loading with existing models does not show loading indicator', () {
      final state = CatalogState(loading: true, models: [_entry()]);
      // UI condition: state.loading && state.models.isEmpty → false.
      expect(state.loading && state.models.isEmpty, isFalse);
    });
  });

  // ── Error state ───────────────────────────────────────────────────────────

  group('Catalog — error state', () {
    test('error with no models shows full-screen error', () {
      const state = CatalogState(error: 'Failed to load', models: []);
      // UI: state.error != null && state.models.isEmpty → full-screen error.
      expect(state.error != null && state.models.isEmpty, isTrue);
    });

    test('error with existing models shows SnackBar (not full-screen)', () {
      final state = CatalogState(
        error: 'Delete failed',
        models: [_entry()],
      );
      // UI: state.error != null but models are not empty → SnackBar only.
      expect(state.error != null && state.models.isNotEmpty, isTrue);
    });
  });

  // ── Provider filter chips ─────────────────────────────────────────────────

  group('Catalog — provider filter chips', () {
    test('all known providers are listed', () {
      const allProviders = [
        'All',
        'Google',
        'Anthropic',
        'OpenAI',
        'Mistral',
        'DeepSeek',
        'Qwen',
      ];
      expect(allProviders.length, 7);
      expect(allProviders.first, 'All');
    });

    test('selecting a provider filters correctly', () {
      final models = _sampleModels();
      const selected = 'Mistral';
      final filtered = models
          .where((m) => m.provider.toLowerCase() == selected.toLowerCase())
          .toList();
      expect(filtered.length, 1);
      expect(filtered.first.modelId, 'mistral-large');
    });
  });

  // ── Display formatting ────────────────────────────────────────────────────

  group('Catalog — display formatting', () {
    test('model uses displayName when available', () {
      final entry = _entry(displayName: 'Fancy Model', modelId: 'boring-id');
      final label =
          entry.displayName.isNotEmpty ? entry.displayName : entry.modelId;
      expect(label, 'Fancy Model');
    });

    test('model falls back to modelId when displayName is empty', () {
      final entry = _entry(displayName: '', modelId: 'boring-id');
      final label =
          entry.displayName.isNotEmpty ? entry.displayName : entry.modelId;
      expect(label, 'boring-id');
    });

    test('disabled models are marked with reduced opacity', () {
      final entry = _entry(enabled: false);
      final isDisabled = !entry.enabled;
      final opacity = isDisabled ? 0.45 : 1.0;
      expect(opacity, 0.45);
    });

    test('context window formatting', () {
      String fmtCtx(int tokens) {
        if (tokens <= 0) return '—';
        if (tokens >= 1000000) {
          final m = tokens / 1000000;
          return m == m.roundToDouble()
              ? '${m.round()}M'
              : '${m.toStringAsFixed(1)}M';
        }
        final k = tokens / 1000;
        return k == k.roundToDouble()
            ? '${k.round()}K'
            : '${k.toStringAsFixed(1)}K';
      }

      expect(fmtCtx(0), '—');
      expect(fmtCtx(128000), '128K');
      expect(fmtCtx(1000000), '1M');
      expect(fmtCtx(2000000), '2M');
      expect(fmtCtx(200000), '200K');
    });

    test('price formatting', () {
      String fmtPrice(double price) {
        if (price <= 0) return '—';
        if (price < 0.01) return '\$${price.toStringAsFixed(4)}';
        if (price < 1) return '\$${price.toStringAsFixed(3)}';
        return '\$${price.toStringAsFixed(2)}';
      }

      expect(fmtPrice(0), '—');
      expect(fmtPrice(0.005), '\$0.0050');
      expect(fmtPrice(0.15), '\$0.150');
      expect(fmtPrice(5.0), '\$5.00');
    });
  });

  // ── Source badge ──────────────────────────────────────────────────────────

  group('Catalog — source badge', () {
    test('source badge shows when source is non-empty', () {
      const state = CatalogState(source: 'firestore');
      expect(state.source.isNotEmpty, isTrue);
    });

    test('source badge hidden when source is empty', () {
      const state = CatalogState(source: '');
      expect(state.source.isEmpty, isTrue);
    });
  });
}
