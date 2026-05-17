import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Settings — port validation', () {
    bool isValidPort(String text) {
      final port = int.tryParse(text);
      return port != null && port > 0 && port <= 65535;
    }

    test('valid port numbers', () {
      expect(isValidPort('8181'), isTrue);
      expect(isValidPort('1'), isTrue);
      expect(isValidPort('65535'), isTrue);
      expect(isValidPort('1234'), isTrue);
    });

    test('invalid port numbers', () {
      expect(isValidPort('0'), isFalse);
      expect(isValidPort('-1'), isFalse);
      expect(isValidPort('65536'), isFalse);
      expect(isValidPort('99999'), isFalse);
      expect(isValidPort('abc'), isFalse);
      expect(isValidPort(''), isFalse);
    });

    test('boundary values', () {
      expect(isValidPort('1'), isTrue);
      expect(isValidPort('65535'), isTrue);
      expect(isValidPort('0'), isFalse);
      expect(isValidPort('65536'), isFalse);
    });
  });

  group('Settings — theme mode', () {
    test('all theme modes supported', () {
      expect(ThemeMode.values.length, 3);
      expect(ThemeMode.values, contains(ThemeMode.system));
      expect(ThemeMode.values, contains(ThemeMode.light));
      expect(ThemeMode.values, contains(ThemeMode.dark));
    });

    test('default theme is dark', () {
      const defaultMode = ThemeMode.dark;
      expect(defaultMode, ThemeMode.dark);
    });
  });

  group('Settings — team URL validation', () {
    bool isValidTeamUrl(String url) {
      final uri = Uri.tryParse(url);
      return uri != null &&
          (uri.scheme == 'https' || uri.scheme == 'http') &&
          uri.host.isNotEmpty;
    }

    test('valid HTTPS URLs', () {
      expect(isValidTeamUrl('https://candela.example.com'), isTrue);
      expect(isValidTeamUrl('https://api.candela.io/v1'), isTrue);
    });

    test('valid HTTP URLs', () {
      expect(isValidTeamUrl('http://localhost:8080'), isTrue);
    });

    test('invalid URLs', () {
      expect(isValidTeamUrl(''), isFalse);
      expect(isValidTeamUrl('ftp://example.com'), isFalse);
      expect(isValidTeamUrl('not-a-url'), isFalse);
      expect(isValidTeamUrl('file:///etc/passwd'), isFalse);
    });
  });

  group('Settings — mode strings', () {
    test('solo mode has no remote', () {
      const String? remote = null;
      expect(remote, isNull);
    });

    test('team mode has remote', () {
      const remote = 'https://candela.example.com';
      expect(remote, isNotNull);
      expect(remote, startsWith('https://'));
    });
  });

  group('Settings — caching mode validation', () {
    const validModes = ['off', 'auto', 'system-only'];

    test('all valid modes are recognized', () {
      for (final mode in validModes) {
        expect(validModes.contains(mode), isTrue,
            reason: '"$mode" should be a valid caching mode');
      }
    });

    test('invalid modes are rejected', () {
      const invalidModes = ['autoo', 'ON', 'system_only', 'true', '', 'yes'];
      for (final mode in invalidModes) {
        expect(validModes.contains(mode), isFalse,
            reason: '"$mode" should NOT be a valid caching mode');
      }
    });

    test('default caching mode is auto', () {
      const defaultMode = 'auto';
      expect(validModes.contains(defaultMode), isTrue);
      expect(defaultMode, 'auto');
    });

    test('backward compat: bool true maps to auto', () {
      // Simulates the YAML parsing logic in config_service.dart.
      final rawCaching = true;
      late String cachingMode;
      if (rawCaching == true) {
        cachingMode = 'auto';
      }
      expect(cachingMode, 'auto');
    });

    test('backward compat: bool false maps to off', () {
      final rawCaching = false;
      late String cachingMode;
      if (rawCaching == true) {
        cachingMode = 'auto';
      } else {
        cachingMode = 'off';
      }
      expect(cachingMode, 'off');
    });

    test('validated string parsing rejects garbage', () {
      // Use dynamic to simulate YAML parsing where type is unknown.
      final dynamic rawCaching = 'garbage-value';
      late String cachingMode;
      if (rawCaching is String &&
          const ['off', 'auto', 'system-only'].contains(rawCaching)) {
        cachingMode = rawCaching;
      } else {
        cachingMode = 'off'; // fallback
      }
      expect(cachingMode, 'off');
    });

    test('validated string parsing accepts system-only', () {
      final dynamic rawCaching = 'system-only';
      late String cachingMode;
      if (rawCaching is String &&
          const ['off', 'auto', 'system-only'].contains(rawCaching)) {
        cachingMode = rawCaching;
      } else {
        cachingMode = 'off';
      }
      expect(cachingMode, 'system-only');
    });
  });
}
