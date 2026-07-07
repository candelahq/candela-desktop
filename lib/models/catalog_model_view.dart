/// Unified catalog model view — used by both team-mode and solo-mode UI.
///
/// Constructed from either [ModelCatalogEntry] (team, has pricing) or
/// [CatalogModel] (solo/local, no pricing).
library;

import 'package:fixnum/fixnum.dart';

import '../gen/candela/types/model_catalog.pb.dart';
import '../gen/candela/v1/runtime_service.pb.dart';

/// Identifies whether the catalog data came from the team backend
/// (ModelCatalogService) or the local runtime (RuntimeService.ListCatalog).
enum CatalogSource { team, local }

/// A single model in the unified catalog view.
class CatalogModelView {
  /// Canonical model identifier (e.g. "gemini-2.5-pro", "llama3.2:3b").
  final String modelId;

  /// Human-readable display name.
  final String displayName;

  /// Provider name (e.g. "google", "anthropic", "ollama").
  final String provider;

  /// Model category (e.g. "chat", "code", "embedding"). Team mode only.
  final String? category;

  /// Context window size in tokens. Team mode only.
  final int? contextWindow;

  /// Approximate download size for local models (e.g. "2.0 GB"). Solo only.
  final String? sizeHint;

  /// Short description. Solo mode only.
  final String? description;

  /// Whether this model is enabled in the team catalog.
  final bool enabled;

  /// Whether the user pinned this local model.
  final bool pinned;

  /// Input pricing in USD per 1M tokens. Null in solo mode.
  final double? inputPerMillion;

  /// Output pricing in USD per 1M tokens. Null in solo mode.
  final double? outputPerMillion;

  /// High-tier input pricing (team mode tiered pricing).
  final double? inputPerMillionHigh;

  /// High-tier output pricing (team mode tiered pricing).
  final double? outputPerMillionHigh;

  /// Discount percentage applied to this model.
  final double? discountPercent;

  const CatalogModelView({
    required this.modelId,
    required this.displayName,
    required this.provider,
    this.category,
    this.contextWindow,
    this.sizeHint,
    this.description,
    this.enabled = true,
    this.pinned = false,
    this.inputPerMillion,
    this.outputPerMillion,
    this.inputPerMillionHigh,
    this.outputPerMillionHigh,
    this.discountPercent,
  });

  /// Whether this model has pricing data (team mode).
  bool get hasPricing => inputPerMillion != null;

  /// Construct from a team-mode [ModelCatalogEntry].
  factory CatalogModelView.fromTeamEntry(ModelCatalogEntry e) {
    return CatalogModelView(
      modelId: e.modelId,
      displayName: e.displayName.isNotEmpty ? e.displayName : e.modelId,
      provider: e.provider,
      category: e.category.isNotEmpty ? e.category : null,
      contextWindow:
          e.contextWindow != Int64.ZERO ? e.contextWindow.toInt() : null,
      enabled: e.enabled,
      inputPerMillion: e.inputPerMillion,
      outputPerMillion: e.outputPerMillion,
      inputPerMillionHigh:
          e.inputPerMillionHigh > 0 ? e.inputPerMillionHigh : null,
      outputPerMillionHigh:
          e.outputPerMillionHigh > 0 ? e.outputPerMillionHigh : null,
      discountPercent: e.discountPercent > 0 ? e.discountPercent : null,
    );
  }

  /// Construct from a solo-mode local [CatalogModel].
  factory CatalogModelView.fromLocalModel(CatalogModel m) {
    return CatalogModelView(
      modelId: m.id,
      displayName: m.name.isNotEmpty ? m.name : m.id,
      provider: 'ollama',
      sizeHint: m.sizeHint.isNotEmpty ? m.sizeHint : null,
      description: m.description.isNotEmpty ? m.description : null,
      pinned: m.pinned,
    );
  }
}

/// Result of fetching the catalog, including mode context.
class CatalogResult {
  /// The catalog source (team or local).
  final CatalogSource source;

  /// The unified model list.
  final List<CatalogModelView> models;

  /// Whether the current user has admin edit rights (team mode only).
  final bool adminEditable;

  /// Error message, if any.
  final String? error;

  const CatalogResult({
    required this.source,
    this.models = const [],
    this.adminEditable = false,
    this.error,
  });

  /// Whether this is team-mode data (with pricing).
  bool get isTeamMode => source == CatalogSource.team;
}
