import 'dart:convert';
import 'dart:io';

import 'package:auto_updater/auto_updater.dart';
import 'package:flutter/foundation.dart';
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

/// Describes the current update status.
enum UpdateStatus {
  /// No update check has been performed yet.
  idle,

  /// Currently checking for updates.
  checking,

  /// An update is available.
  available,

  /// Already on the latest version.
  upToDate,

  /// Check failed (network error, etc).
  error,
}

/// Manages version checking, update notifications, and Sparkle auto-update.
///
/// Detects the install channel and provides appropriate update handling:
/// - Direct installs (macOS) → Sparkle auto-update via `auto_updater`
/// - Homebrew installs → "run `brew upgrade candela`"
/// - Nix installs → "run `nix profile upgrade`"
class UpdateService extends ChangeNotifier {
  static const _releaseFeedUrl =
      'https://api.github.com/repos/candelahq/candela-desktop/releases/latest';

  static const _appcastUrl =
      'https://github.com/candelahq/candela-desktop/releases/latest/download/appcast.xml';

  /// Scheduled check interval: every 4 hours (in seconds).
  static const _checkIntervalSeconds = 4 * 60 * 60;

  /// Allow injection for testing.
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

  bool _sparkleInitialized = false;

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

  /// Initialize Sparkle auto-updater for direct installs on macOS.
  ///
  /// Sets the appcast feed URL and schedules periodic background checks.
  /// No-op if the install channel is not [InstallChannel.direct] or
  /// if the platform is not macOS.
  Future<void> initSparkle() async {
    if (_sparkleInitialized) return;
    if (!Platform.isMacOS) return;
    if (detectChannel() != InstallChannel.direct) return;

    try {
      await autoUpdater.setFeedURL(_appcastUrl);
      await autoUpdater.setScheduledCheckInterval(_checkIntervalSeconds);
      _sparkleInitialized = true;
    } catch (_) {
      // Sparkle not available — silent fallback to manual check.
    }
  }

  /// Trigger an immediate Sparkle update check (shows native UI dialog).
  ///
  /// Only works for direct installs on macOS. Returns false if Sparkle
  /// is not available (wrong channel, not macOS, etc.).
  Future<bool> checkForUpdatesViaSparkle() async {
    if (!_sparkleInitialized) return false;
    try {
      await autoUpdater.checkForUpdates();
      return true;
    } catch (_) {
      return false;
    }
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
        return 'A new version is available. It will be installed automatically.';
      case InstallChannel.homebrew:
        return 'Run: brew upgrade --cask candelahq/tap/candela-desktop';
      case InstallChannel.nix:
        return 'Run: nix profile upgrade';
      case InstallChannel.unknown:
        // CRITICAL-6: unknown channel is silent in production — log for
        // diagnostics (CI artifacts, custom installs, App Store builds).
        debugPrint(
            '[UpdateService] Unknown install channel for: ${Platform.resolvedExecutable}');
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

  /// Perform a Homebrew cask upgrade and relaunch the app.
  ///
  /// Runs `brew upgrade --cask candelahq/tap/candela-desktop`, then
  /// relaunches via `open -n` and exits the current process.
  /// Returns false if the upgrade failed (the app stays open).
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

      // Relaunch the updated app.
      await Process.start(
        'open',
        ['-n', '/Applications/Candela.app'],
        mode: ProcessStartMode.detached,
      );

      // Exit the current (old) process.
      exit(0);
    } catch (_) {
      _setStatus(UpdateStatus.error);
      return false;
    }
  }
}

class _SemverParts {
  final List<int> version;
  final String? preRelease;
  const _SemverParts(this.version, this.preRelease);
}
