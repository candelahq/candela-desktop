import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/provider_status.dart';

/// Tests connectivity to each LLM provider.
class ProviderTestService {
  final http.Client _client;
  bool _disposed = false;
  static const _timeout = Duration(seconds: 10);

  ProviderTestService({http.Client? client})
      : _client = client ?? http.Client();

  // Pre-compiled regex patterns for sanitizeError.
  static final _bearerRe =
      RegExp(r'Bearer\s+[A-Za-z0-9\-._~+/]+=*', caseSensitive: false);
  static final _apiKeyRe = RegExp(
      r'(api[_-]?key|authorization)[":\s]+[A-Za-z0-9\-._~+/]{20,}',
      caseSensitive: false);

  // Pre-compiled regex patterns for _cleanModelName.
  static final _dateSuffixRe = RegExp(r'-\d{8}$');
  static final _versionSuffixRe = RegExp(r'-0{1,2}\d$');
  static final _latestSuffixRe = RegExp(r'@latest$');

  /// Redact Bearer tokens and other sensitive patterns from error strings.
  static String sanitizeError(String error) {
    // Redact Bearer tokens.
    error = error.replaceAll(_bearerRe, 'Bearer [REDACTED]');
    // Redact API keys in headers — use replaceAllMapped so the captured
    // header name ($1) is preserved while the value is redacted.
    error = error.replaceAllMapped(_apiKeyRe, (m) => '${m[1]}: [REDACTED]');
    return error;
  }

