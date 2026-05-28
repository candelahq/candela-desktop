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
        _SettingsRow(
          label: 'Auto-start proxy',
          subtitle: 'Start the candela proxy when the app launches',
          child: Switch(
            value: _config?.autoStartProxy ?? true,
            onChanged: _toggleAutoStartProxy,
            activeTrackColor: CandelaColors.accent,
          ),
        ),
      ],
    );
  }

  Future<void> _toggleAutoStartProxy(bool value) async {
    await ref.read(configServiceProvider).setAutoStartProxy(value);
    if (!mounted) return;
    await _loadAll();
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
    final cacheTTL = config?.vertexAI?.cacheTTL ?? '5m';
    final is1h = cacheTTL == '1h';
    final cachingEnabled = cachingMode != 'off';
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
        if (cachingEnabled) ...[
          _SettingsRow(
            label: 'Cache duration (TTL)',
            subtitle: is1h
                ? '1 hour — 2× write cost, ideal for long sessions'
                : '5 minutes — standard cost (1.25× write)',
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: '5m', label: Text('5 min')),
                ButtonSegment(value: '1h', label: Text('1 hour')),
              ],
              selected: {cacheTTL},
              onSelectionChanged: (selected) {
                if (selected.isNotEmpty) _setCacheTTL(selected.first);
              },
              style: SegmentedButton.styleFrom(
                backgroundColor: CandelaColors.bgTertiary,
                foregroundColor: CandelaColors.textPrimary,
                selectedBackgroundColor:
                    is1h ? Colors.amber.shade700 : CandelaColors.accent,
                selectedForegroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          if (is1h) _CacheTTLWarningBanner(),
        ],
      ],
    );
  }

  Future<void> _setCachingMode(String mode) async {
    await ref.read(configServiceProvider).setCachingMode(mode);
    await _loadAll();
  }

  Future<void> _setCacheTTL(String ttl) async {
    if (ttl == '1h') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: CandelaColors.bgSecondary,
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 24),
              SizedBox(width: 8),
              Text('Enable 1-hour cache?',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
          content: const Text(
            'The 1-hour cache TTL costs 2× for cache writes '
            '(vs 1.25× for the default 5-minute TTL).\n\n'
            'Cache reads remain at 0.1× — so this pays off quickly during '
            'long coding sessions where the system prompt stays stable.\n\n'
            'Are you sure?',
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
              ),
              child: const Text('Enable 1h cache'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    await ref.read(configServiceProvider).setCacheTTL(ttl);
    // Lightweight reload — avoid full _loadAll() which shows a loading spinner.
    final config = await ref.read(configServiceProvider).load();
    if (mounted) setState(() => _config = config);
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

/// Pulsing amber warning banner shown when 1-hour cache TTL is active.
class _CacheTTLWarningBanner extends StatefulWidget {
  @override
  State<_CacheTTLWarningBanner> createState() => _CacheTTLWarningBannerState();
}

class _CacheTTLWarningBannerState extends State<_CacheTTLWarningBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.shade900.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.amber.shade700.withValues(alpha: 0.5),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '⚡ 1-hour TTL active — cache writes cost 2× '
                '(reads stay at 0.1×). Great for long sessions!',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.amber,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
