/// Information about the user's GCP identity and token.
///
/// All identity data is now sourced from the ADC file and direct OAuth2
/// token refresh — no `gcloud` subprocess dependency.
class IdentityState {
  final String? email;
  final String? project;
  final AdcInfo? adcInfo;
  final TokenInfo? tokenInfo;

  const IdentityState({
    this.email,
    this.project,
    this.adcInfo,
    this.tokenInfo,
  });

  bool get isAuthenticated =>
      email != null && tokenInfo != null && tokenInfo!.isValid;
}

/// Decoded Application Default Credentials file info.
class AdcInfo {
  final String path;
  final String type; // "authorized_user" or "service_account"
  final String? clientEmail;
  final String? quotaProject;

  /// OAuth2 credentials for direct token refresh (no gcloud needed).
  final String? clientId;
  final String? clientSecret;
  final String? refreshToken;

  const AdcInfo({
    required this.path,
    required this.type,
    this.clientEmail,
    this.quotaProject,
    this.clientId,
    this.clientSecret,
    this.refreshToken,
  });

  bool get isServiceAccount => type == 'service_account';
  bool get isUserCredentials => type == 'authorized_user';

  /// Whether this credential has the fields needed for direct token refresh.
  bool get canDirectRefresh =>
      isUserCredentials &&
      clientId != null &&
      clientSecret != null &&
      refreshToken != null;

  String get displayType =>
      isServiceAccount ? 'Service Account' : 'Application Default Credentials';
}

/// Token info from decoding a JWT access token.
class TokenInfo {
  final String? email;
  final String? accessToken;
  final DateTime expiresAt;

  const TokenInfo({
    this.email,
    this.accessToken,
    required this.expiresAt,
  });

  /// Dynamic validity check — avoids stale state when the object is held
  /// in memory past its expiry time.
  bool get isValid => expiresAt.isAfter(DateTime.now().toUtc());

  Duration get timeRemaining => expiresAt.difference(DateTime.now());

  String get expiryDisplay {
    final remaining = timeRemaining;
    if (!isValid || remaining.isNegative) return 'Expired';
    if (remaining.inMinutes < 1) return '< 1 min';
    if (remaining.inMinutes < 60) return '${remaining.inMinutes} min';
    return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
  }
}
