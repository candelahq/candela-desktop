import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'theme/candela_theme.dart';
import 'theme/colors.dart';
import 'services/update_service.dart';
import 'widgets/sidebar.dart';
import 'screens/auth_debug/auth_debug_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'main.dart' show trayService, configService;

class CandelaApp extends StatelessWidget {
  const CandelaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candela',
      debugShowCheckedModeBanner: false,
      theme: CandelaTheme.dark,
      home: const _AppRouter(),
    );
  }
}

/// Decides whether to show onboarding or the main app shell.
class _AppRouter extends StatefulWidget {
  const _AppRouter();

  @override
  State<_AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<_AppRouter> {
  bool _loading = true;
  bool _needsOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkConfig();
  }

  Future<void> _checkConfig() async {
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
        configService: configService,
        onComplete: _onOnboardingComplete,
      );
    }

    return const AppShell();
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WindowListener {
  int _selectedIndex = 0;
  bool _hasShownTrayTooltip = false;
  final _updateService = UpdateService();

  static final _pages = <Widget>[
    const AuthDebugScreen(),
    const DashboardScreen(),
    const _ComingSoon(title: 'Traces'),
    const _ComingSoon(title: 'Models'),
  ];

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    windowManager.setPreventClose(true);

    // Wire tray "Show Window" action.
    trayService.onShowWindow = _showWindow;
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
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
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  final String title;
  const _ComingSoon({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🕯️', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Coming soon', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
