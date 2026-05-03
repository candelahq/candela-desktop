import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:candela_desktop/theme/candela_theme.dart';
import 'package:candela_desktop/models/candela_config.dart';
import 'package:candela_desktop/screens/auth_debug/config_card.dart';

void main() {
  group('ConfigCard', () {
    Widget buildApp(CandelaConfig config,
        {VoidCallback? onSwitchToSolo,
        ValueChanged<String>? onSwitchToTeam,
        void Function(String, int)? onPortChanged}) {
      return MaterialApp(
        theme: CandelaTheme.dark,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ConfigCard(
              config: config,
              onSwitchToSolo: onSwitchToSolo,
              onSwitchToTeam: onSwitchToTeam,
              onPortChanged: onPortChanged,
            ),
          ),
        ),
      );
    }

    testWidgets('shows config path', (WidgetTester tester) async {
      const config = CandelaConfig(path: '/Users/test/.candela.yaml');
      await tester.pumpWidget(buildApp(config));
      expect(find.text('/Users/test/.candela.yaml'), findsOneWidget);
    });

    testWidgets('shows Solo Mode badge', (WidgetTester tester) async {
      const config = CandelaConfig(path: '/test', mode: CandelaMode.solo);
      await tester.pumpWidget(buildApp(config));
      expect(find.text('Solo Mode'), findsOneWidget);
    });

    testWidgets('shows Solo + Cloud badge', (WidgetTester tester) async {
      const config = CandelaConfig(
        path: '/test',
        mode: CandelaMode.soloCloud,
        providers: [ProviderConfig(name: 'google')],
      );
      await tester.pumpWidget(buildApp(config));
      expect(find.text('Solo + Cloud'), findsOneWidget);
    });

    testWidgets('shows Team Mode badge with remote URL',
        (WidgetTester tester) async {
      const config = CandelaConfig(
        path: '/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
        audience: 'aud',
      );
      await tester.pumpWidget(buildApp(config));
      expect(find.text('Team Mode'), findsOneWidget);
      expect(find.text('https://candela.example.com'), findsOneWidget);
    });

    testWidgets('shows port chips', (WidgetTester tester) async {
      const config =
          CandelaConfig(path: '/test', port: 8181, lmStudioPort: 1234);
      await tester.pumpWidget(buildApp(config, onPortChanged: (_, __) {}));
      expect(find.text('API :8181'), findsOneWidget);
      expect(find.text('IDE :1234'), findsOneWidget);
    });

    testWidgets('shows error issues', (WidgetTester tester) async {
      const config = CandelaConfig(
        path: '/test',
        issues: [
          ConfigIssue(
              severity: IssueSeverity.error, message: 'Missing project'),
        ],
      );
      await tester.pumpWidget(buildApp(config));
      expect(find.text('Missing project'), findsOneWidget);
    });

    testWidgets('shows warning issues', (WidgetTester tester) async {
      const config = CandelaConfig(
        path: '/test',
        issues: [
          ConfigIssue(
              severity: IssueSeverity.warning, message: 'Region not set'),
        ],
      );
      await tester.pumpWidget(buildApp(config));
      expect(find.text('Region not set'), findsOneWidget);
    });

    testWidgets('shows providers list in solo+cloud mode',
        (WidgetTester tester) async {
      const config = CandelaConfig(
        path: '/test',
        mode: CandelaMode.soloCloud,
        providers: [
          ProviderConfig(name: 'google'),
          ProviderConfig(name: 'anthropic'),
        ],
      );
      await tester.pumpWidget(buildApp(config));
      expect(find.text('Providers: google, anthropic'), findsOneWidget);
    });

    testWidgets('shows last modified time', (WidgetTester tester) async {
      final config = CandelaConfig(
        path: '/test',
        lastModified: DateTime(2026, 5, 2, 14, 30),
      );
      await tester.pumpWidget(buildApp(config));
      expect(find.text('5/2 14:30'), findsOneWidget);
    });
  });
}
