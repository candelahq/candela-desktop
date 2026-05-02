import 'dart:convert';
import 'dart:io';

import '../models/identity_state.dart';

/// Interacts with the gcloud CLI to introspect auth and project state.
class GCloudService {
  static const _timeout = Duration(seconds: 10);

  /// Augmented PATH that includes common gcloud install locations.
  /// macOS GUI apps don't inherit shell PATH, so we search explicitly.
  Map<String, String> get augmentedEnv {
    final env = Map<String, String>.from(Platform.environment);
    final home = env['HOME'] ?? '/Users/${env['USER'] ?? 'unknown'}';
    final extraPaths = [
      '$home/google-cloud-sdk/bin',
      '/usr/local/google-cloud-sdk/bin',
      '/opt/homebrew/bin',
      '/usr/local/bin',
      '/opt/homebrew/share/google-cloud-sdk/bin',
      '$home/.local/bin',
    ];
    final currentPath = env['PATH'] ?? '';
    env['PATH'] = '${extraPaths.join(':')}:$currentPath';
    return env;
  }

  /// Run gcloud with augmented PATH.
  Future<ProcessResult> _run(List<String> args) {
    return Process.run('gcloud', args, environment: augmentedEnv).timeout(_timeout);
  }

  /// Check if gcloud CLI is installed and accessible.
  Future<bool> isInstalled() async {
    try {
      final result = await _run(['--version']);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// Get the active gcloud account email.
  Future<String?> getActiveAccount() async {
    try {
      final result = await _run([
        'auth', 'list',
        '--filter=status:ACTIVE',
        '--format=value(account)',
      ]);
      if (result.exitCode != 0) return null;
      final output = (result.stdout as String).trim();
      return output.isEmpty ? null : output.split('\n').first;
    } catch (_) {
      return null;
    }
  }

  /// Get the current GCP project from gcloud config.
  Future<String?> getProject() async {
    try {
      final result = await _run([
        'config', 'get', 'project',
      ]);
      if (result.exitCode != 0) return null;
      final output = (result.stdout as String).trim();
      return output.isEmpty ? null : output;
    } catch (_) {
      return null;
    }
  }

  /// Get an ADC access token and decode its JWT expiry.
  Future<TokenInfo?> getTokenInfo() async {
    try {
      final result = await _run([
        'auth', 'application-default', 'print-access-token',
      ]);
      if (result.exitCode != 0) return null;

      final token = (result.stdout as String).trim();
      if (token.isEmpty) return null;

      // Attempt JWT decode (works for user credentials, not always for SA).
      return _decodeJwt(token);
    } catch (_) {
      return null;
    }
  }

  /// Check if a GCP API is enabled for the given project.
  Future<bool> isApiEnabled(String project, String api) async {
    try {
      final result = await Process.run('gcloud', [
        'services', 'list',
        '--project=$project',
        '--filter=config.name:$api',
        '--format=value(config.name)',
      ], environment: augmentedEnv).timeout(const Duration(seconds: 15));
      return (result.stdout as String).trim().contains(api);
    } catch (_) {
      return false;
    }
  }

  TokenInfo _decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length >= 2) {
      try {
        final normalized = base64Url.normalize(parts[1]);
        final payload =
            json.decode(utf8.decode(base64Url.decode(normalized)))
                as Map<String, dynamic>;
        final exp = payload['exp'] as int?;
        final email = payload['email'] as String?;

        if (exp != null) {
          final expiresAt =
              DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
          return TokenInfo(
            email: email,
            expiresAt: expiresAt,
            isValid: expiresAt.isAfter(DateTime.now().toUtc()),
          );
        }
      } catch (_) {
        // Token is not a JWT (e.g., opaque token). Still valid.
      }
    }
    // Non-JWT token — assume valid since gcloud returned it.
    return TokenInfo(
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      isValid: true,
    );
  }
  /// Expose JWT decoding for testing.
  TokenInfo? getTokenInfoForTest(String token) => _decodeJwt(token);
}
