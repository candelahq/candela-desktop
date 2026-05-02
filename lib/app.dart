import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'theme/candela_theme.dart';
import 'widgets/sidebar.dart';
import 'screens/auth_debug/auth_debug_screen.dart';
import 'main.dart' show trayService;

class CandelaApp extends StatelessWidget {
  const CandelaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candela',
      debugShowCheckedModeBanner: false,
      theme: CandelaTheme.dark,
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WindowListener {
  int _selectedIndex = 0;

  static const _pages = <Widget>[
    AuthDebugScreen(),
    _ComingSoon(title: 'Dashboard'),
    _ComingSoon(title: 'Traces'),
    _ComingSoon(title: 'Models'),
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
