import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/identity_state.dart';
import 'adc_service.dart';

/// Unified auth service that replaces [GCloudService] for authentication.
///
/// All auth operations are performed via:
/// 1. Direct ADC file reading ([AdcService])
/// 2. Direct OAuth2 token refresh (no subprocess needed)
/// 3. JWT decoding for identity extraction
///
/// No `gcloud` subprocess is ever spawned. The optional `candela` CLI is
/// only used for interactive login flows (browser-based OAuth2 grant), not
/// for status queries.
class CandelaAuthService {
  final AdcService _adcService;

  /// Cached token from the most recent refresh — avoids redundant network
  /// round-trips when multiple callers request a token in quick succession
  /// (e.g., [isApiEnabled] followed by [getAccessToken]).
  TokenInfo? _cachedToken;

  CandelaAuthService({AdcService? adcService})
      : _adcService = adcService ?? AdcService();

  // ── Status ──────────────────────────────────────────────────────────────

  /// Get full auth status by reading ADC and refreshing the token directly.
  ///
  /// Returns email, project, ADC info, and a valid [TokenInfo] — all without
  /// spawning any subprocesses.
  Future<AuthStatus> getStatus() async {
    final adc = await _adcService.readAdcFile();
    final token = await _adcService.refreshAccessToken(adcInfo: adc);
    _cachedToken = token;

    // Email: prefer the token's email (from ID token JWT), fall back to
    // service account client_email in the ADC file.
    final email = token?.email ?? adc?.clientEmail;

    // Project: use ADC quota_project_id if present.
    final project = adc?.quotaProject;

    return AuthStatus(
      email: email,
      project: project,
      adcInfo: adc,
      tokenInfo: token,
    );
  }

  // ── Token Access ────────────────────────────────────────────────────────

  /// Get a fresh access token for API calls (e.g., Vertex AI, Service Usage).
  ///
  /// Returns a cached token if it is still valid (not near expiry).
  /// Uses direct OAuth2 refresh — no subprocess needed.
  Future<String?> getAccessToken() async {
    final info = await getTokenInfo();
    return info?.accessToken;
  }

  /// Get a [TokenInfo] with email and expiry metadata.
  ///
  /// Returns a cached token if it is still valid (> 5 min remaining) and
  /// [forceRefresh] is false. Pass `forceRefresh: true` to bypass the cache
  /// (e.g., during explicit reconfiguration).
  Future<TokenInfo?> getTokenInfo({bool forceRefresh = false}) async {
    // Return cached token if still fresh (> 5 min before expiry).
    if (!forceRefresh && _cachedToken != null) {
      final remaining =
          _cachedToken!.expiresAt.difference(DateTime.now().toUtc());
      if (remaining > const Duration(minutes: 5)) {
        return _cachedToken;
      }
    }
    final token = await _adcService.refreshAccessToken();
    _cachedToken = token;
    return token;
  }

  /// Get an audience-specific ID token for backends protected by IAP or
  /// Cloud Run IAM.
  ///
  /// Uses the standard OAuth2 token exchange with `audience` parameter.
  /// Returns the raw ID token string, or null if the exchange fails.
  Future<String?> getIdToken({required String audience}) async {
    final adc = await _adcService.readAdcFile();
    if (adc == null || !adc.canDirectRefresh) return null;

    try {
      final response = await http.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        body: {
          'client_id': adc.clientId!,
          'client_secret': adc.clientSecret!,
          'refresh_token': adc.refreshToken!,
          'grant_type': 'refresh_token',
          'audience': audience,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final data = json.decode(response.body) as Map<String, dynamic>;
      return data['id_token'] as String?;
    } catch (_) {
      return null;
    }
  }

  // ── CLI Detection ───────────────────────────────────────────────────────

  /// Check if the `candela` CLI binary is available on PATH.
  ///
  /// This is advisory only — the desktop app works fully without the CLI.
  /// The CLI is only needed for `candela auth login` (interactive browser
  /// OAuth2 flow) and `candela proxy start`.
  Future<bool> isCandelaInstalled() async {
    try {
      final result = await Process.run('candela', ['--version'],
          environment: _augmentedEnv());
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  // ── API Enablement (direct REST) ────────────────────────────────────────

  /// Check if a GCP API is enabled for [project] using a direct REST call.
  ///
  /// Replaces the legacy `gcloud services list` subprocess. Uses a cached
  /// access token when available to avoid redundant OAuth2 refreshes.
  ///
  /// Returns `true` if the API is enabled, `false` if disabled or if the
  /// check fails (e.g., no token, network error, insufficient permissions).
  Future<bool> isApiEnabled(String project, String api) async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return false;

    try {
      final uri = Uri.https(
        'serviceusage.googleapis.com',
        '/v1/projects/$project/services/$api',
      );
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $accessToken',
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return false;

      final data = json.decode(response.body) as Map<String, dynamic>;
      return data['state'] == 'ENABLED';
    } catch (_) {
      return false;
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  /// Augmented environment with common binary install locations.
  ///
  /// macOS GUI apps don't inherit shell PATH, so we search explicitly for
  /// common candela/homebrew install locations.
  Map<String, String> _augmentedEnv() {
    final env = Map<String, String>.from(Platform.environment);
    final home = env['HOME'] ?? '/Users/${env['USER'] ?? 'unknown'}';
    final extraPaths = [
      '/opt/homebrew/bin',
      '/usr/local/bin',
      '$home/.local/bin',
      '$home/go/bin',
    ];
    final currentPath = env['PATH'] ?? '';
    env['PATH'] = '${extraPaths.join(':')}:$currentPath';
    return env;
  }

  /// Expose augmented env for login subprocess spawning (used by
  /// [IdentityCard._runAdcLogin]).
  Map<String, String> get augmentedEnv => _augmentedEnv();
}

/// Aggregated auth status returned by [CandelaAuthService.getStatus].
class AuthStatus {
  final String? email;
  final String? project;
  final AdcInfo? adcInfo;
  final TokenInfo? tokenInfo;

  const AuthStatus({
    this.email,
    this.project,
    this.adcInfo,
    this.tokenInfo,
  });
}
