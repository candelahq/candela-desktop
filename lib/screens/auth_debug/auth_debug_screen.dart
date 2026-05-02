import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../services/config_service.dart';
import '../../services/gcloud_service.dart';
import '../../services/adc_service.dart';
import '../../services/provider_test_service.dart';
import '../../services/diagnostic_runner.dart';
import '../../models/identity_state.dart';
import '../../models/candela_config.dart';
import '../../models/provider_status.dart';

import 'identity_card.dart';
import 'config_card.dart';
import 'provider_card.dart';
import 'diagnostic_log.dart';

class AuthDebugScreen extends StatefulWidget {
  const AuthDebugScreen({super.key});

  @override
  State<AuthDebugScreen> createState() => _AuthDebugScreenState();
}

class _AuthDebugScreenState extends State<AuthDebugScreen> {
  final _gcloud = GCloudService();
  final _adc = AdcService();
  final _configService = ConfigService();
  final _providerTest = ProviderTestService();
  late final DiagnosticRunner _diagnostics;

  IdentityState? _identity;
  CandelaConfig? _config;
  List<ProviderStatus> _providerStatuses = [];
  String? _lastRemoteUrl;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _diagnostics = DiagnosticRunner(
      config: _configService, gcloud: _gcloud, adc: _adc, providers: _providerTest,
    );
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);

    // Load identity info.
    final installed = await _gcloud.isInstalled();
    final account = installed ? await _gcloud.getActiveAccount() : null;
    final project = installed ? await _gcloud.getProject() : null;
    final adcInfo = await _adc.readAdcFile();
    final tokenInfo = installed ? await _gcloud.getTokenInfo() : null;

    // Load config.
    final config = await _configService.load();

    setState(() {
      _identity = IdentityState(
        email: account, project: project, adcInfo: adcInfo,
        tokenInfo: tokenInfo, gcloudInstalled: installed,
      );
      _config = config;
      _loading = false;
    });

    // Run provider tests.
    _runProviderTests(config, project, tokenInfo);

    // Auto-run diagnostics on first load.
    _diagnostics.runAll();
  }

  Future<void> _runProviderTests(CandelaConfig config, String? project, TokenInfo? token) async {
    // Get raw access token for tests.
    String? accessToken;
    if (token != null && token.isValid) {
      try {
        final result = await Process.run('gcloud',
          ['auth', 'application-default', 'print-access-token'],
          environment: _gcloud.augmentedEnv);
        if (result.exitCode == 0) accessToken = (result.stdout as String).trim();
      } catch (_) {}
    }

    final region = config.vertexAI?.effectiveRegion ?? 'us-central1';

    // Build provider list dynamically from config.
    final loadingStatuses = <ProviderStatus>[
      // Proxy always shown.
      const ProviderStatus(name: 'proxy', displayName: 'Candela Proxy', state: ProviderState.loading, icon: '🕯'),
    ];
    final testFutures = <Future<ProviderStatus>>[
      _providerTest.testProxy(port: config.port),
    ];

    // Cloud providers from config.
    final providerNames = config.providers.map((p) => p.name).toSet();
    if (providerNames.contains('google') || providerNames.contains('gemini')) {
      loadingStatuses.add(const ProviderStatus(name: 'google', displayName: 'Google / Vertex AI', state: ProviderState.loading, icon: 'G'));
      testFutures.add(_providerTest.testGoogle(project: project, accessToken: accessToken));
    }
    if (providerNames.contains('anthropic')) {
      loadingStatuses.add(const ProviderStatus(name: 'anthropic', displayName: 'Anthropic (Vertex)', state: ProviderState.loading, icon: 'A'));
      testFutures.add(_providerTest.testAnthropic(project: project, region: region, accessToken: accessToken));
    }
    if (providerNames.contains('openai')) {
      loadingStatuses.add(const ProviderStatus(name: 'openai', displayName: 'OpenAI', state: ProviderState.loading, icon: 'O'));
      testFutures.add(_providerTest.testOpenAI());
    }

    // Runtime backend (ollama, vllm, etc).
    if (config.runtimeBackend == 'ollama' || config.runtimeBackend == null) {
      loadingStatuses.add(const ProviderStatus(name: 'ollama', displayName: 'Ollama (local)', state: ProviderState.loading, icon: '🦙'));
      testFutures.add(_providerTest.testOllama());
    }

    setState(() => _providerStatuses = loadingStatuses);

    final results = await Future.wait(testFutures);
    setState(() => _providerStatuses = results);
  }

  bool _isRemovableProvider(String name) {
    // Only the proxy card is non-removable.
    return name != 'proxy';
  }

  Future<void> _removeProvider(String providerName) async {
    if (providerName == 'ollama') {
      // Ollama is runtime_backend, not in providers list.
      await _configService.setRuntimeBackend(null);
    } else {
      await _configService.removeProvider(providerName);
    }
    await _loadAll();
  }

  void _showAddProviderDialog() {
    final cloudProviders = [
      ('google', 'Google / Gemini', 'G', 'Vertex AI — Gemini models'),
      ('anthropic', 'Anthropic / Claude', 'A', 'Vertex AI — Claude models'),
      ('openai', 'OpenAI', 'O', 'Direct API — requires API key'),
    ];
    final localBackends = [
      ('ollama', 'Ollama', '🦙', 'Local runtime — llama, mistral, etc.'),
      ('vllm', 'vLLM', 'V', 'High-performance local/remote serving'),
      ('lmstudio', 'LM Studio', 'L', 'Desktop app — OpenAI-compatible API'),
    ];

    final configuredProviders = _config?.providers.map((p) => p.name).toSet() ?? {};
    final currentBackend = _config?.runtimeBackend;

    final availableCloud = cloudProviders.where((a) => !configuredProviders.contains(a.$1)).toList();
    final availableBackends = localBackends.where((a) => a.$1 != currentBackend).toList();

    if (availableCloud.isEmpty && availableBackends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All providers and backends are already configured')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CandelaColors.bgSecondary,
        title: const Text('Add Provider / Backend'),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (availableCloud.isNotEmpty) ...[
                const Text('CLOUD PROVIDERS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                  color: CandelaColors.textMuted, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text('Added to providers: list in config', style: TextStyle(fontSize: 10, color: CandelaColors.textMuted)),
                const SizedBox(height: 8),
                for (final (name, display, icon, desc) in availableCloud)
                  _choiceTile(ctx, name, display, icon, desc, isBackend: false),
              ],
              if (availableCloud.isNotEmpty && availableBackends.isNotEmpty)
                const Divider(height: 24),
              if (availableBackends.isNotEmpty) ...[
                const Text('LOCAL BACKENDS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                  color: CandelaColors.textMuted, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text('Sets runtime_backend in config (only one active)',
                  style: TextStyle(fontSize: 10, color: CandelaColors.textMuted)),
                const SizedBox(height: 8),
                for (final (name, display, icon, desc) in availableBackends)
                  _choiceTile(ctx, name, display, icon, desc, isBackend: true),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  Widget _choiceTile(BuildContext ctx, String name, String display, String icon, String desc, {required bool isBackend}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isBackend ? CandelaColors.bgTertiary : CandelaColors.accentDim,
        child: Text(icon, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      title: Text(display),
      subtitle: Text(desc, style: const TextStyle(fontSize: 12, color: CandelaColors.textSecondary)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      hoverColor: CandelaColors.bgHover,
      onTap: () async {
        Navigator.of(ctx).pop();
        if (isBackend) {
          await _configService.setRuntimeBackend(name);
        } else {
          await _configService.addProvider(name);
        }
        await _loadAll();
      },
    );
  }

  @override
  void dispose() {
    _diagnostics.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            color: CandelaColors.bgSecondary,
            border: Border(bottom: BorderSide(color: CandelaColors.borderSubtle)),
          ),
          child: Row(
            children: [
              const Text('Auth & Connectivity',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: _loading ? null : _loadAll,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Run All Tests'),
              ),
            ],
          ),
        ),
        // Body
        Expanded(
          child: _loading && _identity == null
              ? const Center(child: CircularProgressIndicator(color: CandelaColors.accent))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Identity + Config
                      if (_identity != null)
                        IdentityCard(identity: _identity!, onRefresh: _loadAll),
                      const SizedBox(height: 16),
                      if (_config != null)
                        ConfigCard(
                          config: _config!,
                          onSwitchToSolo: () async {
                            // Preserve remote URL for easy switch-back.
                            _lastRemoteUrl = _config?.remote;
                            await _configService.setMode();
                            await _loadAll();
                          },
                          onSwitchToTeam: (url) async {
                            await _configService.setMode(remote: url);
                            await _loadAll();
                          },
                        ),
                      const SizedBox(height: 24),

                      // Section 2: Provider Connectivity
                      Row(
                        children: [
                          const Text('Provider Connectivity',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _showAddProviderDialog,
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Add Provider'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossCount = constraints.maxWidth > 1000 ? 4 : 2;
                          return GridView.count(
                            crossAxisCount: crossCount,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.5,
                            children: [
                              for (final s in _providerStatuses)
                                ProviderCard(
                                  status: s,
                                  // Allow removing cloud providers (not proxy or ollama runtime).
                                  onRemove: _isRemovableProvider(s.name)
                                      ? () => _removeProvider(s.name)
                                      : null,
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Section 3: Diagnostic Log
                      const Text('Diagnostic Log',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      DiagnosticLog(runner: _diagnostics),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
