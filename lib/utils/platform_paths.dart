import 'dart:io';

import 'package:path/path.dart' as path;

/// Injectable platform-aware path helpers.
///
/// The [PlatformPaths] class encapsulates all platform detection and
/// environment variable access, making it possible to test Windows paths
/// on macOS CI by constructing with `isWindows: true` and a synthetic `env`.
///
/// For convenience, top-level functions delegate to a default instance that
/// reads from [Platform.environment] / [Platform.isWindows] / etc.
class PlatformPaths {
  /// The environment variables to read from.
  final Map<String, String> env;

  /// Whether the platform is Windows.
  final bool isWindows;

  /// Whether the platform is macOS.
  final bool isMacOS;

  /// Whether the platform is Linux.
  final bool isLinux;

  /// The resolved executable path (used for icon/bundle resolution).
  final String resolvedExecutable;

  /// Creates a [PlatformPaths] with explicit platform info.
  ///
  /// For production, use the top-level functions (which delegate to a
  /// default instance). For tests, construct directly:
  ///
  /// ```dart
  /// final paths = PlatformPaths(
  ///   env: {'APPDATA': r'C:\Users\test\AppData\Roaming'},
  ///   isWindows: true,
  /// );
  /// expect(paths.candelaConfigDir(), contains('candela'));
  /// ```
  const PlatformPaths({
    required this.env,
    required this.isWindows,
    this.isMacOS = false,
    this.isLinux = false,
    this.resolvedExecutable = '',
  });

  /// Returns the user's home directory.
  ///
  /// - Unix/macOS: `$HOME`
  /// - Windows: `%USERPROFILE%` (falls back to `%HOMEDRIVE%%HOMEPATH%`)
  ///
  /// Throws [StateError] if the home directory cannot be determined.
  String homeDir() {
    if (isWindows) {
      final userProfile = env['USERPROFILE'];
      if (userProfile != null && userProfile.isNotEmpty) return userProfile;
      final homeDrive = env['HOMEDRIVE'];
      final homePath = env['HOMEPATH'];
      if (homeDrive != null && homePath != null) return '$homeDrive$homePath';
      throw StateError(
          'Unable to determine home directory: %USERPROFILE% is not set');
    }
    final home = env['HOME'];
    if (home == null || home.isEmpty) {
      throw StateError('Unable to determine home directory: \$HOME is not set');
    }
    return home;
  }

  /// Returns the Candela config directory.
  ///
  /// - Linux: `$XDG_CONFIG_HOME/candela` (defaults to `~/.config/candela`)
  /// - macOS: `~/.config/candela`
  /// - Windows: `%APPDATA%\candela`
  ///
  /// Throws [StateError] on Windows if `%APPDATA%` is not set.
  String candelaConfigDir() {
    if (isWindows) {
      final appData = env['APPDATA'];
      if (appData == null || appData.isEmpty) {
        throw StateError(
            'Unable to determine config directory: %APPDATA% is not set');
      }
      return path.join(appData, 'candela');
    }
    return path.join(_xdgConfigHome(), 'candela');
  }

  /// Returns the full path to `config.yaml`.
  String candelaConfigPath() => path.join(candelaConfigDir(), 'config.yaml');

  /// Returns the legacy config path (`~/.candela.yaml`).
  String candelaLegacyConfigPath() => path.join(homeDir(), '.candela.yaml');

  /// Returns the Application Default Credentials JSON path.
  ///
  /// Mirrors the Go CLI logic in `pkg/cloudauth/gcp.go:ADCPath()`:
  ///   1. `$CLOUDSDK_CONFIG/application_default_credentials.json`
  ///   2. Windows: `%APPDATA%\gcloud\application_default_credentials.json`
  ///   3. Unix:    `~/.config/gcloud/application_default_credentials.json`
  ///
  /// Throws [StateError] on Windows if `%APPDATA%` is not set (and
  /// `$CLOUDSDK_CONFIG` is not set either).
  String adcCredentialPath() {
    const adcFile = 'application_default_credentials.json';

    final cloudsdkConfig = env['CLOUDSDK_CONFIG'];
    if (cloudsdkConfig != null && cloudsdkConfig.isNotEmpty) {
      return path.join(cloudsdkConfig, adcFile);
    }

    if (isWindows) {
      final appData = env['APPDATA'];
      if (appData == null || appData.isEmpty) {
        throw StateError('Unable to determine ADC path: %APPDATA% is not set');
      }
      return path.join(appData, 'gcloud', adcFile);
    }

    return path.join(_xdgConfigHome(), 'gcloud', adcFile);
  }

  /// Returns `$XDG_CONFIG_HOME` if set (Linux only), otherwise `~/.config`.
  ///
  /// Per the XDG Base Directory Specification, `XDG_CONFIG_HOME` defaults
  /// to `$HOME/.config` when not explicitly set.
  String _xdgConfigHome() {
    if (isLinux) {
      final xdg = env['XDG_CONFIG_HOME'];
      if (xdg != null && xdg.isNotEmpty) return xdg;
    }
    return path.join(homeDir(), '.config');
  }

