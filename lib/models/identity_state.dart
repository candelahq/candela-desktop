/// Information about the user's GCP identity and token.
class IdentityState {
  final String? email;
  final String? project;
  final AdcInfo? adcInfo;
  final TokenInfo? tokenInfo;
  final bool gcloudInstalled;

  /// The token that the dashboard actually uses in team mode.
  /// This may differ from [tokenInfo] (ADC) — for example, `gcloud auth`
  /// and `gcloud auth application-default` can be logged in as different
  /// accounts.
  final TokenInfo? dashboardTokenInfo;

  const IdentityState({
    this.email,
    this.project,
    this.adcInfo,
    this.tokenInfo,
    this.gcloudInstalled = false,
    this.dashboardTokenInfo,
  });

  bool get isAuthenticated =>
      email != null && tokenInfo != null && tokenInfo!.isValid;

  /// True when the ADC identity and the dashboard (gcloud auth) identity
  /// are different accounts — a common source of "no data" confusion.
  bool get hasMismatchedIdentities {
    final adcEmail = tokenInfo?.email ?? adcInfo?.clientEmail;
    final dashEmail = dashboardTokenInfo?.email;
    if (adcEmail == null || dashEmail == null) return false;
    return adcEmail.toLowerCase() != dashEmail.toLowerCase();
  }
}

/// Decoded Application Default Credentials file info.
class AdcInfo {
  final String path;
  final String type; // "authorized_user" or "service_account"
  final String? clientEmail;
  final String? quotaProject;

  const AdcInfo({
    required this.path,
    required this.type,
    this.clientEmail,
    this.quotaProject,
  });

  bool get isServiceAccount => type == 'service_account';
  bool get isUserCredentials => type == 'authorized_user';

  String get displayType =>
      isServiceAccount ? 'Service Account' : 'Application Default Credentials';
}

/// Token info from decoding a JWT access token.
class TokenInfo {
  final String? email;
  final String? accessToken;
  final DateTime expiresAt;
  final bool isValid;

  const TokenInfo({
    this.email,
    this.accessToken,
    required this.expiresAt,
    required this.isValid,
  });

  Duration get timeRemaining => expiresAt.difference(DateTime.now());

  String get expiryDisplay {
    final remaining = timeRemaining;
    if (!isValid || remaining.isNegative) return 'Expired';
    if (remaining.inMinutes < 1) return '< 1 min';
    if (remaining.inMinutes < 60) return '${remaining.inMinutes} min';
    return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
  }
}
