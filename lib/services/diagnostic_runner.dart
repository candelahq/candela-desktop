import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/diagnostic_entry.dart';
import '../models/provider_status.dart';
import '../models/candela_config.dart';
import 'config_service.dart';
import 'candela_auth_service.dart';
import 'adc_service.dart';
import 'provider_test_service.dart';

/// Orchestrates all diagnostic checks sequentially, streaming results.
///
/// No `gcloud` subprocess is spawned. All auth checks use [AdcService] for
/// direct file reading and OAuth2 token refresh, and [CandelaAuthService]
/// for CLI detection (advisory only — not a gate).
class DiagnosticRunner {
  final ConfigService _config;
  final CandelaAuthService _candelaAuth;
  final AdcService _adc;
  final ProviderTestService _providers;

  final _controller = StreamController<DiagnosticEntry>.broadcast();
  Stream<DiagnosticEntry> get entries => _controller.stream;

  final List<DiagnosticEntry> history = [];
  bool _running = false;
  bool _disposed = false;
  bool get isRunning => _running;

  /// Completer for the current run, used to reject/await concurrent calls.
  Completer<DiagnosticSummary>? _runCompleter;

  DiagnosticRunner({
    required ConfigService config,
    CandelaAuthService? candelaAuth,
    AdcService? adc,
    ProviderTestService? providers,
  })  : _config = config,
        _candelaAuth = candelaAuth ?? CandelaAuthService(),
        _adc = adc ?? AdcService(),
        _providers = providers ?? ProviderTestService();

  /// Run all diagnostic checks. Returns summary when complete.
  /// Rejects concurrent runs by returning the in-flight future.
  Future<DiagnosticSummary> runAll() async {
    if (_running && _runCompleter != null) {
      return _runCompleter!.future;
    }
    _running = true;
    final completer = Completer<DiagnosticSummary>();
    _runCompleter = completer;
    try {
      final result = await _runAllImpl();
      completer.complete(result);
      return result;
    } catch (e, st) {
      completer.completeError(e, st);
      rethrow;
    } finally {
      _running = false;
      // Only clear if we're still the active completer — a new run may have
      // already replaced it.
      if (_runCompleter == completer) _runCompleter = null;
    }
  }

