import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/platform_paths.dart' as platform_paths;

import '../models/identity_state.dart';

/// Reads the Application Default Credentials file and can refresh tokens
/// directly via Google's OAuth2 token endpoint — no gcloud subprocess needed.
class AdcService {
  static const _tokenEndpoint = 'https://oauth2.googleapis.com/token';

  /// Read the ADC credentials file and return its info.
  Future<AdcInfo?> readAdcFile() async {
    final String adcPath;
    try {
      adcPath = _adcPath();
    } on StateError {
      return null;
    }
    final file = File(adcPath);

    if (!await file.exists()) return null;

    try {
      final content =
          json.decode(await file.readAsString()) as Map<String, dynamic>;
      return AdcInfo(
        path: adcPath,
        type: content['type'] as String? ?? 'unknown',
        clientEmail: content['client_email'] as String?,
        quotaProject: content['quota_project_id'] as String?,
        clientId: content['client_id'] as String?,
        clientSecret: content['client_secret'] as String?,
        refreshToken: content['refresh_token'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  /// Refresh the access token directly via Google's OAuth2 token endpoint.
  ///
  /// Returns a [TokenInfo] with the real expiry from the token response,
  /// or null if the ADC file is missing or the refresh fails.
  /// This eliminates the need for `gcloud auth print-access-token`.
  Future<TokenInfo?> refreshAccessToken({AdcInfo? adcInfo}) async {
    final adc = adcInfo ?? await readAdcFile();
    if (adc == null || !adc.canDirectRefresh) return null;

    try {
      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        body: {
          'client_id': adc.clientId!,
          'client_secret': adc.clientSecret!,
          'refresh_token': adc.refreshToken!,
          'grant_type': 'refresh_token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final data = json.decode(response.body) as Map<String, dynamic>;
      final accessToken = data['access_token'] as String?;
      final expiresIn = data['expires_in'] as int?;
      final idToken = data['id_token'] as String?;

      if (accessToken == null) return null;

      // Compute the real expiry from expires_in (typically 3599 seconds).
      final expiresAt = DateTime.now().toUtc().add(
            Duration(seconds: expiresIn ?? 3600),
          );

      // Try to extract email from the ID token if present.
      String? email;
      if (idToken != null) {
        email = _extractEmailFromIdToken(idToken);
      }

      return TokenInfo(
        email: email,
        accessToken: accessToken,
        expiresAt: expiresAt,
      );
    } catch (_) {
      return null;
    }
  }

  /// Extract email from a JWT ID token (second segment).
  String? _extractEmailFromIdToken(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length < 2) return null;
      final payload = json.decode(
              utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))))
          as Map<String, dynamic>;
      final email = payload['email'];
      return email is String && email.length <= 254 ? email : null;
    } catch (_) {
      return null;
    }
  }

  String _adcPath() => platform_paths.adcCredentialPath();
}
