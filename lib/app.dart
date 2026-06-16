import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'theme/candela_theme.dart';
import 'theme/colors.dart';
import 'providers.dart';
import 'services/process_manager.dart';
import 'services/update_service.dart';
import 'widgets/sidebar.dart';
import 'screens/auth_debug/auth_debug_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/today/today_screen.dart';
import 'screens/traces/traces_screen.dart';
import 'screens/catalog/catalog_screen.dart';
import 'screens/models/models_screen.dart';
import 'screens/settings/settings_screen.dart';

class CandelaApp extends StatefulWidget {
  const CandelaApp({super.key});

  @override
  State<CandelaApp> createState() => _CandelaAppState();
}

class _CandelaAppState extends State<CandelaApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  static const _kThemeModeKey = 'theme_mode';

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemeModeKey);
    final mode = switch (saved) {
      'system' => ThemeMode.system,
      'light' => ThemeMode.light,
      _ => ThemeMode.dark,
    };
    if (mounted && mode != _themeMode) setState(() => _themeMode = mode);
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    final prefs = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
    };
    await prefs.setString(_kThemeModeKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candela',
      debugShowCheckedModeBanner: false,
      theme: CandelaTheme.light,
      darkTheme: CandelaTheme.dark,
      themeMode: _themeMode,
      home: _AppRouter(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
    );
  }
}

/// Decides whether to show onboarding or the main app shell.
class _AppRouter extends ConsumerStatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const _AppRouter({
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  ConsumerState<_AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends ConsumerState<_AppRouter> {
  bool _loading = true;
  bool _needsOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkConfig();
  }

  Future<void> _checkConfig() async {
    final configService = ref.read(configServiceProvider);
    final exists = await configService.configExists();
    if (mounted) {
      setState(() {
        _needsOnboarding = !exists;
        _loading = false;
      });
    }
  }

  void _onOnboardingComplete() {
    setState(() => _needsOnboarding = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: CandelaColors.accent),
        ),
      );
    }

    if (_needsOnboarding) {
      return OnboardingScreen(
        configService: ref.read(configServiceProvider),
        onComplete: _onOnboardingComplete,
      );
    }

    return AppShell(
      themeMode: widget.themeMode,
      onThemeModeChanged: widget.onThemeModeChanged,
    );
  }
}

class AppShell extends ConsumerStatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const AppShell({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with WindowListener, WidgetsBindingObserver {
  int _selectedIndex = 0;
  bool _hasShownTrayTooltip = false;
  final _updateService = UpdateService();
  bool _trayInitialized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    WidgetsBinding.instance.addObserver(this);

    _initServices();
  }

  Future<void> _initServices() async {
    // Initialize tray and wire show-window action.
    final tray = ref.read(trayServiceProvider);
    if (!_trayInitialized) {
      await tray.init();
      tray.onShowWindow = _showWindow;
      _trayInitialized = true;
    }

    // Detect already-running processes.
    final pm = ref.read(processManagerProvider);
    await pm.detectRunning();
    if (!mounted) return;

    // Auto-start proxy if installed but not already running.
    final configService = ref.read(configServiceProvider);
    final config = await configService.load();
    final proxy = pm.get('proxy');
    if (config.autoStartProxy &&
        proxy != null &&
        proxy.state == ProcessState.stopped &&
        await pm.isInstalled('proxy')) {
      pm.start('proxy');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  /// Forward app lifecycle changes to the shared DashboardNotifier so it can
  /// pause polling when backgrounded and resume with an immediate fetch.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(dashboardProvider.notifier).onAppLifecycleChanged(state);
  }

  /// Close button → minimize to tray instead of quitting.
  @override
  void onWindowClose() async {
    // Show a one-time tooltip explaining tray behavior.
    if (!_hasShownTrayTooltip && mounted) {
      _hasShownTrayTooltip = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '🕯️ Candela is still running in your menu bar. '
            'Right-click the tray icon to quit.',
          ),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          backgroundColor: CandelaColors.bgTertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      // Small delay so the snackbar is visible before hiding.
      await Future.delayed(const Duration(milliseconds: 500));
    }
    await windowManager.hide();
    // App keeps running in tray.
  }

  void _showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  List<Widget> get _pages => [
        const TodayScreen(),
        const AuthDebugScreen(),
        const DashboardScreen(),
        const TracesScreen(),
        const ModelsScreen(),
        const CatalogScreen(),
        SettingsScreen(
          currentThemeMode: widget.themeMode,
          onThemeModeChanged: widget.onThemeModeChanged,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CandelaSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (i) => setState(() => _selectedIndex = i),
            updateService: _updateService,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: KeyedSubtree(
                key: ValueKey(_selectedIndex),
                child: _pages[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