  Future<DiagnosticSummary> _runAllImpl() async {
    // Replace history list contents instead of clearing, to avoid
    // ConcurrentModificationError in DiagnosticLog's ListView.
    history.replaceRange(0, history.length, []);
    int passed = 0, failed = 0, warned = 0;

    // 1. Candela CLI (advisory — NOT a gate)
    _emit('Checking Candela CLI...', DiagnosticStatus.running);
    if (_disposed) {
      return const DiagnosticSummary(passed: 0, failed: 0, warned: 0);
    }
    if (await _candelaAuth.isCandelaInstalled()) {
      _emit('Candela CLI installed', DiagnosticStatus.pass);
      passed++;
    } else {
      _emit(
          'Candela CLI not found — install via: brew install candelahq/tap/candela',
          DiagnosticStatus.warn);
      warned++;
      // NOT a gate — diagnostics continue regardless.
    }

    // 2. Config file
    _emit('Reading config file...', DiagnosticStatus.running);
    final config = await _config.load();
    if (config.issues.any((i) => i.severity == IssueSeverity.error)) {
      for (final issue
          in config.issues.where((i) => i.severity == IssueSeverity.error)) {
        _emit('Config: ${issue.message}', DiagnosticStatus.fail);
        failed++;
      }
    } else {
      final modeLabel = switch (config.mode) {
        CandelaMode.solo => 'Solo Mode',
        CandelaMode.soloCloud => 'Solo + Cloud Mode',
        CandelaMode.team => 'Team Mode',
      };
      _emit(
          'Config loaded ($modeLabel) — ${config.path}', DiagnosticStatus.pass);
      passed++;
      for (final issue
          in config.issues.where((i) => i.severity == IssueSeverity.warning)) {
        _emit('Config: ${issue.message}', DiagnosticStatus.warn);
        warned++;
      }
    }

    // 3. ADC
    if (_disposed) {
      return DiagnosticSummary(passed: passed, failed: failed, warned: warned);
    }
    _emit('Checking Application Default Credentials...',
        DiagnosticStatus.running);
    final adc = await _adc.readAdcFile();
    if (adc == null) {
      _emit('No ADC found', DiagnosticStatus.fail,
          fixCommand: 'candela auth login');
      failed++;
    } else {
      _emit(
          'ADC: ${adc.displayType}${adc.clientEmail != null ? ' (${adc.clientEmail})' : ''}',
          DiagnosticStatus.pass);
      passed++;
    }

    // 4. Token (direct OAuth2 refresh — no subprocess)
    if (_disposed) {
      return DiagnosticSummary(passed: passed, failed: failed, warned: warned);
    }
    _emit('Validating access token...', DiagnosticStatus.running);
    final token = await _adc.refreshAccessToken(adcInfo: adc);
    String? accessTokenStr;
    if (token == null) {
      _emit('Could not acquire token', DiagnosticStatus.fail,
          fixCommand: 'candela auth login');
      failed++;
    } else if (!token.isValid) {
      _emit('Token expired', DiagnosticStatus.fail,
          fixCommand: 'candela auth login');
      failed++;
    } else {
      _emit('Token valid (expires in ${token.expiryDisplay})',
          DiagnosticStatus.pass);
      passed++;
      accessTokenStr = token.accessToken;
    }

    // 4b. Team backend auth (ID token + connectivity)
    if (config.mode == CandelaMode.team &&
        config.remote != null &&
        config.remote!.isNotEmpty) {
      if (_disposed) {
        return DiagnosticSummary(
            passed: passed, failed: failed, warned: warned);
      }

      // Test audience-specific ID token if configured.
      if (config.audience != null &&
          config.audience!.isNotEmpty &&
          adc != null) {
        _emit('Validating team auth (ID token for ${config.audience})...',
            DiagnosticStatus.running);
        final idToken =
            await _candelaAuth.getIdToken(audience: config.audience!);
        if (idToken == null) {
          _emit('Could not acquire ID token for team backend',
              DiagnosticStatus.fail,
              detail:
                  'The access token works, but the audience-specific ID token '
                  'exchange failed. Your ADC credentials may need refreshing.',
              fixCommand: 'candela auth login');
          failed++;
        } else {
          _emit('Team auth: ID token acquired', DiagnosticStatus.pass);
          passed++;
        }
      }

      // Test connectivity to the remote backend.
      _emit('Testing team backend (${config.remote})...',
          DiagnosticStatus.running);
      try {
        final uri = Uri.parse(config.remote!);
        final healthUri = uri.replace(path: '/healthz');
        final resp =
            await http.get(healthUri).timeout(const Duration(seconds: 5));
        if (resp.statusCode == 200 || resp.statusCode == 204) {
          _emit('Team backend: Reachable', DiagnosticStatus.pass);
          passed++;
        } else {
          _emit('Team backend: HTTP ${resp.statusCode}', DiagnosticStatus.warn,
              detail: 'Backend responded but health check returned '
                  '${resp.statusCode}');
          warned++;
        }
      } catch (e) {
        _emit('Team backend: Unreachable', DiagnosticStatus.fail,
            detail: 'Could not connect to ${config.remote}');
        failed++;
      }
    }

    // 5. GCP Project (from config or ADC quota_project — no subprocess)
    if (_disposed) {
      return DiagnosticSummary(passed: passed, failed: failed, warned: warned);
    }
    _emit('Checking GCP project...', DiagnosticStatus.running);
    final project = config.vertexAI?.project ?? adc?.quotaProject;
    if (project != null && project.isNotEmpty) {
      _emit('Project: $project', DiagnosticStatus.pass);
      passed++;
    } else {
      _emit('No GCP project configured', DiagnosticStatus.warn,
          detail:
              'Set vertex_ai.project in ~/.candela/config.yaml or quota_project_id in ADC');
      warned++;
    }

    // 6. Provider tests — only test what's configured.
    if (_disposed) {
      return DiagnosticSummary(passed: passed, failed: failed, warned: warned);
    }

    // Always test the proxy.
    _emit(
        'Testing Candela Proxy (:${config.port})...', DiagnosticStatus.running);
    final proxyStatus = await _providers.testProxy(port: config.port);
    if (proxyStatus.isHealthy) {
      _emit('Proxy: Running — ${proxyStatus.models.length} models available',
          DiagnosticStatus.pass);
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
      final googleStatus = await _providers.testGoogle(
          project: project, accessToken: accessTokenStr);
      if (googleStatus.isHealthy) {
        _emit('Google: Connected (${googleStatus.latency?.inMilliseconds}ms)',
            DiagnosticStatus.pass);
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
          project: project,
          region: config.vertexAI?.effectiveRegion ?? 'us-central1',
          accessToken: accessTokenStr);
      if (anthropicStatus.isHealthy) {
        _emit(
            'Anthropic: Connected (${anthropicStatus.latency?.inMilliseconds}ms)',
            DiagnosticStatus.pass);
        passed++;
      } else {
        _emit('Anthropic: ${anthropicStatus.statusMessage}',
            DiagnosticStatus.fail,
            detail: anthropicStatus.errorDetail,
            fixUrl: anthropicStatus.fixUrl);
        failed++;
      }
    }

    if (providerNames.contains('openai')) {
      _emit('Testing OpenAI...', DiagnosticStatus.running);
      final openaiStatus = await _providers.testOpenAI();
      if (openaiStatus.isHealthy) {
        _emit('OpenAI: Connected (${openaiStatus.latency?.inMilliseconds}ms)',
            DiagnosticStatus.pass);
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
        _emit('Ollama: Running — ${ollamaStatus.models.length} models',
            DiagnosticStatus.pass);
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
    return DiagnosticSummary(passed: passed, failed: failed, warned: warned);
  }

  void _emit(String message, DiagnosticStatus status,
      {String? detail, String? fixCommand, String? fixUrl}) {
    if (_disposed) return; // Guard: controller may already be closed.
    final entry = DiagnosticEntry(
        timestamp: DateTime.now(),
        message: message,
        status: status,
        detail: detail,
        fixCommand: fixCommand,
        fixUrl: fixUrl);
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
    _disposed = true;
    _controller.close();
    _providers.dispose();
  }
}
