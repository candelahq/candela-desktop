/// Information about the user's GCP identity and token.
///
/// All identity data is now sourced from the ADC file and direct OAuth2
/// token refresh — no `gcloud` subprocess dependency.
class IdentityState {
  final String? email;
  final String? project;
  final AdcInfo? adcInfo;
  final TokenInfo? tokenInfo;

  /// Non-null when `GOOGLE_APPLICATION_CREDENTIALS` is set and points to
  /// a file other than the default ADC path.
  final CredentialOverride? credentialOverride;

  const IdentityState({
    this.email,
    this.project,
    this.adcInfo,
    this.tokenInfo,
    this.credentialOverride,
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

/// Indicates that `GOOGLE_APPLICATION_CREDENTIALS` is set to a file other
/// than the standard ADC path, overriding the default credential lookup.
///
/// This is a common source of confusion: the desktop app reads the ADC file
/// directly, but client libraries at runtime will use whatever
/// `GOOGLE_APPLICATION_CREDENTIALS` points to. If that's a service account
/// key, the effective identity differs from what the desktop displays.
class CredentialOverride {
  /// The path that `GOOGLE_APPLICATION_CREDENTIALS` is set to.
  final String path;

  /// The credential type ("service_account", "authorized_user", etc.)
  /// if the file was readable and parseable, otherwise null.
  final String? type;

  /// The service account email if this is a service account key.
  final String? clientEmail;

  const CredentialOverride({
    required this.path,
    this.type,
    this.clientEmail,
  });

  bool get isServiceAccount => type == 'service_account';

  String get displayLabel {
    if (isServiceAccount && clientEmail != null) {
      return 'Service Account: $clientEmail';
    }
    if (type != null) return 'Credential type: $type';
    return path;
  }
}