  Future<ProviderStatus> testGoogle(
      {String? project, String? accessToken}) async {
    if (project == null) {
      return const ProviderStatus(
          name: 'google',
          displayName: 'Google / Vertex AI',
          state: ProviderState.error,
          statusMessage: 'No GCP project configured',
          fixCommand: 'Set vertex_ai.project in ~/.candela.yaml',
          icon: 'G');
    }
    if (accessToken == null) {
      return ProviderStatus(
          name: 'google',
          displayName: 'Google / Vertex AI',
          state: ProviderState.error,
          statusMessage: 'No access token',
          fixCommand: 'gcloud auth application-default login',
          project: project,
          icon: 'G');
    }
    try {
      final sw = Stopwatch()..start();
      final resp = await _guardedGet(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      sw.stop();
      if (resp == null) return _disposedStatus('google', 'Google / Vertex AI');
      if (resp.statusCode == 200) {
        final body = json.decode(resp.body) as Map<String, dynamic>;
        final models = (body['models'] as List?)
                ?.map(
                    (m) => (m as Map)['name']?.toString().split('/').last ?? '')
                .where((n) => n.contains('gemini'))
                .take(5)
                .toList() ??
            [];
        return ProviderStatus(
            name: 'google',
            displayName: 'Google / Vertex AI',
            state: ProviderState.connected,
            statusMessage: 'Connected',
            project: project,
            models: models,
            latency: sw.elapsed,
            icon: 'G');
      }
      return ProviderStatus(
          name: 'google',
          displayName: 'Google / Vertex AI',
          state: ProviderState.error,
          statusMessage: '${resp.statusCode}',
          project: project,
          icon: 'G');
    } catch (e) {
      return ProviderStatus(
          name: 'google',
          displayName: 'Google / Vertex AI',
          state: ProviderState.error,
          statusMessage: 'Connection failed',
          errorDetail: sanitizeError(e.toString()),
          project: project,
          icon: 'G');
    }
  }

  Future<ProviderStatus> testAnthropic(
      {String? project,
      String region = 'us-central1',
      String? accessToken}) async {
    if (project == null || accessToken == null) {
      return ProviderStatus(
          name: 'anthropic',
          displayName: 'Anthropic (Vertex)',
          state: ProviderState.error,
          statusMessage: project == null ? 'No project' : 'No token',
          fixCommand: project == null
              ? 'Set vertex_ai.project'
              : 'gcloud auth application-default login',
          project: project,
          region: region,
          icon: 'A');
    }
    try {
      final sw = Stopwatch()..start();
      final endpoint =
          'https://$region-aiplatform.googleapis.com/v1/projects/$project/locations/$region/publishers/anthropic/models/claude-sonnet-4-20250514';
      final resp = await _guardedGet(Uri.parse(endpoint),
          headers: {'Authorization': 'Bearer $accessToken'});
      sw.stop();
      if (resp == null) {
        return _disposedStatus('anthropic', 'Anthropic (Vertex)');
      }
      if (resp.statusCode == 200 || resp.statusCode == 400) {
        return ProviderStatus(
            name: 'anthropic',
            displayName: 'Anthropic (Vertex)',
            state: ProviderState.connected,
            statusMessage: 'Connected',
            project: project,
            region: region,
            models: const ['claude-sonnet-4'],
            latency: sw.elapsed,
            icon: 'A');
      } else if (resp.statusCode == 403) {
        return ProviderStatus(
            name: 'anthropic',
            displayName: 'Anthropic (Vertex)',
            state: ProviderState.error,
            statusMessage: '403 — Model not enabled',
            errorDetail: 'Enable Claude in Vertex AI Model Garden',
            fixUrl: 'https://console.cloud.google.com/vertex-ai/model-garden',
            project: project,
            region: region,
            icon: 'A');
      }
      return ProviderStatus(
          name: 'anthropic',
          displayName: 'Anthropic (Vertex)',
          state: ProviderState.error,
          statusMessage: '${resp.statusCode}',
          project: project,
          region: region,
          icon: 'A');
    } catch (e) {
      return ProviderStatus(
          name: 'anthropic',
          displayName: 'Anthropic (Vertex)',
          state: ProviderState.error,
          statusMessage: 'Connection failed',
          errorDetail: sanitizeError(e.toString()),
          project: project,
          region: region,
          icon: 'A');
    }
  }

  Future<ProviderStatus> testOpenAI() async {
    final apiKey = Platform.environment['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      return const ProviderStatus(
          name: 'openai',
          displayName: 'OpenAI',
          state: ProviderState.notConfigured,
          statusMessage: 'Not configured',
          errorDetail: 'No OPENAI_API_KEY set',
          icon: 'O');
    }
    try {
      final sw = Stopwatch()..start();
      final resp = await _guardedGet(
          Uri.parse('https://api.openai.com/v1/models'),
          headers: {'Authorization': 'Bearer $apiKey'});
      sw.stop();
      if (resp == null) return _disposedStatus('openai', 'OpenAI');
      if (resp.statusCode == 200) {
        final body = json.decode(resp.body) as Map<String, dynamic>;
        final models = (body['data'] as List?)
                ?.map((m) => (m as Map)['id']?.toString() ?? '')
                .where((n) => n.startsWith('gpt-'))
                .take(5)
                .toList() ??
            [];
        return ProviderStatus(
            name: 'openai',
            displayName: 'OpenAI',
            state: ProviderState.connected,
            statusMessage: 'Connected',
            models: models,
            latency: sw.elapsed,
            icon: 'O');
      }
      return ProviderStatus(
          name: 'openai',
          displayName: 'OpenAI',
          state: ProviderState.error,
          statusMessage: '${resp.statusCode} — Invalid key',
          icon: 'O');
    } catch (e) {
      return ProviderStatus(
          name: 'openai',
          displayName: 'OpenAI',
          state: ProviderState.error,
          statusMessage: 'Connection failed',
          errorDetail: sanitizeError(e.toString()),
          icon: 'O');
    }
  }

  Future<ProviderStatus> testOllama(
      {String host = 'http://localhost:11434'}) async {
    try {
      final sw = Stopwatch()..start();
      final resp = await _client
          .get(Uri.parse('$host/api/tags'))
          .timeout(const Duration(seconds: 5));
      sw.stop();
      if (resp.statusCode == 200) {
        final body = json.decode(resp.body) as Map<String, dynamic>;
        final models = (body['models'] as List?)
                ?.map((m) => (m as Map)['name']?.toString() ?? '')
                .toList() ??
            [];
        return ProviderStatus(
            name: 'ollama',
            displayName: 'Ollama (local)',
            state: ProviderState.connected,
            statusMessage: 'Running',
            models: models,
            latency: sw.elapsed,
            icon: '🦙');
      }
      return ProviderStatus(
          name: 'ollama',
          displayName: 'Ollama (local)',
          state: ProviderState.error,
          statusMessage: '${resp.statusCode}',
          icon: '🦙');
    } catch (_) {
      try {
        final which = await Process.run('which', ['ollama']);
        if (which.exitCode == 0) {
          return const ProviderStatus(
              name: 'ollama',
              displayName: 'Ollama (local)',
              state: ProviderState.error,
              statusMessage: 'Not running',
              errorDetail: 'Ollama is installed but not running',
              fixCommand: 'ollama serve',
              icon: '🦙');
        }
      } catch (_) {}
      return const ProviderStatus(
          name: 'ollama',
          displayName: 'Ollama (local)',
          state: ProviderState.notInstalled,
          statusMessage: 'Not installed',
          fixUrl: 'https://ollama.ai/download',
          icon: '🦙');
    }
  }

