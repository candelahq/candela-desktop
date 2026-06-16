import 'package:flutter/foundation.dart';

import '../gen/candela/types/model_catalog.pb.dart';
import '../gen/candela/v1/model_catalog_service.connect.client.dart';
import '../gen/candela/v1/model_catalog_service.pb.dart';
import '../gen/google/protobuf/field_mask.pb.dart';
import '../models/candela_config.dart';
import 'connect_api_service.dart';

// ── Immutable state snapshot ─────────────────────────────────────────────────

/// Immutable snapshot of the catalog state.
class CatalogState {
  final List<ModelCatalogEntry> models;
  final bool adminEditable;
  final String source;
  final bool loading;
  final String? error;

  const CatalogState({
    this.models = const [],
    this.adminEditable = false,
    this.source = '',
    this.loading = false,
    this.error,
  });

  CatalogState copyWith({
    List<ModelCatalogEntry>? models,
    bool? adminEditable,
    String? source,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return CatalogState(
      models: models ?? this.models,
      adminEditable: adminEditable ?? this.adminEditable,
      source: source ?? this.source,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// ── Controller ───────────────────────────────────────────────────────────────

/// Manages model catalog data via ConnectRPC [ModelCatalogServiceClient].
///
/// Follows the same architecture as [DashboardController]:
/// - Lazily configured with a [CandelaConfig] from the provider graph.
/// - Routes through the local proxy in team mode.
/// - Exposes an immutable [CatalogState] and bridges changes to Riverpod
///   via [onStateChanged].
class CatalogController {
  ModelCatalogServiceClient? _client;

  /// Callback invoked whenever [state] changes. Set by the provider to
  /// bridge state updates into the Riverpod graph.
  void Function(CatalogState)? onStateChanged;

  bool _disposed = false;

  CatalogState _state = const CatalogState(loading: true);
  CatalogState get state => _state;
  set state(CatalogState newState) {
    if (_disposed) return;
    _state = newState;
    onStateChanged?.call(newState);
  }

  CatalogController();

  // ── Configuration ─────────────────────────────────────────────────────────

  /// Initialize with a config-derived transport.
  ///
  /// In team mode the transport routes through the local proxy
  /// (`localhost:{port}`) which handles IAP auth automatically.
  void configure(CandelaConfig config) {
    // In both team and solo mode, requests route through the local proxy.
    // In team mode the proxy's catch-all forwards to the remote backend
    // with IAP + auth headers injected automatically.
    final baseUrl = 'http://localhost:${config.port}';

    _client = ModelCatalogServiceClient(
      createCandelaTransport(baseUrl: baseUrl),
    );
  }

  // ── Fetch ─────────────────────────────────────────────────────────────────

  /// Fetch the full model catalog. Always requests disabled entries so the
  /// admin toggle works; the server filters for non-admin callers.
  Future<void> fetch() async {
    if (_client == null) return;

    state = state.copyWith(loading: true, clearError: true);

    try {
      final resp = await _client!.listModelCatalog(
        ListModelCatalogRequest(includeDisabled: true),
      );
      state = state.copyWith(
        models: List<ModelCatalogEntry>.from(resp.models),
        adminEditable: resp.adminEditable,
        source: resp.source,
        loading: false,
        clearError: true,
      );
    } catch (e) {
      debugPrint('[CatalogController] fetch error: $e');
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  /// Toggle the `enabled` flag on a single catalog entry.
  ///
  /// Uses a field mask so only `enabled` is mutated server-side.
  Future<void> toggleEnabled(
      String provider, String modelId, bool enabled) async {
    if (_client == null) return;

    // Optimistic update.
    final updatedModels = state.models.map((m) {
      if (m.provider == provider && m.modelId == modelId) {
        // Clone and flip enabled.
        return ModelCatalogEntry(
          modelId: m.modelId,
          provider: m.provider,
          displayName: m.displayName,
          inputPerMillion: m.inputPerMillion,
          outputPerMillion: m.outputPerMillion,
          enabled: enabled,
          category: m.category,
          contextWindow: m.contextWindow,
          inputPerMillionHigh: m.inputPerMillionHigh,
          outputPerMillionHigh: m.outputPerMillionHigh,
          tierThresholdTokens: m.tierThresholdTokens,
          aliases: m.aliases,
          allowedTenants: m.allowedTenants,
          discountPercent: m.discountPercent,
        );
      }
      return m;
    }).toList();
    state = state.copyWith(models: updatedModels, clearError: true);

    try {
      await _client!.updateModelCatalogEntry(
        UpdateModelCatalogEntryRequest(
          entry: ModelCatalogEntry(
            provider: provider,
            modelId: modelId,
            enabled: enabled,
          ),
          updateMask: FieldMask(paths: ['enabled']),
        ),
      );
    } catch (e) {
      debugPrint('[CatalogController] toggleEnabled error: $e');
      // Revert optimistic update.
      await fetch();
    }
  }

  /// Hard-delete a catalog entry.
  Future<void> deleteEntry(String provider, String modelId) async {
    if (_client == null) return;

    try {
      await _client!.deleteModelCatalogEntry(
        DeleteModelCatalogEntryRequest(
          provider: provider,
          modelId: modelId,
        ),
      );
      // Remove from local state and clear any previous error.
      final updated = state.models
          .where((m) => !(m.provider == provider && m.modelId == modelId))
          .toList();
      state = state.copyWith(models: updated, clearError: true);
    } catch (e) {
      debugPrint('[CatalogController] deleteEntry error: $e');
      state = state.copyWith(error: 'Failed to delete $modelId: $e');
    }
  }

  /// Clear any pending error. Called by the UI after displaying the error.
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Release resources.
  void dispose() {
    _disposed = true;
  }
}
