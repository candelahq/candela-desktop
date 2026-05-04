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

  String? _latestVersion;
  InstallChannel? _cachedChannel;

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
      final response = await http.get(
        Uri.parse(_releaseFeedUrl),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      // Extract tag_name from JSON response (lightweight, no json decode dep).
      final body = response.body;
      final tagMatch = RegExp(r'"tag_name"\s*:\s*"v?([^"]+)"').firstMatch(body);
      if (tagMatch == null) return null;

      final latest = tagMatch.group(1)!;
      _latestVersion = latest;

      return _isNewer(latest, currentVersion) ? latest : null;
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

  /// Simple semver comparison: is [a] newer than [b]?
  static bool _isNewer(String a, String b) {
    final aParts = a.split('.').map(int.tryParse).toList();
    final bParts = b.split('.').map(int.tryParse).toList();

    for (var i = 0; i < 3; i++) {
      final av = i < aParts.length ? (aParts[i] ?? 0) : 0;
      final bv = i < bParts.length ? (bParts[i] ?? 0) : 0;
      if (av > bv) return true;
      if (av < bv) return false;
    }
    return false;
  }
}
