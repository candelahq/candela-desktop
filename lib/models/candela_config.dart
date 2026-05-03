/// Parsed representation of ~/.candela.yaml.
class CandelaConfig {
  final String path;
  final DateTime? lastModified;
  final String? remote;
  final String? audience;
  final int port;
  final int lmStudioPort;
  final List<ProviderConfig> providers;
  final VertexAIConfig? vertexAI;
  final CandelaMode mode;
  final List<ConfigIssue> issues;

  const CandelaConfig({
    required this.path,
    this.lastModified,
    this.remote,
    this.audience,
    this.port = 8181,
    this.lmStudioPort = 1234,
    this.providers = const [],
    this.vertexAI,
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

  const VertexAIConfig({this.project, this.region});

  String get effectiveRegion => region ?? 'us-central1';
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
