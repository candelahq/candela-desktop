import 'dart:async';
import 'dart:io';
import '../models/diagnostic_entry.dart';
import '../models/provider_status.dart';
import '../models/candela_config.dart';
import 'config_service.dart';
import 'gcloud_service.dart';
import 'adc_service.dart';
import 'provider_test_service.dart';
import '../main.dart' show configService;

/// Orchestrates all diagnostic checks sequentially, streaming results.
class DiagnosticRunner {
  final ConfigService _config;
  final GCloudService _gcloud;
  final AdcService _adc;
  final ProviderTestService _providers;

  final _controller = StreamController<DiagnosticEntry>.broadcast();
  Stream<DiagnosticEntry> get entries => _controller.stream;

  final List<DiagnosticEntry> history = [];
  bool _running = false;
  bool get isRunning => _running;

  DiagnosticRunner({
    ConfigService? config,
    GCloudService? gcloud,
    AdcService? adc,
    ProviderTestService? providers,
  })  : _config = config ?? configService,
        _gcloud = gcloud ?? GCloudService(),
        _adc = adc ?? AdcService(),
        _providers = providers ?? ProviderTestService();

  /// Run all diagnostic checks. Returns summary when complete.
  Future<DiagnosticSummary> runAll() async {
    _running = true;
    history.clear();
    int passed = 0, failed = 0, warned = 0;

    // 1. gcloud CLI
    _emit('Checking gcloud CLI...', DiagnosticStatus.running);
    if (await _gcloud.isInstalled()) {
      _emit('gcloud CLI installed', DiagnosticStatus.pass);
      passed++;
    } else {
      _emit('gcloud CLI not found', DiagnosticStatus.fail,
          fixUrl: 'https://cloud.google.com/sdk/docs/install');
      failed++;
      _emitSummary(passed, failed, warned);
      _running = false;
      return DiagnosticSummary(passed: passed, failed: failed, warned: warned);
    }

    // 2. Config file
    _emit('Reading config file...', DiagnosticStatus.running);
    final config = await _config.load();
    if (config.issues.any((i) => i.severity == IssueSeverity.error)) {
      for (final issue in config.issues.where((i) => i.severity == IssueSeverity.error)) {
        _emit('Config: ${issue.message}', DiagnosticStatus.fail);
        failed++;
      }
    } else {
      final modeLabel = switch (config.mode) {
        CandelaMode.solo => 'Solo Mode',
        CandelaMode.soloCloud => 'Solo + Cloud Mode',
        CandelaMode.team => 'Team Mode',
      };
      _emit('Config loaded ($modeLabel) — ${config.path}', DiagnosticStatus.pass);
      passed++;
      for (final issue in config.issues.where((i) => i.severity == IssueSeverity.warning)) {
        _emit('Config: ${issue.message}', DiagnosticStatus.warn);
        warned++;
      }
    }

    // 3. ADC
    _emit('Checking Application Default Credentials...', DiagnosticStatus.running);
    final adc = await _adc.readAdcFile();
    if (adc == null) {
      _emit('No ADC found', DiagnosticStatus.fail,
          fixCommand: 'gcloud auth application-default login');
      failed++;
    } else {
      _emit('ADC: ${adc.displayType}${adc.clientEmail != null ? ' (${adc.clientEmail})' : ''}', DiagnosticStatus.pass);
      passed++;
    }

    // 4. Token
    _emit('Validating access token...', DiagnosticStatus.running);
    final token = await _gcloud.getTokenInfo();
    String? accessTokenStr;
    if (token == null) {
      _emit('Could not acquire token', DiagnosticStatus.fail,
          fixCommand: 'gcloud auth application-default login');
      failed++;
    } else if (!token.isValid) {
      _emit('Token expired', DiagnosticStatus.fail,
          fixCommand: 'gcloud auth application-default login');
      failed++;
    } else {
      _emit('Token valid (expires in ${token.expiryDisplay})', DiagnosticStatus.pass);
      passed++;
      // Get raw token for provider tests.
      try {
        final result = await Process.run('gcloud',
          ['auth', 'application-default', 'print-access-token'],
          environment: _gcloud.augmentedEnv);
        if (result.exitCode == 0) accessTokenStr = (result.stdout as String).trim();
      } catch (_) {}
    }

    // 5. GCP Project
    _emit('Checking GCP project...', DiagnosticStatus.running);
    final project = config.vertexAI?.project ?? await _gcloud.getProject();
    if (project != null && project.isNotEmpty) {
      _emit('Project: $project', DiagnosticStatus.pass);
      passed++;
    } else {
      _emit('No GCP project configured', DiagnosticStatus.warn,
          fixCommand: 'gcloud config set project YOUR-PROJECT');
      warned++;
    }

    // 6. Provider tests — only test what's configured.

    // Always test the proxy.
    _emit('Testing Candela Proxy (:${config.port})...', DiagnosticStatus.running);
    final proxyStatus = await _providers.testProxy(port: config.port);
    if (proxyStatus.isHealthy) {
      _emit('Proxy: Running — ${proxyStatus.models.length} models available', DiagnosticStatus.pass);
      passed++;
    } else {
      _emit('Proxy: ${proxyStatus.statusMessage}', DiagnosticStatus.warn,
          fixCommand: proxyStatus.fixCommand);
      warned++;
    }

    // Test configured cloud providers.
    final providerNames = config.providers.map((p) => p.name).toSet();

    if (providerNames.contains('google') || providerNames.contains('gemini')) {
      _emit('Testing Google / Vertex AI...', DiagnosticStatus.running);
      final googleStatus = await _providers.testGoogle(project: project, accessToken: accessTokenStr);
      if (googleStatus.isHealthy) {
        _emit('Google: Connected (${googleStatus.latency?.inMilliseconds}ms)', DiagnosticStatus.pass);
        passed++;
      } else {
        _emit('Google: ${googleStatus.statusMessage}', DiagnosticStatus.fail,
            fixCommand: googleStatus.fixCommand, fixUrl: googleStatus.fixUrl);
        failed++;
      }
    }

    if (providerNames.contains('anthropic')) {
      _emit('Testing Anthropic (Vertex AI)...', DiagnosticStatus.running);
      final anthropicStatus = await _providers.testAnthropic(
        project: project, region: config.vertexAI?.effectiveRegion ?? 'us-central1', accessToken: accessTokenStr);
      if (anthropicStatus.isHealthy) {
        _emit('Anthropic: Connected (${anthropicStatus.latency?.inMilliseconds}ms)', DiagnosticStatus.pass);
        passed++;
      } else {
        _emit('Anthropic: ${anthropicStatus.statusMessage}', DiagnosticStatus.fail,
            detail: anthropicStatus.errorDetail, fixUrl: anthropicStatus.fixUrl);
        failed++;
      }
    }

    if (providerNames.contains('openai')) {
      _emit('Testing OpenAI...', DiagnosticStatus.running);
      final openaiStatus = await _providers.testOpenAI();
      if (openaiStatus.isHealthy) {
        _emit('OpenAI: Connected (${openaiStatus.latency?.inMilliseconds}ms)', DiagnosticStatus.pass);
        passed++;
      } else {
        _emit('OpenAI: ${openaiStatus.statusMessage}', DiagnosticStatus.fail,
            fixCommand: openaiStatus.fixCommand);
        failed++;
      }
    }

    // Test local runtime backends from providers list.
    if (providerNames.contains('ollama')) {
      _emit('Testing Ollama (local)...', DiagnosticStatus.running);
      final ollamaStatus = await _providers.testOllama();
      if (ollamaStatus.isHealthy) {
        _emit('Ollama: Running — ${ollamaStatus.models.length} models', DiagnosticStatus.pass);
        passed++;
      } else if (ollamaStatus.state == ProviderState.notInstalled) {
        _emit('Ollama: Not installed', DiagnosticStatus.info);
      } else {
        _emit('Ollama: ${ollamaStatus.statusMessage}', DiagnosticStatus.warn,
            fixCommand: ollamaStatus.fixCommand);
        warned++;
      }
    }

    _emitSummary(passed, failed, warned);
    _running = false;
    return DiagnosticSummary(passed: passed, failed: failed, warned: warned);
  }

  void _emit(String message, DiagnosticStatus status, {String? detail, String? fixCommand, String? fixUrl}) {
    final entry = DiagnosticEntry(
      timestamp: DateTime.now(), message: message, status: status,
      detail: detail, fixCommand: fixCommand, fixUrl: fixUrl);
    history.add(entry);
    _controller.add(entry);
  }

  void _emitSummary(int passed, int failed, int warned) {
    _emit('────────────────────────────────', DiagnosticStatus.info);
    final msg = failed == 0
        ? 'All ${passed + warned} checks passed! 🎉'
        : '$passed/${passed + failed + warned} passed. $failed issue${failed > 1 ? 's' : ''} need attention.';
    _emit(msg, failed == 0 ? DiagnosticStatus.pass : DiagnosticStatus.fail);
  }

  void dispose() {
    _controller.close();
    _providers.dispose();
  }
}
