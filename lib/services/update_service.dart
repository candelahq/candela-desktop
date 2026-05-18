import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// How the app was installed — determines update mechanism.
enum InstallChannel {
  /// Downloaded directly (e.g., from GitHub Releases or candelahq.com).
  /// (Sparkle removed, just prompt to download from candelahq.com).
  direct,

  /// Installed via Homebrew (`brew install candelahq/tap/candela`).
  homebrew,

  /// Installed via Nix (`nix profile install`).
  nix,

  /// Unknown install method.
  unknown,
}

/// Describes the current update status.
enum UpdateStatus {
  idle,
  checking,
  available,
  upToDate,
  error,
}

/// Manages version checking and update notifications.
///
/// Detects the install channel and provides appropriate update handling:
/// - Homebrew installs → "run `brew upgrade candela`"
/// - Nix installs → "run `nix profile upgrade`"
/// - Direct installs → fallback message
class UpdateService extends ChangeNotifier {
  static const _releaseFeedUrl =
      'https://api.github.com/repos/candelahq/candela-desktop/releases/latest';

  final http.Client _client;

  String? _latestVersion;
  InstallChannel? _cachedChannel;
  UpdateStatus _status = UpdateStatus.idle;

  void _setStatus(UpdateStatus s) {
    if (_status != s) {
      _status = s;
      notifyListeners();
    }
  }

  UpdateService({http.Client? client}) : _client = client ?? http.Client();

  /// Current update status.
  UpdateStatus get status => _status;

  /// The last known latest version (cached from [checkForUpdate]).
  String? get latestVersion => _latestVersion;

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
    _setStatus(UpdateStatus.checking);
    try {
      final response = await _client.get(
        Uri.parse(_releaseFeedUrl),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        _setStatus(UpdateStatus.error);
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final tagName = data['tag_name'] as String?;
      if (tagName == null || tagName.isEmpty) {
        _setStatus(UpdateStatus.error);
        return null;
      }

      final latest = tagName.startsWith('v') ? tagName.substring(1) : tagName;
      _latestVersion = latest;

      if (isNewer(latest, currentVersion)) {
        _setStatus(UpdateStatus.available);
        return latest;
      } else {
        _setStatus(UpdateStatus.upToDate);
        return null;
      }
    } catch (_) {
      _setStatus(UpdateStatus.error);
      return null; // Network error, don't block the user.
    }
  }

  /// User-facing update instructions based on install channel.
  String updateInstructions(InstallChannel channel) {
    switch (channel) {
      case InstallChannel.direct:
        return 'Download the latest version from candelahq.com/releases';
      case InstallChannel.homebrew:
        return 'Run: brew upgrade --cask candelahq/tap/candela-desktop';
      case InstallChannel.nix:
        return 'Run: nix profile upgrade';
      case InstallChannel.unknown:
        debugPrint(
            '[UpdateService] Unknown install channel for: ${Platform.resolvedExecutable}');
        return 'Visit candelahq.com/releases for the latest version.';
    }
  }

  /// Semver comparison: is [a] newer than [b]?
  static bool isNewer(String a, String b) {
    final aParsed = _parseSemver(a);
    final bParsed = _parseSemver(b);

    for (var i = 0; i < 3; i++) {
      if (aParsed.version[i] > bParsed.version[i]) return true;
      if (aParsed.version[i] < bParsed.version[i]) return false;
    }

    if (aParsed.preRelease == null && bParsed.preRelease != null) return true;
    if (aParsed.preRelease != null && bParsed.preRelease == null) return false;
    if (aParsed.preRelease != null && bParsed.preRelease != null) {
      return aParsed.preRelease!.compareTo(bParsed.preRelease!) > 0;
    }

    return false;
  }

  static _SemverParts _parseSemver(String version) {
    if (version.startsWith('v') || version.startsWith('V')) {
      version = version.substring(1);
    }

    final plusIdx = version.indexOf('+');
    final withoutBuild =
        plusIdx == -1 ? version : version.substring(0, plusIdx);

    final dashIdx = withoutBuild.indexOf('-');
    final base =
        dashIdx == -1 ? withoutBuild : withoutBuild.substring(0, dashIdx);
    final preRelease =
        dashIdx == -1 ? null : withoutBuild.substring(dashIdx + 1);

    final parts = base.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    while (parts.length < 3) {
      parts.add(0);
    }

    return _SemverParts(parts.sublist(0, 3), preRelease);
  }

  /// Perform a Homebrew cask upgrade and relaunch the app.
  Future<bool> performBrewUpgrade() async {
    _setStatus(UpdateStatus.checking);
    try {
      final result = await Process.run(
        'brew',
        ['upgrade', '--cask', 'candelahq/tap/candela-desktop'],
      );

      if (result.exitCode != 0) {
        _setStatus(UpdateStatus.error);
        return false;
      }

      await Process.start(
        'open',
        ['-n', '-a', 'Candela'],
        mode: ProcessStartMode.detached,
      );

      exit(0);
    } catch (_) {
      _setStatus(UpdateStatus.error);
      return false;
    }
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }
}

class _SemverParts {
  final List<int> version;
  final String? preRelease;
  const _SemverParts(this.version, this.preRelease);
}
