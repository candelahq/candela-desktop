import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// How the app was installed — determines update mechanism.
enum InstallChannel {
  /// Downloaded directly (e.g., from GitHub Releases or candelahq.com).
  /// Uses Sparkle for in-app auto-update on macOS.
  direct,

  /// Installed via Homebrew (`brew install candelahq/tap/candela`).
  homebrew,

  /// Installed via Nix (`nix profile install`).
  nix,

  /// Unknown install method.
  unknown,
}

/// Manages version checking and update notifications.
///
/// Detects the install channel and provides appropriate update guidance:
/// - Direct installs → Sparkle auto-update (macOS) or download prompt
/// - Homebrew installs → "run `brew upgrade candela`"
/// - Nix installs → "run `nix profile upgrade`"
class UpdateService {
  static const _releaseFeedUrl =
      'https://api.github.com/repos/candelahq/candela-desktop/releases/latest';

  /// Allow injection for testing.
  final http.Client _client;

  String? _latestVersion;
  InstallChannel? _cachedChannel;

  UpdateService({http.Client? client}) : _client = client ?? http.Client();

  /// Detect how the app was installed.
  InstallChannel detectChannel() {
    if (_cachedChannel != null) return _cachedChannel!;

    final appPath = Platform.resolvedExecutable;

    if (appPath.contains('/Caskroom/') ||
        appPath.contains('/homebrew/') ||
        appPath.contains('/usr/local/Cellar/')) {
      _cachedChannel = InstallChannel.homebrew;
    } else if (appPath.contains('/nix/store/')) {
      _cachedChannel = InstallChannel.nix;
    } else {
      _cachedChannel = InstallChannel.direct;
    }

    return _cachedChannel!;
  }

  /// Check GitHub Releases for a newer version.
  ///
  /// Returns the latest version string (e.g., "0.3.0") if newer than
  /// [currentVersion], or null if already up to date.
  Future<String?> checkForUpdate(String currentVersion) async {
    try {
      final response = await _client.get(
        Uri.parse(_releaseFeedUrl),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final tagName = data['tag_name'] as String?;
      if (tagName == null || tagName.isEmpty) return null;

      final latest = tagName.startsWith('v') ? tagName.substring(1) : tagName;
      _latestVersion = latest;

      return isNewer(latest, currentVersion) ? latest : null;
    } catch (_) {
      return null; // Network error, don't block the user.
    }
  }

  /// The last known latest version (cached from [checkForUpdate]).
  String? get latestVersion => _latestVersion;

  /// User-facing update instructions based on install channel.
  String updateInstructions(InstallChannel channel) {
    switch (channel) {
      case InstallChannel.direct:
        return 'A new version is available. It will be installed automatically.';
      case InstallChannel.homebrew:
        return 'Run: brew upgrade candela';
      case InstallChannel.nix:
        return 'Run: nix profile upgrade';
      case InstallChannel.unknown:
        return 'Visit candelahq.com/releases for the latest version.';
    }
  }

  /// Semver comparison: is [a] newer than [b]?
  ///
  /// Handles pre-release tags: `0.2.0` is newer than `0.2.0-beta.1`.
  /// Pre-release versions with the same base are ordered by pre-release
  /// identifier (e.g. `beta.2` > `beta.1`).
  static bool isNewer(String a, String b) {
    final aParsed = _parseSemver(a);
    final bParsed = _parseSemver(b);

    // Compare major.minor.patch
    for (var i = 0; i < 3; i++) {
      if (aParsed.version[i] > bParsed.version[i]) return true;
      if (aParsed.version[i] < bParsed.version[i]) return false;
    }

    // Same base version — compare pre-release.
    // No pre-release > any pre-release (1.0.0 > 1.0.0-beta.1).
    if (aParsed.preRelease == null && bParsed.preRelease != null) return true;
    if (aParsed.preRelease != null && bParsed.preRelease == null) return false;
    if (aParsed.preRelease != null && bParsed.preRelease != null) {
      return aParsed.preRelease!.compareTo(bParsed.preRelease!) > 0;
    }

    return false;
  }

  static _SemverParts _parseSemver(String version) {
    // Split on '-' to separate base from pre-release.
    final dashIdx = version.indexOf('-');
    final base = dashIdx == -1 ? version : version.substring(0, dashIdx);
    final preRelease = dashIdx == -1 ? null : version.substring(dashIdx + 1);

    final parts = base.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    while (parts.length < 3) {
      parts.add(0);
    }

    return _SemverParts(parts.sublist(0, 3), preRelease);
  }
}

class _SemverParts {
  final List<int> version;
  final String? preRelease;
  const _SemverParts(this.version, this.preRelease);
}
