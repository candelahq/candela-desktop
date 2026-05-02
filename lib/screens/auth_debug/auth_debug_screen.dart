import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../services/gcloud_service.dart';
import '../../services/adc_service.dart';
import '../../services/provider_test_service.dart';
import '../../services/diagnostic_runner.dart';
import '../../services/process_manager.dart';
import '../../models/identity_state.dart';
import '../../models/candela_config.dart';
import '../../models/provider_status.dart';
import '../../main.dart' show processManager, configService;

import 'identity_card.dart';
import 'config_card.dart';
import 'provider_card.dart';
import 'runtime_control_card.dart';
import 'diagnostic_log.dart';

class AuthDebugScreen extends StatefulWidget {
  const AuthDebugScreen({super.key});

  @override
  State<AuthDebugScreen> createState() => _AuthDebugScreenState();
}

class _AuthDebugScreenState extends State<AuthDebugScreen> {
  final _gcloud = GCloudService();
  final _adc = AdcService();
  final _configService = configService;
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

    // Sync process manager with config.
    processManager.configure(
      providerNames: config.providers.map((p) => p.name).toList(),
      proxyPort: config.port.toString(),
    );
    await processManager.detectRunning();

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

    // NOTE: Runtime backends (ollama, vllm, lmstudio) are NOT listed here —
    // they're managed in the "Runtime Processes" section via ProcessManager.

    // Local providers from config.
    if (providerNames.contains('ollama')) {
      loadingStatuses.add(const ProviderStatus(name: 'ollama', displayName: 'Ollama', state: ProviderState.loading, icon: '🦙'));
      testFutures.add(_providerTest.testOllama());
    }
    if (providerNames.contains('vllm')) {
      loadingStatuses.add(const ProviderStatus(name: 'vllm', displayName: 'vLLM', state: ProviderState.loading, icon: 'V'));
      testFutures.add(_providerTest.testVllm());
    }
    if (providerNames.contains('lmstudio')) {
      loadingStatuses.add(const ProviderStatus(name: 'lmstudio', displayName: 'LM Studio', state: ProviderState.loading, icon: 'L'));
      testFutures.add(_providerTest.testLmStudio());
    }

    setState(() => _providerStatuses = loadingStatuses);

    final results = await Future.wait(testFutures);
    setState(() => _providerStatuses = results);
  }

  bool _isRemovableProvider(String name) {
    return name != 'proxy';
  }

  static const _localProviders = {'ollama', 'vllm', 'lmstudio'};

  bool _isLocalProvider(String name) => _localProviders.contains(name);

  Future<void> _removeProvider(String providerName) async {
    await _configService.removeProvider(providerName);
    await _loadAll();
  }

  void _showAddProviderDialog() {
    final allProviders = [
      ('google', 'Google / Gemini', 'G', 'Vertex AI — Gemini models'),
      ('anthropic', 'Anthropic / Claude', 'A', 'Vertex AI — Claude models'),
      ('openai', 'OpenAI', 'O', 'Direct API — requires API key'),
      ('ollama', 'Ollama', '🦙', 'Local runtime — llama, mistral, etc.'),
      ('vllm', 'vLLM', 'V', 'High-performance local/remote serving'),
      ('lmstudio', 'LM Studio', 'L', 'Desktop app — OpenAI-compatible API'),
    ];

    final configured = _config?.providers.map((p) => p.name).toSet() ?? {};
    final choices = allProviders.where((a) => !configured.contains(a.$1)).toList();

    if (choices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All providers are already configured')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CandelaColors.bgSecondary,
        title: const Text('Add Provider'),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (name, display, icon, desc) in choices)
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _isLocalProvider(name) ? CandelaColors.bgTertiary : CandelaColors.accentDim,
                    child: Text(icon, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  title: Row(children: [
                    Text(display),
                    if (_isLocalProvider(name)) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: CandelaColors.bgTertiary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('LOCAL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: CandelaColors.textMuted)),
                      ),
                    ],
                  ]),
                  subtitle: Text(desc, style: const TextStyle(fontSize: 12, color: CandelaColors.textSecondary)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  hoverColor: CandelaColors.bgHover,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await _configService.addProvider(name);
                    await _loadAll();
                  },
                ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
        ],
      ),
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
                          onPortChanged: (field, port) async {
                            await _configService.setPort(field, port);
                            await _loadAll();
                          },
                        ),
                      const SizedBox(height: 24),

                      // Section 2: Providers (cloud + local unified)
                      Row(
                        children: [
                          const Text('Providers',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          ListenableBuilder(
                            listenable: processManager,
                            builder: (_, __) {
                              final running = processManager.all.where((p) => p.state == ProcessState.running).length;
                              if (running > 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Text('$running process${running > 1 ? "es" : ""} running',
                                    style: const TextStyle(fontSize: 12, color: CandelaColors.textMuted)),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          TextButton.icon(
                            onPressed: _showAddProviderDialog,
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Add Provider'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ListenableBuilder(
                        listenable: processManager,
                        builder: (context, _) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final crossCount = constraints.maxWidth > 1000 ? 4 : 2;
                              return GridView.count(
                                crossAxisCount: crossCount,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.4,
                                children: [
                                  for (final s in _providerStatuses)
                                    _isLocalProvider(s.name)
                                      ? RuntimeControlCard(
                                          process: processManager.get(s.name) ?? ManagedProcess(name: s.name, displayName: s.displayName, icon: s.icon ?? '?'),
                                          onStart: () => processManager.start(s.name),
                                          onStop: () => processManager.stop(s.name),
                                          onRestart: () => processManager.restart(s.name),
                                          onRemove: _isRemovableProvider(s.name) ? () => _removeProvider(s.name) : null,
                                          providerStatus: s,
                                        )
                                      : ProviderCard(
                                          status: s,
                                          onRemove: _isRemovableProvider(s.name)
                                              ? () => _removeProvider(s.name)
                                              : null,
                                        ),
                                ],
                              );
                            },
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
