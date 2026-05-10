import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../services/config_service.dart';
import '../../services/url_validator.dart';

/// First-run onboarding wizard.
///
/// Shown when no config file exists. Guides the user through mode selection
/// and initial provider setup, then writes ~/.config/candela/config.yaml.
class OnboardingScreen extends StatefulWidget {
  final ConfigService configService;
  final VoidCallback onComplete;

  const OnboardingScreen({
    super.key,
    required this.configService,
    required this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0; // 0 = mode, 1 = details, 2 = providers
  String _selectedMode = ''; // 'solo', 'soloCloud', 'team'

  // Solo+Cloud fields
  final _projectController = TextEditingController();
  final _regionController = TextEditingController(text: 'us-central1');

  // Team fields
  final _remoteController = TextEditingController();
  final _audienceController = TextEditingController();

  // Provider selection
  final Set<String> _selectedProviders = {};

  bool _saving = false;

  @override
  void dispose() {
    _projectController.dispose();
    _regionController.dispose();
    _remoteController.dispose();
    _audienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CandelaColors.bgPrimary,
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _step == 0
              ? _buildModeStep()
              : _step == 1
                  ? _buildDetailsStep()
                  : _buildProviderStep(),
        ),
      ),
    );
  }

  // ── Step 0: Mode Selection ──

  Widget _buildModeStep() {
    return Container(
      key: const ValueKey('mode'),
      constraints: const BoxConstraints(maxWidth: 520),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [CandelaColors.accent, Color(0xFFFF8C00)],
              ),
            ),
            child: const Center(
              child: Text('🕯', style: TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [CandelaColors.accent, Color(0xFFFF8C00)],
            ).createShader(bounds),
            child: const Text(
              'Welcome to Candela',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'How will you use Candela?',
            style: TextStyle(
                fontSize: 15, color: CandelaColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 32),
          _ModeCard(
            icon: '🏠',
            title: 'Solo',
            subtitle: 'Local observability — no cloud, no auth',
            isSelected: _selectedMode == 'solo',
            onTap: () => _selectMode('solo'),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: '☁️',
            title: 'Solo + Cloud',
            subtitle: 'Your own GCP project (Vertex AI)',
            isSelected: _selectedMode == 'soloCloud',
            onTap: () => _selectMode('soloCloud'),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: '👥',
            title: 'Team',
            subtitle: 'Shared Candela server (requires auth)',
            isSelected: _selectedMode == 'team',
            onTap: () => _selectMode('team'),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: _skipToDefaults,
            child: const Text(
              'Skip — use defaults',
              style: TextStyle(color: CandelaColors.textMuted, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  void _selectMode(String mode) {
    setState(() => _selectedMode = mode);
    if (mode == 'solo') {
      // Solo skips details, goes to provider selection.
      setState(() => _step = 2);
    } else {
      setState(() => _step = 1);
    }
  }

  // ── Step 1: Mode-Specific Details ──

  Widget _buildDetailsStep() {
    return Container(
      key: const ValueKey('details'),
      constraints: const BoxConstraints(maxWidth: 480),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _selectedMode == 'team' ? '👥 Team Setup' : '☁️ Cloud Setup',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          if (_selectedMode == 'team') ...[
            _buildTextField(
              controller: _remoteController,
              label: 'Remote URL',
              hint: 'https://candela.example.com',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _audienceController,
              label: 'Audience (optional — defaults to remote URL)',
              hint: 'https://candela.example.com',
            ),
          ] else ...[
            _buildTextField(
              controller: _projectController,
              label: 'GCP Project',
              hint: 'my-gcp-project',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _regionController,
              label: 'Region',
              hint: 'us-central1',
            ),
          ],
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => setState(() => _step = 0),
                child: const Text('← Back'),
              ),
              FilledButton(
                onPressed: _canProceedFromDetails() ? _goToProviders : null,
                style: FilledButton.styleFrom(
                  backgroundColor: CandelaColors.accent,
                ),
                child: const Text('Next →'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _canProceedFromDetails() {
    if (_selectedMode == 'team') {
      final url = _remoteController.text.trim();
      return url.isNotEmpty && UrlValidator.validate(url) == null;
    }
    return _projectController.text.trim().isNotEmpty;
  }

  void _goToProviders() => setState(() => _step = 2);

  // ── Step 2: Provider Selection ──

  Widget _buildProviderStep() {
    final providers = _selectedMode == 'solo'
        ? _localProviders
        : [..._cloudProviders, ..._localProviders];

    return Container(
      key: const ValueKey('providers'),
      constraints: const BoxConstraints(maxWidth: 520),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Providers',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select the LLM providers you want to use',
            style: TextStyle(fontSize: 14, color: CandelaColors.textSecondary),
          ),
          const SizedBox(height: 24),
          for (final p in providers) ...[
            _ProviderTile(
              icon: p.icon,
              name: p.displayName,
              subtitle: p.subtitle,
              isLocal: p.isLocal,
              isSelected: _selectedProviders.contains(p.id),
              onTap: () {
                setState(() {
                  if (_selectedProviders.contains(p.id)) {
                    _selectedProviders.remove(p.id);
                  } else {
                    _selectedProviders.add(p.id);
                  }
                });
              },
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () =>
                    setState(() => _step = _selectedMode == 'solo' ? 0 : 1),
                child: const Text('← Back'),
              ),
              FilledButton(
                onPressed: _saving ? null : _saveAndFinish,
                style: FilledButton.styleFrom(
                  backgroundColor: CandelaColors.accent,
                ),
                child: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Get Started →'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Actions ──

  Future<void> _skipToDefaults() async {
    setState(() => _saving = true);
    try {
      // Write a minimal default config via writeInitialConfig (not setPort)
      // so the file is created atomically and future onboarding attempts
      // don't fail with "config already exists".
      await widget.configService.writeInitialConfig({'port': 8181});
      widget.onComplete();
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save config: $e')),
        );
      }
    }
  }

  Future<void> _saveAndFinish() async {
    setState(() => _saving = true);
    try {
      // Build complete config in memory, then write once.
      final config = <String, dynamic>{};

      // Mode.
      if (_selectedMode == 'team') {
        config['remote'] = _remoteController.text.trim();
        final audience = _audienceController.text.trim();
        config['audience'] =
            audience.isNotEmpty ? audience : _remoteController.text.trim();
      }

      // Port.
      final port = await ConfigService.findAvailablePort();
      config['port'] = port;

      // Providers.
      if (_selectedProviders.isNotEmpty) {
        config['providers'] =
            _selectedProviders.map((name) => {'name': name}).toList();
      }

      // Single atomic write.
      await widget.configService.writeInitialConfig(config);

      widget.onComplete();
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save config: $e')),
        );
      }
    }
  }

  // ── Helpers ──

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: CandelaColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: CandelaColors.textMuted),
            filled: true,
            fillColor: CandelaColors.bgTertiary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: CandelaColors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: CandelaColors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: CandelaColors.accent),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  static const _cloudProviders = [
    _ProviderInfo(
        id: 'google',
        icon: 'G',
        displayName: 'Google / Gemini',
        subtitle: 'Vertex AI — Gemini models',
        isLocal: false),
    _ProviderInfo(
        id: 'anthropic',
        icon: 'A',
        displayName: 'Anthropic / Claude',
        subtitle: 'Vertex AI — Claude models',
        isLocal: false),
    _ProviderInfo(
        id: 'openai',
        icon: 'O',
        displayName: 'OpenAI',
        subtitle: 'Direct API — requires API key',
        isLocal: false),
  ];

  static const _localProviders = [
    _ProviderInfo(
        id: 'ollama',
        icon: '🦙',
        displayName: 'Ollama',
        subtitle: 'Local runtime — llama, mistral, etc.',
        isLocal: true),
    _ProviderInfo(
        id: 'vllm',
        icon: 'V',
        displayName: 'vLLM',
        subtitle: 'High-performance local/remote serving',
        isLocal: true),
    _ProviderInfo(
        id: 'lmstudio',
        icon: 'L',
        displayName: 'LM Studio',
        subtitle: 'Desktop app — OpenAI-compatible API',
        isLocal: true),
  ];
}

// ── Private Widgets ──

class _ModeCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? CandelaColors.accentDim : CandelaColors.bgSecondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        hoverColor: CandelaColors.bgHover,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? CandelaColors.accent
                  : CandelaColors.borderSubtle,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 13, color: CandelaColors.textSecondary)),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle,
                    color: CandelaColors.accent, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  final String icon;
  final String name;
  final String subtitle;
  final bool isLocal;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProviderTile({
    required this.icon,
    required this.name,
    required this.subtitle,
    required this.isLocal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? CandelaColors.accentDim : CandelaColors.bgSecondary,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        hoverColor: CandelaColors.bgHover,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? CandelaColors.accent
                  : CandelaColors.borderSubtle,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: isLocal
                    ? CandelaColors.bgTertiary
                    : CandelaColors.accentDim,
                child: Text(icon,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        if (isLocal) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: CandelaColors.bgTertiary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('LOCAL',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: CandelaColors.textMuted)),
                          ),
                        ],
                      ],
                    ),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12, color: CandelaColors.textSecondary)),
                  ],
                ),
              ),
              Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
                activeColor: CandelaColors.accent,
                side: const BorderSide(color: CandelaColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProviderInfo {
  final String id;
  final String icon;
  final String displayName;
  final String subtitle;
  final bool isLocal;

  const _ProviderInfo({
    required this.id,
    required this.icon,
    required this.displayName,
    required this.subtitle,
    required this.isLocal,
  });
}
