import 'dart:io';

import 'package:path/path.dart' as path;

/// Platform-aware path helpers.
///
/// On Windows, environment variables like `HOME` do not exist. This module
/// centralises the platform detection so every call-site doesn't need to
/// repeat the same `Platform.isWindows` / `APPDATA` / `USERPROFILE` dance.

/// Returns the user's home directory.
///
/// - Unix/macOS: `$HOME`
/// - Windows: `%USERPROFILE%` (falls back to `%HOMEDRIVE%%HOMEPATH%`)
///
/// Throws [StateError] if the home directory cannot be determined.
String homeDir() {
  if (Platform.isWindows) {
    final userProfile = Platform.environment['USERPROFILE'];
    if (userProfile != null && userProfile.isNotEmpty) return userProfile;
    final homeDrive = Platform.environment['HOMEDRIVE'];
    final homePath = Platform.environment['HOMEPATH'];
    if (homeDrive != null && homePath != null) return '$homeDrive$homePath';
    throw StateError(
        'Unable to determine home directory: %USERPROFILE% is not set');
  }
  final home = Platform.environment['HOME'];
  if (home == null || home.isEmpty) {
    throw StateError('Unable to determine home directory: \$HOME is not set');
  }
  return home;
}

/// Returns the Candela config directory.
///
/// - Unix/macOS: `~/.config/candela`
/// - Windows: `%APPDATA%\candela`
///
/// Throws [StateError] on Windows if `%APPDATA%` is not set.
String candelaConfigDir() {
  if (Platform.isWindows) {
    final appData = Platform.environment['APPDATA'];
    if (appData == null || appData.isEmpty) {
      throw StateError(
          'Unable to determine config directory: %APPDATA% is not set');
    }
    return path.join(appData, 'candela');
  }
  return path.join(homeDir(), '.config', 'candela');
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

  final cloudsdkConfig = Platform.environment['CLOUDSDK_CONFIG'];
  if (cloudsdkConfig != null && cloudsdkConfig.isNotEmpty) {
    return path.join(cloudsdkConfig, adcFile);
  }

  if (Platform.isWindows) {
    final appData = Platform.environment['APPDATA'];
    if (appData == null || appData.isEmpty) {
      throw StateError('Unable to determine ADC path: %APPDATA% is not set');
    }
    return path.join(appData, 'gcloud', adcFile);
  }

  return path.join(homeDir(), '.config', 'gcloud', adcFile);
}

/// Returns additional PATH entries for finding CLI tools (gcloud, candela,
/// homebrew binaries).
///
/// On Windows, this returns Google Cloud SDK install locations.
/// On macOS/Linux, this returns common Homebrew and user-local paths.
List<String> extraCliPaths() {
  final home = homeDir();
  if (Platform.isWindows) {
    final localAppData = Platform.environment['LOCALAPPDATA'] ?? '';
    final programFiles =
        Platform.environment['ProgramFiles'] ?? r'C:\Program Files';
    return [
      path.join(localAppData, 'Google', 'Cloud SDK', 'google-cloud-sdk', 'bin'),
      path.join(programFiles, 'Google', 'Cloud SDK', 'google-cloud-sdk', 'bin'),
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

/// The PATH separator for the current platform (`;` on Windows, `:` elsewhere).
String get pathSeparator => Platform.isWindows ? ';' : ':';

/// Build an augmented environment map with extra CLI paths prepended to PATH.
///
/// Note: Dart's `Platform.environment` on Windows already normalises keys to
/// upper case, so `'PATH'` is the canonical key on all platforms.
Map<String, String> buildAugmentedEnv({List<String>? additionalPaths}) {
  final env = Map<String, String>.from(Platform.environment);
  final extras = [...extraCliPaths(), ...?additionalPaths];
  final currentPath = env['PATH'] ?? '';
  env['PATH'] = '${extras.join(pathSeparator)}$pathSeparator$currentPath';
  return env;
}
