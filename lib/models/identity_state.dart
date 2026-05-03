/// Information about the user's GCP identity and token.
class IdentityState {
  final String? email;
  final String? project;
  final AdcInfo? adcInfo;
  final TokenInfo? tokenInfo;
  final bool gcloudInstalled;

  const IdentityState({
    this.email,
    this.project,
    this.adcInfo,
    this.tokenInfo,
    this.gcloudInstalled = false,
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
  final DateTime expiresAt;
  final bool isValid;

  const TokenInfo({
    this.email,
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
