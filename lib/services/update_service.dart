import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'brew_service.dart';
import '../utils/process_runner.dart';

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

  /// Public releases page URL for direct-install users.
  static const releasesPageUrl =
      'https://github.com/candelahq/candela-desktop/releases';

  final http.Client _client;
  final ProcessRunner _runner;
  final BrewService _brew;

  String? _latestVersion;
  InstallChannel? _cachedChannel;
  UpdateStatus _status = UpdateStatus.idle;
  bool _disposed = false;

  /// Safe notification — prevents crashes if called after [dispose].
  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  void _setStatus(UpdateStatus s) {
    if (_status != s) {
      _status = s;
      notifyListeners();
    }
  }

  UpdateService({http.Client? client, ProcessRunner? runner, BrewService? brew})
      : _client = client ?? http.Client(),
        _runner = runner ?? const SystemProcessRunner(),
        _brew = brew ?? BrewService(runner: runner);

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
    } else if (_hasBrewCaskReceipt()) {
      // Homebrew Cask copies the app to /Applications, so the executable
      // path won't contain /Caskroom/. Check for a Caskroom receipt instead.
      _cachedChannel = InstallChannel.homebrew;
    } else {
      _cachedChannel = InstallChannel.direct;
    }

    return _cachedChannel!;
  }

  /// Check if a Homebrew Caskroom receipt exists for candela-desktop.
  bool _hasBrewCaskReceipt() {
    try {
      // Homebrew on Apple Silicon: /opt/homebrew/Caskroom
      // Homebrew on Intel: /usr/local/Caskroom
      for (final prefix in ['/opt/homebrew', '/usr/local']) {
        final receipt = Directory('$prefix/Caskroom/candela-desktop');
        if (receipt.existsSync()) return true;
      }
      return false;
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
        return 'Download the latest version from GitHub releases';
      case InstallChannel.homebrew:
        return 'Run: brew upgrade --cask candelahq/tap/candela-desktop';
      case InstallChannel.nix:
        return 'Run: nix profile upgrade';
      case InstallChannel.unknown:
        debugPrint(
            '[UpdateService] Unknown install channel for: ${Platform.resolvedExecutable}');
        return 'Visit GitHub releases for the latest version.';
    }
  }

  /// Open the releases page in the default browser (for direct/unknown installs).
  Future<bool> openReleasesPage() async {
    final uri = Uri.parse(releasesPageUrl);
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
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
  ///
  /// This is macOS-only — Homebrew is not available on Windows/Linux.
  /// Delegates to [BrewService] which correctly resolves the `brew` binary
  /// path even when the app runs outside a shell environment.
  Future<bool> performBrewUpgrade() async {
    if (!Platform.isMacOS) return false;
    _setStatus(UpdateStatus.checking);
    try {
      final result = await _brew.upgradeCask('candelahq/tap/candela-desktop');

      if (!result.success) {
        _setStatus(UpdateStatus.error);
        return false;
      }

      await _runner.start(
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
    _disposed = true;
    _client.close();
    super.dispose();
  }
}

class _SemverParts {
  final List<int> version;
  final String? preRelease;
  const _SemverParts(this.version, this.preRelease);
}