  Future<ProviderStatus> testVllm(
      {String host = 'http://localhost:8000'}) async {
    try {
      final sw = Stopwatch()..start();
      final resp = await _client
          .get(Uri.parse('$host/v1/models'))
          .timeout(const Duration(seconds: 5));
      sw.stop();
      if (resp.statusCode == 200) {
        final body = json.decode(resp.body) as Map<String, dynamic>;
        final models = (body['data'] as List?)
                ?.map((m) => (m as Map)['id']?.toString() ?? '')
                .toList() ??
            [];
        return ProviderStatus(
            name: 'vllm',
            displayName: 'vLLM',
            state: ProviderState.connected,
            statusMessage: 'Running',
            models: models,
            latency: sw.elapsed,
            icon: 'V');
      }
      return ProviderStatus(
          name: 'vllm',
          displayName: 'vLLM',
          state: ProviderState.error,
          statusMessage: '${resp.statusCode}',
          icon: 'V');
    } catch (_) {
      return const ProviderStatus(
          name: 'vllm',
          displayName: 'vLLM',
          state: ProviderState.error,
          statusMessage: 'Not running',
          errorDetail: 'No response on port 8000',
          icon: 'V');
    }
  }

  Future<ProviderStatus> testLmStudio(
      {String host = 'http://localhost:1234'}) async {
    try {
      final sw = Stopwatch()..start();
      final resp = await _client
          .get(Uri.parse('$host/v1/models'))
          .timeout(const Duration(seconds: 5));
      sw.stop();
      if (resp.statusCode == 200) {
        final body = json.decode(resp.body) as Map<String, dynamic>;
        final models = (body['data'] as List?)
                ?.map((m) => (m as Map)['id']?.toString() ?? '')
                .toList() ??
            [];
        return ProviderStatus(
            name: 'lmstudio',
            displayName: 'LM Studio',
            state: ProviderState.connected,
            statusMessage: 'Running',
            models: models,
            latency: sw.elapsed,
            icon: 'L');
      }
      return ProviderStatus(
          name: 'lmstudio',
          displayName: 'LM Studio',
          state: ProviderState.error,
          statusMessage: '${resp.statusCode}',
          icon: 'L');
    } catch (_) {
      return const ProviderStatus(
          name: 'lmstudio',
          displayName: 'LM Studio',
          state: ProviderState.error,
          statusMessage: 'Not running',
          errorDetail: 'No response on port 1234',
          icon: 'L');
    }
  }

  /// Test connectivity through the candela proxy.
  /// This is the most important test — it validates the actual user experience.
  Future<ProviderStatus> testProxy({int port = 8181}) async {
    final proxyUrl = 'http://localhost:$port';
    try {
      // First check if proxy is running.
      final sw = Stopwatch()..start();
      final healthResp = await _client
          .get(Uri.parse('$proxyUrl/healthz'))
          .timeout(const Duration(seconds: 3));
      sw.stop();

      if (healthResp.statusCode != 200) {
        return ProviderStatus(
          name: 'proxy',
          displayName: 'Candela Proxy',
          state: ProviderState.error,
          statusMessage: 'Unhealthy (${healthResp.statusCode})',
          icon: '🕯',
          port: port,
        );
      }

      // Proxy is running — try listing models through it.
      final modelsResp = await _guardedGet(Uri.parse('$proxyUrl/v1/models'));
      if (modelsResp == null) return _disposedStatus('proxy', 'Candela Proxy');

      List<String> models = [];
      if (modelsResp.statusCode == 200) {
        try {
          final body = json.decode(modelsResp.body) as Map<String, dynamic>;
          final allModels = (body['data'] as List?)
                  ?.map((m) => (m as Map)['id']?.toString() ?? '')
                  .where((n) => n.isNotEmpty)
                  .toList() ??
              [];
          // Prioritize real model names (gemini, claude, llama) over OpenAI-compat aliases.
          final priority = allModels
              .where((n) =>
                  n.contains('gemini') ||
                  n.contains('claude') ||
                  n.contains('llama'))
              .toList();
          final others = allModels
              .where((n) =>
                  !n.contains('gemini') &&
                  !n.contains('claude') &&
                  !n.contains('llama'))
              .toList();
          // Clean up names: strip date suffixes (e.g. -20250514), deduplicate.
          models = [...priority, ...others]
              .map(_cleanModelName)
              .toSet() // deduplicate
              .take(8)
              .toList();
        } catch (_) {}
      }

      return ProviderStatus(
        name: 'proxy',
        displayName: 'Candela Proxy',
        state: ProviderState.connected,
        statusMessage: 'Running (:$port)',
        models: models,
        latency: sw.elapsed,
        icon: '🕯',
        port: port,
      );
    } catch (_) {
      return ProviderStatus(
        name: 'proxy',
        displayName: 'Candela Proxy',
        state: ProviderState.error,
        statusMessage: 'Not running',
        errorDetail: 'No proxy on localhost:$port',
        fixCommand: 'candela run',
        icon: '🕯',
        port: port,
      );
    }
  }