  /// Returns additional PATH entries for finding CLI tools (gcloud, candela,
  /// homebrew binaries).
  ///
  /// On Windows, this returns Google Cloud SDK install locations.
  /// On macOS/Linux, this returns common Homebrew and user-local paths.
  List<String> extraCliPaths() {
    final home = homeDir();
    if (isWindows) {
      final localAppData = env['LOCALAPPDATA'];
      final programFiles = env['ProgramFiles'] ?? r'C:\Program Files';
      return [
        if (localAppData != null && localAppData.isNotEmpty)
          path.join(
              localAppData, 'Google', 'Cloud SDK', 'google-cloud-sdk', 'bin'),
        if (programFiles.isNotEmpty)
          path.join(
              programFiles, 'Google', 'Cloud SDK', 'google-cloud-sdk', 'bin'),
        path.join(home, 'google-cloud-sdk', 'bin'),
      ];
    }
    return [
      path.join(home, 'google-cloud-sdk', 'bin'),
      '/usr/local/google-cloud-sdk/bin',
      '/opt/homebrew/bin',
      '/usr/local/bin',
      '/opt/homebrew/share/google-cloud-sdk/bin',
      path.join(home, '.local', 'bin'),
    ];
  }

  /// The PATH separator for the current platform (`;` on Windows,
  /// `:` elsewhere).
  String get pathSeparator => isWindows ? ';' : ':';

  /// Build an augmented environment map with extra CLI paths prepended
  /// to PATH.
  ///
  /// When [filterExisting] is true, directories that don't exist on the
  /// filesystem are excluded.  The top-level shim passes `true`; unit
  /// tests with synthetic envs can leave it `false`.
  ///
  /// Note: Dart's `Platform.environment` on Windows already normalises keys
  /// to upper case, so `'PATH'` is the canonical key on all platforms.
  Map<String, String> buildAugmentedEnv({
    List<String>? additionalPaths,
    bool filterExisting = false,
  }) {
    final result = Map<String, String>.from(env);
    var extras = [...extraCliPaths(), ...?additionalPaths];
    if (filterExisting) {
      extras = extras.where((p) => Directory(p).existsSync()).toList();
    }
    if (extras.isEmpty) return result;

    // Windows environment keys are case-insensitive; the actual key may be
    // 'PATH', 'Path', or 'path'. Find the canonical key.
    final pathKey = result.keys.firstWhere(
      (k) => k.toUpperCase() == 'PATH',
      orElse: () => 'PATH',
    );
    final currentPath = result[pathKey];

    // Avoid trailing separator when PATH is empty — an empty entry in PATH
    // is interpreted as CWD on Unix (CWE-426: Untrusted Search Path).
    if (currentPath != null && currentPath.isNotEmpty) {
      result[pathKey] =
          '${extras.join(pathSeparator)}$pathSeparator$currentPath';
    } else {
      result[pathKey] = extras.join(pathSeparator);
    }
    return result;
  }
}

// ─── Top-level shim (zero-change migration for callers) ──────────────────────

/// Default instance backed by [Platform].
final _default = PlatformPaths(
  env: Platform.environment,
  isWindows: Platform.isWindows,
  isMacOS: Platform.isMacOS,
  isLinux: Platform.isLinux,
  resolvedExecutable: Platform.resolvedExecutable,
);

/// Returns the user's home directory.
///
/// See [PlatformPaths.homeDir] for details.
String homeDir() => _default.homeDir();

/// Returns the Candela config directory.
///
/// See [PlatformPaths.candelaConfigDir] for details.
String candelaConfigDir() => _default.candelaConfigDir();

/// Returns the full path to `config.yaml`.
String candelaConfigPath() => _default.candelaConfigPath();

/// Returns the legacy config path (`~/.candela.yaml`).
String candelaLegacyConfigPath() => _default.candelaLegacyConfigPath();

/// Returns the Application Default Credentials JSON path.
///
/// See [PlatformPaths.adcCredentialPath] for details.
String adcCredentialPath() => _default.adcCredentialPath();

/// Returns additional PATH entries for finding CLI tools.
///
/// See [PlatformPaths.extraCliPaths] for details.
List<String> extraCliPaths() => _default.extraCliPaths();

/// The PATH separator for the current platform.
String get pathSeparator => _default.pathSeparator;

/// Build an augmented environment map with extra CLI paths prepended.
/// Non-existent directories are filtered out.
///
/// See [PlatformPaths.buildAugmentedEnv] for details.
Map<String, String> buildAugmentedEnv({List<String>? additionalPaths}) =>
    _default.buildAugmentedEnv(
      additionalPaths: additionalPaths,
      filterExisting: true,
    );
