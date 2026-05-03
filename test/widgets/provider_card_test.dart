import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:candela_desktop/theme/candela_theme.dart';
import 'package:candela_desktop/models/provider_status.dart';
import 'package:candela_desktop/screens/auth_debug/provider_card.dart';

void main() {
  group('ProviderCard', () {
    Widget buildApp(ProviderStatus status, {VoidCallback? onRemove}) {
      return MaterialApp(
        theme: CandelaTheme.dark,
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 300,
            child: ProviderCard(status: status, onRemove: onRemove),
          ),
        ),
      );
    }

    testWidgets('shows provider display name', (WidgetTester tester) async {
      const status = ProviderStatus(
        name: 'google',
        displayName: 'Google / Vertex AI',
        state: ProviderState.connected,
        icon: 'G',
      );
      await tester.pumpWidget(buildApp(status));
      expect(find.text('Google / Vertex AI'), findsOneWidget);
    });

    testWidgets('shows connected status', (WidgetTester tester) async {
      const status = ProviderStatus(
        name: 'google',
        displayName: 'Google',
        state: ProviderState.connected,
        statusMessage: 'Connected',
        icon: 'G',
      );
      await tester.pumpWidget(buildApp(status));
      expect(find.text('Connected'), findsOneWidget);
    });

    testWidgets('shows error status with detail', (WidgetTester tester) async {
      const status = ProviderStatus(
        name: 'anthropic',
        displayName: 'Anthropic',
        state: ProviderState.error,
        statusMessage: '403 — Model not enabled',
        errorDetail: 'Enable Claude in Vertex AI',
        icon: 'A',
      );
      await tester.pumpWidget(buildApp(status));
      expect(find.text('403 — Model not enabled'), findsOneWidget);
      expect(find.text('Enable Claude in Vertex AI'), findsOneWidget);
    });

    testWidgets('shows loading spinner', (WidgetTester tester) async {
      const status = ProviderStatus(
        name: 'proxy',
        displayName: 'Proxy',
        state: ProviderState.loading,
        icon: '🕯',
      );
      await tester.pumpWidget(buildApp(status));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows project and region', (WidgetTester tester) async {
      const status = ProviderStatus(
        name: 'google',
        displayName: 'Google',
        state: ProviderState.connected,
        icon: 'G',
        project: 'my-project',
        region: 'us-central1',
      );
      await tester.pumpWidget(buildApp(status));
      expect(find.text('Project: my-project'), findsOneWidget);
      expect(find.text('Region: us-central1'), findsOneWidget);
    });

    testWidgets('shows models count', (WidgetTester tester) async {
      const status = ProviderStatus(
        name: 'proxy',
        displayName: 'Proxy',
        state: ProviderState.connected,
        icon: '🕯',
        models: [
          'gemini-2.0-flash',
          'claude-sonnet-4',
          'llama3',
          'gpt-4o',
          'mistral'
        ],
      );
      await tester.pumpWidget(buildApp(status));
      // Should show first 3 models + "+2".
      expect(find.textContaining('+2'), findsOneWidget);
    });

    testWidgets('shows icon', (WidgetTester tester) async {
      const status = ProviderStatus(
        name: 'google',
        displayName: 'Google',
        state: ProviderState.connected,
        icon: 'G',
      );
      await tester.pumpWidget(buildApp(status));
      expect(find.text('G'), findsAtLeast(1));
    });

    testWidgets('shows remove button when onRemove provided',
        (WidgetTester tester) async {
      const status = ProviderStatus(
        name: 'anthropic',
        displayName: 'Anthropic',
        state: ProviderState.connected,
        icon: 'A',
      );
      await tester.pumpWidget(buildApp(status, onRemove: () {}));
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('hides remove button when onRemove is null',
        (WidgetTester tester) async {
      const status = ProviderStatus(
        name: 'proxy',
        displayName: 'Proxy',
        state: ProviderState.connected,
        icon: '🕯',
      );
      await tester.pumpWidget(buildApp(status));
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('shows fix command for copy', (WidgetTester tester) async {
      const status = ProviderStatus(
        name: 'openai',
        displayName: 'OpenAI',
        state: ProviderState.notConfigured,
        fixCommand: 'export OPENAI_API_KEY=...',
        icon: 'O',
      );
      await tester.pumpWidget(buildApp(status));
      expect(find.text('export OPENAI_API_KEY=...'), findsOneWidget);
    });
  });
}
