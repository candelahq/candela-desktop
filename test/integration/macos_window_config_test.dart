import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';

/// Regression tests for macOS window behaviour.
///
/// These tests parse the native macOS runner files directly to ensure:
///   1. ⌘W is wired to minimize (performMiniaturize:) in MainMenu.xib.
///   2. The app does NOT quit when the last window is closed.
///
/// This guards against accidental reverts of the "dashboard app" UX where
/// closing the window should keep the process alive in the dock.
void main() {
  late XmlDocument xib;
  late String appDelegateSource;

  setUpAll(() {
    // Resolve paths relative to the project root (test runner CWD).
    final xibFile = File('macos/Runner/Base.lproj/MainMenu.xib');
    expect(xibFile.existsSync(), isTrue,
        reason: 'MainMenu.xib must exist at ${xibFile.path}');
    xib = XmlDocument.parse(xibFile.readAsStringSync());

    final appDelegateFile = File('macos/Runner/AppDelegate.swift');
    expect(appDelegateFile.existsSync(), isTrue,
        reason: 'AppDelegate.swift must exist at ${appDelegateFile.path}');
    appDelegateSource = appDelegateFile.readAsStringSync();
  });

  group('MainMenu.xib — Window menu', () {
    late List<XmlElement> windowMenuItems;

    setUp(() {
      // Find the Window submenu: <menu ... title="Window" systemMenu="window">
      final windowMenu = xib
          .findAllElements('menu')
          .where((e) =>
              e.getAttribute('title') == 'Window' &&
              e.getAttribute('systemMenu') == 'window')
          .firstOrNull;
      expect(windowMenu, isNotNull, reason: 'Window submenu must exist');
      windowMenuItems = windowMenu!.findAllElements('menuItem').toList();
    });

    test('has a Close menu item with ⌘W shortcut', () {
      final closeItem = windowMenuItems
          .where((e) =>
              e.getAttribute('title') == 'Close' &&
              e.getAttribute('keyEquivalent') == 'w')
          .firstOrNull;
      expect(closeItem, isNotNull,
          reason:
              'Window menu must contain a Close item with keyEquivalent="w"');
    });

    test('⌘W is wired to performMiniaturize:', () {
      final closeItem = windowMenuItems
          .where((e) => e.getAttribute('title') == 'Close')
          .first;
      final action = closeItem
          .findAllElements('action')
          .where((e) => e.getAttribute('selector') == 'performMiniaturize:')
          .firstOrNull;
      expect(action, isNotNull,
          reason:
              '⌘W (Close) must trigger performMiniaturize: to minimize to dock');
    });

    test('⌘M Minimize item is still present', () {
      final minimizeItem = windowMenuItems
          .where((e) =>
              e.getAttribute('title') == 'Minimize' &&
              e.getAttribute('keyEquivalent') == 'm')
          .firstOrNull;
      expect(minimizeItem, isNotNull,
          reason: 'Minimize (⌘M) must remain in the Window menu');
    });

    test('⌘Q Quit shortcut is still present in app menu', () {
      final quitItem = xib
          .findAllElements('menuItem')
          .where((e) =>
              e.getAttribute('keyEquivalent') == 'q' &&
              (e.getAttribute('title') ?? '').contains('Quit'))
          .firstOrNull;
      expect(quitItem, isNotNull,
          reason: '⌘Q must remain as the way to fully quit the app');
    });
  });

  group('AppDelegate.swift — window lifecycle', () {
    test('applicationShouldTerminateAfterLastWindowClosed returns false', () {
      // The method must return false so that closing the window doesn't
      // terminate the app — standard for dashboard / utility apps.
      expect(
        appDelegateSource,
        contains('return false'),
        reason:
            'applicationShouldTerminateAfterLastWindowClosed must return false '
            'so the app stays alive when the window is closed',
      );

      // Negative check — ensure "return true" is NOT in that method.
      // We match the specific method signature to avoid false positives from
      // applicationSupportsSecureRestorableState (which does return true).
      final methodPattern = RegExp(
        r'applicationShouldTerminateAfterLastWindowClosed.*?\{(.*?)\}',
        dotAll: true,
      );
      final match = methodPattern.firstMatch(appDelegateSource);
      expect(match, isNotNull,
          reason:
              'Could not find applicationShouldTerminateAfterLastWindowClosed method');
      expect(match!.group(1), isNot(contains('return true')),
          reason:
              'applicationShouldTerminateAfterLastWindowClosed must NOT return true');
    });
  });

  group('MainMenu.xib — window style mask', () {
    test('window is closable, miniaturizable, and resizable', () {
      // The window element should have the style mask that allows closing.
      final windowStyleMask =
          xib.findAllElements('windowStyleMask').firstOrNull;
      expect(windowStyleMask, isNotNull,
          reason: 'windowStyleMask element must exist');
      expect(windowStyleMask!.getAttribute('closable'), equals('YES'));
      expect(windowStyleMask.getAttribute('miniaturizable'), equals('YES'));
      expect(windowStyleMask.getAttribute('resizable'), equals('YES'));
    });
  });
}
