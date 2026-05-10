import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart' show configService, processManager;
import '../../models/candela_config.dart';
import '../../services/ide_config_writer.dart';
import '../../services/process_manager.dart';
import '../../services/provider_test_service.dart';
import '../../models/provider_status.dart';
import '../../theme/colors.dart';

class IdeGatewayScreen extends StatefulWidget {
  const IdeGatewayScreen({super.key});

  @override
  State<IdeGatewayScreen> createState() => _IdeGatewayScreenState();
}

class _IdeGatewayScreenState extends State<IdeGatewayScreen> {
  CandelaConfig? _config;
  List<ProviderStatus> _providerStatuses = [];
  List<String> _odProjects = [];
  String? _selectedOdProject;
  bool _loading = true;
  bool _disposed = false;
  bool _toggling = false;
  final _providerTest = ProviderTestService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _disposed = true;
    _providerTest.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (!_disposed) setState(() => _loading = true);
    final results = await Future.wait([
      configService.load(),
      IdeConfigWriter.findOpenDesignProjects(),
    ]);
    if (_disposed) return;
    final config = results[0] as CandelaConfig;
    final odProjects = results[1] as List<String>;
    setState(() {
      _config = config;
      _odProjects = odProjects;
      _selectedOdProject = odProjects.isNotEmpty ? odProjects.first : null;
      _loading = false;
    });
    _refreshProviderStatuses(config);
  }

  Future<void> _refreshProviderStatuses(CandelaConfig config) async {
    final statuses = await Future.wait([
      _providerTest.testProxy(port: config.port),
      _providerTest.testOllama(),
      _providerTest.testVllm(),
      _providerTest.testLmStudio(),
    ]);
    if (_disposed) return;
    setState(() => _providerStatuses = statuses);
  }

  Future<void> _toggleGateway(bool enabled) async {
    final config = _config;
    if (config == null || _toggling) return;
    setState(() => _toggling = true);
    try {
      await configService.setIdeGateway(enabled, port: config.port);
      if (enabled) {
        await processManager.start('proxy');
      } else {
        await processManager.stop('proxy');
      }
      await _load();
    } finally {
      if (!_disposed) setState(() => _toggling = false);
    }
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _writeConfig(_IdeSetup ide) async {
    final config = _config;
    if (config == null) return;
    final endpoint = config.ideGateway.endpointUrl;
    try {
      switch (ide.id) {
        case 'continue':
          await IdeConfigWriter.writeContinueConfig(endpoint);
        case 'zed':
          await IdeConfigWriter.writeZedConfig(endpoint);
        case 'opendesign':
          final proj = _selectedOdProject;
          if (proj == null) {
            _showError('No Open Design project selected.');
            return;
          }
          await IdeConfigWriter.writeOpenDesignConfig(proj, endpoint);
        default:
          return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('✅ Config written for ${ide.label}'),
        behavior: SnackBarBehavior.floating,
      ));
    } on StateError catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Failed to write config: $e');
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: CandelaColors.error,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // ── Header ─────────────────────────────────────────────────────────
      Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          color: CandelaColors.bgSecondary,
          border: Border(bottom: BorderSide(color: CandelaColors.borderSubtle)),
        ),
        child: Row(children: [
          const Text('IDE Gateway',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Refresh'),
          ),
        ]),
      ),
      // ── Body ───────────────────────────────────────────────────────────
      Expanded(
        child: _loading && _config == null
            ? const Center(
                child: CircularProgressIndicator(color: CandelaColors.accent))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGatewayCard(),
                      const SizedBox(height: 20),
                      _buildProviderGrid(),
                      const SizedBox(height: 20),
                      _buildIdeSetupSection(),
                    ]),
              ),
      ),
    ]);
  }

  // ── Gateway toggle card ─────────────────────────────────────────────────

  Widget _buildGatewayCard() {
    final config = _config;
    if (config == null) return const SizedBox.shrink();
    final enabled = config.ideGateway.enabled;
    final endpoint = config.ideGateway.endpointUrl;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled
              ? CandelaColors.accent.withValues(alpha: 0.4)
              : CandelaColors.borderSubtle,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color:
                  enabled ? CandelaColors.accentDim : CandelaColors.bgTertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.cable_rounded,
                size: 18,
                color:
                    enabled ? CandelaColors.accent : CandelaColors.textMuted),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('IDE Gateway',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            Text(
              enabled ? 'Running — proxy is accepting connections' : 'Stopped',
              style: TextStyle(
                fontSize: 12,
                color:
                    enabled ? CandelaColors.success : CandelaColors.textMuted,
              ),
            ),
          ]),
          const Spacer(),
          _toggling
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: CandelaColors.accent))
              : Switch(
                  value: enabled,
                  onChanged: _toggleGateway,
                  activeThumbColor: CandelaColors.accent,
                ),
        ]),
        if (enabled) ...[
          const SizedBox(height: 16),
          const Divider(color: CandelaColors.borderSubtle, height: 1),
          const SizedBox(height: 16),
          Row(children: [
            const Text('Endpoint',
                style: TextStyle(
                    fontSize: 12, color: CandelaColors.textSecondary)),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: CandelaColors.bgTertiary,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: CandelaColors.borderSubtle),
                ),
                child: SelectableText(
                  endpoint,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'monospace',
                    color: CandelaColors.accent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _copy(endpoint),
              icon: const Icon(Icons.copy_rounded, size: 18),
              tooltip: 'Copy endpoint URL',
              color: CandelaColors.textSecondary,
            ),
          ]),
        ],
      ]),
    );
  }

  // ── Provider status grid ─────────────────────────────────────────────────

  static const _providerDefs = [
    (name: 'proxy', label: 'Candela Proxy', icon: '🕯'),
    (name: 'ollama', label: 'Ollama', icon: '🦙'),
    (name: 'vllm', label: 'vLLM', icon: 'V'),
    (name: 'lmstudio', label: 'LM Studio', icon: 'L'),
  ];

  Widget _buildProviderGrid() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Providers',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      ListenableBuilder(
        listenable: processManager,
        builder: (_, __) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final def in _providerDefs)
                _buildProviderChip(def.name, def.label, def.icon),
            ],
          );
        },
      ),
    ]);
  }

  Widget _buildProviderChip(String name, String label, String icon) {
    ProviderStatus? status;
    try {
      status = _providerStatuses.firstWhere((s) => s.name == name);
    } catch (_) {}

    final process = processManager.get(name);
    final isRunning = process?.state == ProcessState.running ||
        status?.state == ProviderState.connected;
    final isLoading = status?.state == ProviderState.loading;

    Color dotColor;
    String statusText;
    if (isLoading) {
      dotColor = CandelaColors.textMuted;
      statusText = 'Checking…';
    } else if (isRunning) {
      dotColor = CandelaColors.success;
      statusText = 'Connected';
    } else {
      dotColor = CandelaColors.textMuted;
      statusText = status?.statusMessage ?? 'Not running';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isRunning
              ? CandelaColors.success.withValues(alpha: 0.3)
              : CandelaColors.borderSubtle,
        ),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Row(children: [
            CircleAvatar(radius: 3, backgroundColor: dotColor),
            const SizedBox(width: 4),
            Text(statusText,
                style: const TextStyle(
                    fontSize: 11, color: CandelaColors.textMuted)),
          ]),
        ]),
      ]),
    );
  }

  // ── IDE setup section ────────────────────────────────────────────────────

  static final _ideSetups = [
    const _IdeSetup(
      id: 'continue',
      label: 'Continue (VS Code / JetBrains)',
      icon: Icons.extension_outlined,
      configPath: '~/.continue/config.json',
      canWrite: true,
      snippetBuilder: IdeConfigWriter.continueSnippet,
    ),
    const _IdeSetup(
      id: 'zed',
      label: 'Zed',
      icon: Icons.bolt_outlined,
      configPath: '~/.config/zed/settings.json',
      canWrite: true,
      snippetBuilder: IdeConfigWriter.zedSnippet,
    ),
    const _IdeSetup(
      id: 'opendesign',
      label: 'Open Design',
      icon: Icons.auto_fix_high_outlined,
      configPath: '<project>/.od/media-config.json',
      canWrite: true,
      snippetBuilder: IdeConfigWriter.openDesignSnippet,
    ),
  ];

  Widget _buildIdeSetupSection() {
    final config = _config;
    if (config == null) return const SizedBox.shrink();
    final endpoint = config.ideGateway.endpointUrl;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('IDE Setup',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      const Text(
        'Connect your IDE to the Candela proxy endpoint.',
        style: TextStyle(fontSize: 12, color: CandelaColors.textSecondary),
      ),
      const SizedBox(height: 12),

      // Open Design project picker
      if (_odProjects.isNotEmpty) ...[
        _buildOdProjectPicker(),
        const SizedBox(height: 12),
      ],

      for (final ide in _ideSetups) ...[
        _buildIdeRow(ide, endpoint),
        const SizedBox(height: 8),
      ],
    ]);
  }

  Widget _buildOdProjectPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CandelaColors.borderSubtle),
      ),
      child: Row(children: [
        const Icon(Icons.folder_outlined,
            size: 16, color: CandelaColors.textSecondary),
        const SizedBox(width: 8),
        const Text('Open Design project:',
            style: TextStyle(fontSize: 12, color: CandelaColors.textSecondary)),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButton<String>(
            value: _selectedOdProject,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            dropdownColor: CandelaColors.bgTertiary,
            style: const TextStyle(fontSize: 12),
            items: [
              ..._odProjects.map((proj) => DropdownMenuItem(
                    value: proj,
                    child: Text(
                      proj.replaceFirst(
                          Platform.environment['HOME'] ?? '', '~'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
              const DropdownMenuItem(
                value: '__browse__',
                child: Text('Browse…'),
              ),
            ],
            onChanged: (val) async {
              if (val == '__browse__') {
                // Prompt user to paste a path (file_picker not available here).
                _showBrowseDialog();
              } else {
                setState(() => _selectedOdProject = val);
              }
            },
          ),
        ),
      ]),
    );
  }

  void _showBrowseDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CandelaColors.bgSecondary,
        title: const Text('Open Design Project Path'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '~/code/my-od-project',
            hintStyle: TextStyle(color: CandelaColors.textMuted),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final raw = controller.text.trim();
              if (raw.isEmpty) return;
              final expanded =
                  raw.replaceFirst('~', Platform.environment['HOME'] ?? '');
              setState(() {
                if (!_odProjects.contains(expanded)) {
                  _odProjects = [..._odProjects, expanded];
                }
                _selectedOdProject = expanded;
              });
              Navigator.of(ctx).pop();
            },
            style:
                FilledButton.styleFrom(backgroundColor: CandelaColors.accent),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildIdeRow(_IdeSetup ide, String endpoint) {
    final snippet = ide.snippetBuilder(endpoint);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CandelaColors.borderSubtle),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(ide.icon, size: 16, color: CandelaColors.textSecondary),
          const SizedBox(width: 8),
          Text(ide.label,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          // Copy snippet button
          TextButton.icon(
            onPressed: () => _copy(snippet),
            icon: const Icon(Icons.copy_rounded, size: 14),
            label: const Text('Copy snippet'),
            style: TextButton.styleFrom(
              foregroundColor: CandelaColors.textSecondary,
              textStyle: const TextStyle(fontSize: 12),
            ),
          ),
          // Write Config button
          if (ide.canWrite) ...[
            const SizedBox(width: 6),
            FilledButton.icon(
              onPressed: () => _writeConfig(ide),
              icon: const Icon(Icons.edit_outlined, size: 14),
              label: const Text('Write config'),
              style: FilledButton.styleFrom(
                backgroundColor: CandelaColors.accent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ]),
        const SizedBox(height: 6),
        Text(
          ide.configPath,
          style: const TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              color: CandelaColors.textMuted),
        ),
      ]),
    );
  }
}

// ── IDE setup descriptor ───────────────────────────────────────────────────

class _IdeSetup {
  final String id;
  final String label;
  final IconData icon;
  final String configPath;
  final bool canWrite;
  final String Function(String endpoint) snippetBuilder;

  const _IdeSetup({
    required this.id,
    required this.label,
    required this.icon,
    required this.configPath,
    required this.canWrite,
    required this.snippetBuilder,
  });
}
