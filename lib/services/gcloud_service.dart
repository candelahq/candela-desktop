import 'dart:convert';
import 'dart:io';

import '../models/identity_state.dart';
import 'adc_service.dart';

/// Interacts with the gcloud CLI for operations that still require it,
/// and uses [AdcService] for direct token refresh when possible.
///
/// Token operations (getTokenInfo, getAccessToken) now prefer direct OAuth2
/// refresh via the ADC file, eliminating gcloud subprocess overhead for the
/// hot path. gcloud is only used as a fallback or for operations that have
/// no direct API equivalent (account listing, API checks).
class GCloudService {
  static const _timeout = Duration(seconds: 10);

  final AdcService _adcService = AdcService();

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

  /// Get an ADC access token and its real expiry.
  ///
  /// Prefers direct OAuth2 token refresh via the ADC file (fast, no gcloud
  /// subprocess). Falls back to `gcloud auth application-default
  /// print-access-token --format=json` if the ADC file doesn't have
  /// refresh credentials.
  Future<TokenInfo?> getTokenInfo() async {
    // Try direct refresh first (no gcloud subprocess needed).
    final directToken = await _adcService.refreshAccessToken();
    if (directToken != null) return directToken;

    // Fallback: gcloud subprocess.
    try {
      final result = await _run([
        'auth',
        'application-default',
        'print-access-token',
        '--format=json',
      ]);
      if (result.exitCode != 0) return null;

      final output = (result.stdout as String).trim();
      if (output.isEmpty) return null;

      return _parseGcloudTokenJson(output);
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
  /// Unlike [getTokenInfo], this deliberately does NOT use direct ADC refresh
  /// because the gcloud active account may differ from the ADC identity.
  /// Team backend auth must use the gcloud-authenticated identity to preserve
  /// correct `hasMismatchedIdentities` semantics.
  Future<TokenInfo?> getAccessToken() async {
    try {
      final result = await _run([
        'auth',
        'print-access-token',
        '--format=json',
      ]);
      if (result.exitCode != 0) return null;

      final output = (result.stdout as String).trim();
      if (output.isEmpty) return null;

      return _parseGcloudTokenJson(output);
    } catch (_) {
      return null;
    }
  }

  /// Parse gcloud's `--format=json` token output into a [TokenInfo].
  ///
  /// Shared by [getTokenInfo] and [getAccessToken] to avoid duplication.
  /// Checks both `token` and `access_token` keys for robustness.
  /// Falls back to plain-token JWT decoding on [FormatException].
  TokenInfo? _parseGcloudTokenJson(String output) {
    try {
      final parsed = json.decode(output) as Map<String, dynamic>;
      final token =
          parsed['token'] as String? ?? (parsed['access_token'] as String?);
      if (token == null || token.isEmpty) return null;

      DateTime? expiresAt;
      // gcloud --format=json returns expiry in several possible shapes:
      //   1. {"expiry": {"datetime": "2026-05-18 02:06:07.038436"}} (newer)
      //   2. {"token_expiry": "2026-05-18T02:06:07Z"} (older)
      //   3. {"expires_in": 3599} (OAuth2-style)
      final expiryMap = parsed['expiry'] as Map<String, dynamic>?;
      if (expiryMap != null) {
        final datetimeStr = expiryMap['datetime'] as String?;
        if (datetimeStr != null) {
          expiresAt = DateTime.tryParse('${datetimeStr}Z');
        }
      }
      if (expiresAt == null) {
        final tokenExpiry = parsed['token_expiry'] as String?;
        if (tokenExpiry != null) {
          expiresAt = DateTime.tryParse(tokenExpiry);
        }
      }
      if (expiresAt == null) {
        final expiresIn = parsed['expires_in'] as int?;
        if (expiresIn != null) {
          expiresAt = DateTime.now().toUtc().add(Duration(seconds: expiresIn));
        }
      }

      return _decodeJwt(token, knownExpiry: expiresAt);
    } on FormatException {
      // Not JSON — treat the entire output as a plain token string.
      return _decodeJwt(output);
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

  /// Decode a token, optionally using a [knownExpiry] from gcloud JSON output.
  ///
  /// When [knownExpiry] is provided (from `--format=json`), it is used as the
  /// authoritative expiry — avoiding the bogus 15-minute fallback that
  /// previously applied to opaque `ya29.*` tokens.
  TokenInfo _decodeJwt(String token, {DateTime? knownExpiry}) {
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
          );
        }
      } catch (_) {
        // Token is not a JWT (e.g., opaque token). Fall through.
      }
    }
    // Non-JWT token (opaque `ya29.*`). Use the real expiry from gcloud
    // --format=json if available; otherwise fall back to 60-minute estimate
    // (Google OAuth2 access tokens have a 3600-second lifetime).
    final expiresAt =
        knownExpiry ?? DateTime.now().toUtc().add(const Duration(minutes: 60));
    return TokenInfo(
      accessToken: token,
      expiresAt: expiresAt,
    );
  }

  /// Expose JWT decoding for testing.
  TokenInfo? getTokenInfoForTest(String token) => _decodeJwt(token);
}