  /// Verify a specific model is reachable through the proxy by sending a
  /// minimal completion request. Returns true if the model responds.
  Future<ModelVerification> verifyProxyModel(String model,
      {int port = 8181}) async {
    final proxyUrl = 'http://localhost:$port';
    try {
      final sw = Stopwatch()..start();
      final resp = await _client
          .post(
            Uri.parse('$proxyUrl/v1/chat/completions'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'model': model,
              'messages': [
                {'role': 'user', 'content': 'ping'}
              ],
              'max_tokens': 1,
            }),
          )
          .timeout(const Duration(seconds: 15));
      sw.stop();

      if (resp.statusCode == 200) {
        return ModelVerification(
            model: model, reachable: true, latency: sw.elapsed);
      } else {
        String? error;
        try {
          final body = json.decode(resp.body) as Map<String, dynamic>;
          error = (body['error'] as Map?)?['message']?.toString();
        } catch (_) {}
        return ModelVerification(
          model: model,
          reachable: false,
          error: error ?? 'HTTP ${resp.statusCode}',
          latency: sw.elapsed,
        );
      }
    } catch (e) {
      return ModelVerification(
          model: model, reachable: false, error: e.toString());
    }
  }

  /// Verify one representative model per provider category through the proxy.
  Future<List<ModelVerification>> verifyProxyCategories(List<String> models,
      {int port = 8181}) async {
    // Pick one model per category to test.
    final categories = <String, String>{}; // category → model name
    for (final m in models) {
      final cat = modelCategory(m);
      categories.putIfAbsent(cat, () => m);
    }
    // Test all categories in parallel.
    return Future.wait(
      categories.values.map((m) => verifyProxyModel(m, port: port)),
    );
  }

  static final _openAiPattern = RegExp(r'^(gpt-|o[13](-|$))');
  static String modelCategory(String model) {
    if (model.contains('gemini')) return 'google';
    if (model.contains('claude')) return 'anthropic';
    if (model.contains('llama') ||
        model.contains('mistral') ||
        model.contains('phi')) {
      return 'local';
    }
    if (_openAiPattern.hasMatch(model)) return 'openai';
    return 'other';
  }

  /// Clean up raw model IDs to friendly display names.
  /// e.g. "claude-sonnet-4-20250514" → "claude-sonnet-4"
  ///      "gemini-2.0-flash-001"     → "gemini-2.0-flash"
  static String _cleanModelName(String name) {
    // Strip date suffix like -20250514 (exactly 8 digits = YYYYMMDD).
    name = name.replaceAll(_dateSuffixRe, '');
    // Strip trailing version suffix like -001, -002 (common in Google model IDs).
    name = name.replaceAll(_versionSuffixRe, '');
    // Strip @latest only (preserve other @version tags).
    name = name.replaceAll(_latestSuffixRe, '');
    return name;
  }

  /// Perform a guarded GET request that silently returns null if the
  /// service has been disposed mid-flight.
  Future<http.Response?> _guardedGet(Uri url,
      {Map<String, String>? headers}) async {
    if (_disposed) return null;
    try {
      return await _client.get(url, headers: headers).timeout(_timeout);
    } on http.ClientException {
      if (_disposed) return null;
      rethrow;
    }
  }

  /// Return a safe error status when the service was disposed mid-request.
  static ProviderStatus _disposedStatus(String name, String displayName) {
    return ProviderStatus(
      name: name,
      displayName: displayName,
      state: ProviderState.error,
      statusMessage: 'Cancelled',
    );
  }

  void dispose() {
    _disposed = true;
    _client.close();
  }
}
