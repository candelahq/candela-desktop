import 'dart:convert';
import 'dart:io';

import '../models/identity_state.dart';

/// Interacts with the gcloud CLI to introspect auth and project state.
class GCloudService {
  static const _timeout = Duration(seconds: 10);

  /// Augmented PATH that includes common gcloud install locations.
  /// macOS GUI apps don't inherit shell PATH, so we search explicitly.
  /// Cached to avoid recreating on every call.
  late final Map<String, String> augmentedEnv = _buildAugmentedEnv();

  Map<String, String> _buildAugmentedEnv() {
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
    return Process.run('gcloud', args, environment: augmentedEnv)
        .timeout(_timeout);
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
        'auth',
        'list',
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
        'config',
        'get',
        'project',
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
        'auth',
        'application-default',
        'print-access-token',
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

  /// Get an ID token for authenticating to a Cloud Run / IAP backend.
  ///
  /// Uses `gcloud auth print-identity-token --audiences=<audience>` which
  /// produces a JWT ID token that Cloud Run's IAM invoker auth accepts.
  /// Falls back to [getAccessToken] if the ID token command fails.
  Future<TokenInfo?> getIdToken(String audience) async {
    try {
      final result = await _run([
        'auth',
        'print-identity-token',
        '--audiences=$audience',
      ]);
      if (result.exitCode != 0) {
        // Fall back to regular access token (works with userinfo validation).
        return getAccessToken();
      }

      final token = (result.stdout as String).trim();
      if (token.isEmpty) return getAccessToken();

      return _decodeJwt(token);
    } catch (_) {
      return getAccessToken();
    }
  }

  /// Get a regular gcloud access token (not ADC) for team backend auth.
  ///
  /// Uses `gcloud auth print-access-token` which produces an OAuth2 token
  /// that the backend validates via Google's userinfo endpoint. This is
  /// different from ADC tokens which may lack the required scopes.
  Future<TokenInfo?> getAccessToken() async {
    try {
      final result = await _run([
        'auth',
        'print-access-token',
      ]);
      if (result.exitCode != 0) return getTokenInfo();

      final token = (result.stdout as String).trim();
      if (token.isEmpty) return getTokenInfo();

      return _decodeJwt(token);
    } catch (_) {
      return getTokenInfo();
    }
  }

  /// Check if a GCP API is enabled for the given project.
  Future<bool> isApiEnabled(String project, String api) async {
    // CRITICAL-2: use _run() for augmented PATH + consistent timeout,
    // not a bare Process.run which silently fails when gcloud isn't on PATH.
    try {
      final result = await _run([
        'services',
        'list',
        '--project=$project',
        '--filter=config.name:$api',
        '--format=value(config.name)',
      ]);
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
        final payload = json.decode(utf8.decode(base64Url.decode(normalized)))
            as Map<String, dynamic>;
        final exp = payload['exp'] as int?;
        // CRITICAL-3: validate email before storing — cap length and ensure
        // it is a plain string (guards against crafted/poisoned token caches).
        final rawEmail = payload['email'];
        final email =
            rawEmail is String && rawEmail.length <= 254 ? rawEmail : null;

        if (exp != null) {
          final expiresAt =
              DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
          return TokenInfo(
            email: email,
            accessToken: token,
            expiresAt: expiresAt,
            isValid: expiresAt.isAfter(DateTime.now().toUtc()),
          );
        }
      } catch (_) {
        // Token is not a JWT (e.g., opaque token). Still valid.
      }
    }
    // Non-JWT token (opaque) — assume valid since gcloud returned it, but
    // use a conservative 15-minute TTL. We can't know the real expiry, so
    // a short TTL forces re-acquisition before it's likely to have expired.
    return TokenInfo(
      accessToken: token,
      expiresAt: DateTime.now().add(const Duration(minutes: 15)),
      isValid: true,
    );
  }

  /// Expose JWT decoding for testing.
  TokenInfo? getTokenInfoForTest(String token) => _decodeJwt(token);
}
