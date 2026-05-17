import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../models/candela_config.dart';
import '../../providers.dart';
import '../../theme/colors.dart';
import '../../services/config_service.dart';

/// Dedicated settings screen — surfaces config, appearance, and startup options.
class SettingsScreen extends ConsumerStatefulWidget {
  /// Callback to toggle theme mode from the app shell.
  final ValueChanged<ThemeMode>? onThemeModeChanged;
  final ThemeMode currentThemeMode;

  const SettingsScreen({
    super.key,
    this.onThemeModeChanged,
    this.currentThemeMode = ThemeMode.dark,
  });

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  CandelaConfig? _config;
  bool _loading = true;
  bool _launchAtLogin = false;
  String _version = '…';

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    final config = await ref.read(configServiceProvider).load();
    final info = await PackageInfo.fromPlatform();
    bool launchEnabled = false;
    try {
      launchEnabled = await LaunchAtStartup.instance.isEnabled();
    } catch (_) {
      // Plugin may not be available on all platforms.
    }
    if (!mounted) return;
    setState(() {
      _config = config;
      _version = 'v${info.version}';
      _launchAtLogin = launchEnabled;
      _loading = false;
    });
  }

  Future<void> _toggleLaunchAtLogin(bool value) async {
    try {
      if (value) {
        await LaunchAtStartup.instance.enable();
      } else {
        await LaunchAtStartup.instance.disable();
      }
      if (mounted) setState(() => _launchAtLogin = value);
    } catch (_) {
      // Silently fail — not all platforms support this.
    }
  }

  Future<void> _setPort(String field, int port) async {
    await ref.read(configServiceProvider).setPort(field, port);
    await _loadAll();
  }

  Future<void> _setMode({String? remote, String? audience}) async {
    await ref.read(configServiceProvider).setMode(
          remote: remote,
          audience: audience,
        );
    await _loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CandelaColors.bgPrimary,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _loading
                ? const Center(
                    child:
                        CircularProgressIndicator(color: CandelaColors.accent))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAppearanceSection(),
                        const SizedBox(height: 24),
                        _buildStartupSection(),
                        const SizedBox(height: 24),
                        _buildNetworkSection(),
                        const SizedBox(height: 24),
                        _buildPerformanceSection(),
                        const SizedBox(height: 24),
                        _buildOptimizationSection(),
                        const SizedBox(height: 24),
                        _buildModeSection(),
                        const SizedBox(height: 24),
                        _buildAboutSection(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: CandelaColors.bgSecondary,
        border: Border(bottom: BorderSide(color: CandelaColors.border)),
      ),
      child: const Row(
        children: [
          Text('Settings',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: CandelaColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return _SettingsSection(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        _SettingsRow(
          label: 'Theme',
          subtitle: 'Choose dark, light, or follow system',
          child: SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('System', style: TextStyle(fontSize: 12))),
              ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Dark', style: TextStyle(fontSize: 12))),
              ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Light', style: TextStyle(fontSize: 12))),
            ],
            selected: {widget.currentThemeMode},
            onSelectionChanged: (s) => widget.onThemeModeChanged?.call(s.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartupSection() {
    return _SettingsSection(
      title: 'Startup',
      icon: Icons.rocket_launch_outlined,
      children: [
        _SettingsRow(
          label: 'Launch at login',
          subtitle: 'Start Candela automatically when you log in',
          child: Switch(
            value: _launchAtLogin,
            onChanged: _toggleLaunchAtLogin,
            activeTrackColor: CandelaColors.accent,
          ),
        ),
        const _SettingsRow(
          label: 'Auto-start proxy',
          subtitle: 'Start the candela proxy when the app launches',
          child: Switch(
            value: true, // Currently always-on (hardcoded in app.dart)
            onChanged: null, // TODO: make configurable
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkSection() {
    final config = _config;
    return _SettingsSection(
      title: 'Network',
      icon: Icons.lan_outlined,
      children: [
        _SettingsRow(
          label: 'Proxy port',
          subtitle: 'Port for the local Candela proxy',
          child: _PortEditor(
            value: config?.port ?? 8181,
            onSave: (p) => _setPort('port', p),
          ),
        ),
        _SettingsRow(
          label: 'LM Studio port',
          subtitle: 'Port for LM Studio OpenAI-compatible API',
          child: _PortEditor(
            value: config?.lmStudioPort ?? 1234,
            onSave: (p) => _setPort('lmstudio_port', p),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceSection() {
    final config = _config;
    final cachingMode = config?.vertexAI?.cachingMode ?? 'off';
    return _SettingsSection(
      title: 'Performance',
      icon: Icons.speed_outlined,
      children: [
        _SettingsRow(
          label: 'Anthropic prompt caching',
          subtitle: 'Inject cache_control breakpoints to reduce costs',
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'off', label: Text('Off')),
              ButtonSegment(value: 'auto', label: Text('Auto')),
              ButtonSegment(value: 'system-only', label: Text('System')),
            ],
            selected: {cachingMode},
            onSelectionChanged: (selected) {
              if (selected.isNotEmpty) _setCachingMode(selected.first);
            },
            style: SegmentedButton.styleFrom(
              backgroundColor: CandelaColors.bgTertiary,
              foregroundColor: CandelaColors.textPrimary,
              selectedBackgroundColor: CandelaColors.accent,
              selectedForegroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _setCachingMode(String mode) async {
    await ref.read(configServiceProvider).setCachingMode(mode);
    await _loadAll();
  }

  Widget _buildOptimizationSection() {
    final config = _config;
    final semanticEnabled = config?.optimizations?.semanticCache ?? false;
    final compressionEnabled =
        config?.optimizations?.contextCompression ?? false;

    return _SettingsSection(
      title: 'Token Optimization',
      icon: Icons.compress_outlined,
      children: [
        _SettingsRow(
          label: 'Semantic caching',
          subtitle: 'Cache responses for semantically similar prompts',
          child: Switch(
            value: semanticEnabled,
            onChanged: _toggleSemanticCaching,
            activeTrackColor: CandelaColors.accent,
          ),
        ),
        _SettingsRow(
          label: 'Context compression',
          subtitle: 'Strip redundant tokens before dispatch (LLMLingua)',
          child: Switch(
            value: compressionEnabled,
            onChanged: _toggleContextCompression,
            activeTrackColor: CandelaColors.accent,
          ),
        ),
      ],
    );
  }

  Future<void> _toggleSemanticCaching(bool value) async {
    await ref
        .read(configServiceProvider)
        .setOptimizations(semanticCache: value);
    await _loadAll();
  }

  Future<void> _toggleContextCompression(bool value) async {
    await ref
        .read(configServiceProvider)
        .setOptimizations(contextCompression: value);
    await _loadAll();
  }

  Widget _buildModeSection() {
    final config = _config;
    final isTeam = config?.mode == CandelaMode.team;
    return _SettingsSection(
      title: 'Mode',
      icon: Icons.groups_outlined,
      children: [
        _SettingsRow(
          label: 'Operating mode',
          subtitle: isTeam
              ? 'Connected to ${config?.remote ?? "team backend"}'
              : 'Running in solo mode (local only)',
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                  value: false,
                  label: Text('Solo', style: TextStyle(fontSize: 12))),
              ButtonSegment(
                  value: true,
                  label: Text('Team', style: TextStyle(fontSize: 12))),
            ],
            selected: {isTeam},
            onSelectionChanged: (s) {
              if (s.first) {
                _showTeamUrlDialog();
              } else {
                _setMode();
              }
            },
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _SettingsSection(
      title: 'About',
      icon: Icons.info_outline,
      children: [
        _SettingsRow(
          label: 'Version',
          subtitle: _version,
          child: const SizedBox.shrink(),
        ),
        _SettingsRow(
          label: 'Config path',
          subtitle: _config?.path ?? ConfigService.defaultConfigPath(),
          child: const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _showTeamUrlDialog() {
    final controller = TextEditingController(text: _config?.remote ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CandelaColors.bgSecondary,
        title: const Text('Team Backend URL'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'https://candela.example.com',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _setMode(remote: controller.text, audience: controller.text);
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }
}

// ── Reusable settings widgets ────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CandelaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Icon(icon, size: 16, color: CandelaColors.accent),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: CandelaColors.textPrimary)),
              ],
            ),
          ),
          const Divider(height: 1, color: CandelaColors.borderSubtle),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final Widget child;

  const _SettingsRow({
    required this.label,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13, color: CandelaColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: CandelaColors.textMuted)),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _PortEditor extends StatefulWidget {
  final int value;
  final ValueChanged<int> onSave;

  const _PortEditor({required this.value, required this.onSave});

  @override
  State<_PortEditor> createState() => _PortEditorState();
}

class _PortEditorState extends State<_PortEditor> {
  late TextEditingController _ctrl;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: '${widget.value}');
  }

  @override
  void didUpdateWidget(_PortEditor old) {
    super.didUpdateWidget(old);
    if (!_editing) _ctrl.text = '${widget.value}';
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 34,
      child: TextField(
        controller: _ctrl,
        onTap: () => setState(() => _editing = true),
        onSubmitted: (v) {
          final port = int.tryParse(v);
          if (port != null && port > 0 && port <= 65535) {
            widget.onSave(port);
          }
          setState(() => _editing = false);
        },
        style: const TextStyle(
            fontSize: 13,
            fontFamily: 'monospace',
            color: CandelaColors.textPrimary),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          filled: true,
          fillColor: CandelaColors.bgTertiary,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: CandelaColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: CandelaColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: CandelaColors.accent),
          ),
        ),
      ),
    );
  }
}
