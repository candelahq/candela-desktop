/// Parsed representation of ~/.config/candela/config.yaml.
class CandelaConfig {
  final String path;
  final DateTime? lastModified;
  final int configVersion;
  final String? remote;
  final String? audience;
  final int port;
  final int lmStudioPort;
  final List<ProviderConfig> providers;
  final VertexAIConfig? vertexAI;
  final PricingConfig? pricing;
  final OptimizationConfig? optimizations;
  final CandelaMode mode;
  final List<ConfigIssue> issues;

  const CandelaConfig({
    required this.path,
    this.lastModified,
    this.configVersion = 0,
    this.remote,
    this.audience,
    this.port = 8181,
    this.lmStudioPort = 1234,
    this.providers = const [],
    this.vertexAI,
    this.pricing,
    this.optimizations,
    this.mode = CandelaMode.solo,
    this.issues = const [],
  });

  bool get hasErrors => issues.any((i) => i.severity == IssueSeverity.error);
  bool get hasWarnings =>
      issues.any((i) => i.severity == IssueSeverity.warning);
}

enum CandelaMode { solo, soloCloud, team }

class ProviderConfig {
  final String name;
  final List<String> models;

  const ProviderConfig({required this.name, this.models = const []});
}

class VertexAIConfig {
  final String? project;
  final String? region;
  final bool promptCaching;

  const VertexAIConfig({this.project, this.region, this.promptCaching = false});

  String get effectiveRegion => region ?? 'us-central1';
}

/// Per-model pricing overrides for accurate cost tracking.
class PricingConfig {
  final List<ModelPricing> models;

  const PricingConfig({this.models = const []});
}

/// Token and latency optimizations configuration.
class OptimizationConfig {
  final bool semanticCache;
  final bool contextCompression;

  const OptimizationConfig({
    this.semanticCache = false,
    this.contextCompression = false,
  });
}

/// Custom rate for a single model, overriding built-in defaults.
class ModelPricing {
  final String provider;
  final String model;
  final double inputPerMillion;
  final double outputPerMillion;

  const ModelPricing({
    required this.provider,
    required this.model,
    required this.inputPerMillion,
    required this.outputPerMillion,
  });
}

enum IssueSeverity { error, warning, info }

class ConfigIssue {
  final IssueSeverity severity;
  final String message;
  final String? field;

  const ConfigIssue({
    required this.severity,
    required this.message,
    this.field,
  });
}
