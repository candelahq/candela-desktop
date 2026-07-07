/// Status of a single LLM provider's connectivity.
class ProviderStatus {
  final String name;
  final String displayName;
  final ProviderState state;
  final String? statusMessage;
  final String? identity;
  final String? project;
  final String? region;
  final List<String> models;

  /// Original model IDs before name cleanup — used for proxy verification.
  final List<String> rawModels;
  final Duration? latency;
  final String? fixCommand;
  final String? fixUrl;
  final String? errorDetail;
  final String? icon;
  final int? port;

  const ProviderStatus({
    required this.name,
    required this.displayName,
    required this.state,
    this.statusMessage,
    this.identity,
    this.project,
    this.region,
    this.models = const [],
    this.rawModels = const [],
    this.latency,
    this.fixCommand,
    this.fixUrl,
    this.errorDetail,
    this.icon,
    this.port,
  });

  bool get isHealthy => state == ProviderState.connected;
}

enum ProviderState {
  loading,
  connected,
  error,
  warning,
  notConfigured,
  notInstalled,
}
