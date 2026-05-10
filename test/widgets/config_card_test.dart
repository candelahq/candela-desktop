import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:candela_desktop/theme/candela_theme.dart';
import 'package:candela_desktop/models/candela_config.dart';
import 'package:candela_desktop/screens/auth_debug/config_card.dart';
import 'package:candela_desktop/services/config_service.dart';

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
              configService: ConfigService(configPath: '/tmp/test-config.yaml'),
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

    testWidgets('tapping mode badge opens Switch Mode dialog',
        (WidgetTester tester) async {
      const config = CandelaConfig(path: '/test', mode: CandelaMode.solo);
      await tester.pumpWidget(buildApp(config));
      // The mode badge (InkWell containing mode label) is tappable.
      await tester.tap(find.text('Solo Mode'));
      await tester.pumpAndSettle();
      // Dialog should appear with Switch Mode title.
      expect(find.text('Switch Mode'), findsOneWidget);
      expect(find.text('Solo / Dev Mode'), findsOneWidget);
      expect(find.text('Team Mode'), findsOneWidget);
    });

    testWidgets('Switch Mode dialog shows Cancel button',
        (WidgetTester tester) async {
      const config = CandelaConfig(path: '/test', mode: CandelaMode.solo);
      await tester.pumpWidget(buildApp(config));
      await tester.tap(find.text('Solo Mode'));
      await tester.pumpAndSettle();
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Switch Mode dialog can be dismissed via Cancel',
        (WidgetTester tester) async {
      const config = CandelaConfig(path: '/test', mode: CandelaMode.solo);
      await tester.pumpWidget(buildApp(config));
      await tester.tap(find.text('Solo Mode'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      // Dialog dismissed — Solo Mode badge is back.
      expect(find.text('Switch Mode'), findsNothing);
      expect(find.text('Solo Mode'), findsOneWidget);
    });

    testWidgets('shows info issues', (WidgetTester tester) async {
      const config = CandelaConfig(
        path: '/test',
        issues: [
          ConfigIssue(severity: IssueSeverity.info, message: 'Info message'),
        ],
      );
      await tester.pumpWidget(buildApp(config));
      expect(find.text('Info message'), findsOneWidget);
    });

    testWidgets('shows edit icon for port chip when onPortChanged is set',
        (WidgetTester tester) async {
      const config =
          CandelaConfig(path: '/test', port: 8181, lmStudioPort: 1234);
      await tester.pumpWidget(buildApp(config, onPortChanged: (_, __) {}));
      expect(find.byIcon(Icons.edit), findsWidgets);
    });

    testWidgets('tapping port chip opens port editor dialog',
        (WidgetTester tester) async {
      const config = CandelaConfig(path: '/test', port: 8181);
      await tester.pumpWidget(buildApp(config, onPortChanged: (_, __) {}));
      await tester.tap(find.text('API :8181'));
      await tester.pumpAndSettle();
      expect(find.text('Edit API Port'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('port editor dialog can be dismissed',
        (WidgetTester tester) async {
      const config = CandelaConfig(path: '/test', port: 8181);
      await tester.pumpWidget(buildApp(config, onPortChanged: (_, __) {}));
      await tester.tap(find.text('API :8181'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Edit API Port'), findsNothing);
    });

    testWidgets('Team Mode dialog shows current remote URL',
        (WidgetTester tester) async {
      const config = CandelaConfig(
        path: '/test',
        mode: CandelaMode.team,
        remote: 'https://team.example.com',
      );
      await tester.pumpWidget(buildApp(config));
      await tester.tap(find.text('Team Mode'));
      await tester.pumpAndSettle();
      // Dialog shows both options
      expect(find.text('Switch Mode'), findsOneWidget);
      expect(find.textContaining('Current: https://team.example.com'),
          findsOneWidget);
    });
  });
}
