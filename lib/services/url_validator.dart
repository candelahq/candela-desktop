import 'dart:io';

/// Centralized URL validation for Team Mode remote server URLs.
///
/// Performs both syntactic and DNS-resolved validation to prevent SSRF
/// attacks via hostnames that resolve to private/loopback addresses.
class UrlValidator {
  UrlValidator._();

  /// Validate a remote server URL for Team Mode.
  ///
  /// Returns null if valid, or an error message string.
  /// Performs synchronous checks only (scheme, format). For full DNS-based
  /// SSRF protection, use [validateWithDnsCheck].
  static String? validate(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return 'Invalid URL format';
    if (uri.scheme != 'https') return 'URL must use https://';
    if (uri.host.isEmpty) return 'URL must have a host';

    // Check literal IP addresses (IPv4 and IPv6).
    try {
      final addr = InternetAddress(uri.host);
      final error = _checkAddress(addr);
      if (error != null) return error;
    } on ArgumentError {
      // Not a literal IP — hostname will be checked via DNS in
      // validateWithDnsCheck if the caller opts in.
    }
    return null;
  }

  /// Validate a remote URL with DNS resolution to catch hostnames that
  /// resolve to private/loopback addresses (e.g., `local.gd` → 127.0.0.1).
  ///
  /// Returns null if valid, or an error message string.
  static Future<String?> validateWithDnsCheck(String url) async {
    // Run fast synchronous checks first.
    final syncError = validate(url);
    if (syncError != null) return syncError;

    final uri = Uri.parse(url);

    // Resolve hostname and validate all resulting addresses.
    try {
      final addresses = await InternetAddress.lookup(uri.host);
      for (final addr in addresses) {
        final error = _checkAddress(addr);
        if (error != null) {
          return '$error (resolved from ${uri.host})';
        }
      }
    } on SocketException {
      return 'Could not resolve hostname: ${uri.host}';
    }
    return null;
  }

  /// Check a single [InternetAddress] against private/reserved ranges.
  static String? _checkAddress(InternetAddress addr) {
    if (addr.isLoopback) return 'Loopback addresses are not allowed';
    if (addr.isLinkLocal) return 'Link-local addresses are not allowed';

    final bytes = addr.rawAddress;

    // IPv4 private ranges.
    if (bytes.length == 4) {
      if (bytes[0] == 10) return 'Private IP addresses are not allowed';
      if (bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31) {
        return 'Private IP addresses are not allowed';
      }
      if (bytes[0] == 192 && bytes[1] == 168) {
        return 'Private IP addresses are not allowed';
      }
      if (bytes[0] == 169 && bytes[1] == 254) {
        return 'Link-local addresses are not allowed';
      }
    }

    // IPv6 private ranges (fc00::/7 — Unique Local Addresses).
    if (bytes.length == 16) {
      if ((bytes[0] & 0xFE) == 0xFC) {
        return 'Private IPv6 addresses are not allowed';
      }
    }

    return null;
  }
}
