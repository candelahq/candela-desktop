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
String homeDir() {
  if (Platform.isWindows) {
    return Platform.environment['USERPROFILE'] ??
        '${Platform.environment['HOMEDRIVE'] ?? 'C:'}${Platform.environment['HOMEPATH'] ?? r'\Users\unknown'}';
  }
  return Platform.environment['HOME'] ?? '/tmp';
}

/// Returns the Candela config directory.
///
/// - Unix/macOS: `~/.config/candela`
/// - Windows: `%APPDATA%\candela`
String candelaConfigDir() {
  if (Platform.isWindows) {
    final appData = Platform.environment['APPDATA'] ?? '';
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
String adcCredentialPath() {
  const adcFile = 'application_default_credentials.json';

  final cloudsdkConfig = Platform.environment['CLOUDSDK_CONFIG'];
  if (cloudsdkConfig != null && cloudsdkConfig.isNotEmpty) {
    return path.join(cloudsdkConfig, adcFile);
  }

  if (Platform.isWindows) {
    final appData = Platform.environment['APPDATA'] ?? '';
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
      path.join(home, 'AppData', 'Local', 'Google', 'Cloud SDK',
          'google-cloud-sdk', 'bin'),
    ];
  }
  return [
    '$home/google-cloud-sdk/bin',
    '/usr/local/google-cloud-sdk/bin',
    '/opt/homebrew/bin',
    '/usr/local/bin',
    '/opt/homebrew/share/google-cloud-sdk/bin',
    '$home/.local/bin',
  ];
}

/// The PATH separator for the current platform (`;` on Windows, `:` elsewhere).
String get pathSeparator => Platform.isWindows ? ';' : ':';

/// Build an augmented environment map with extra CLI paths prepended to PATH.
Map<String, String> buildAugmentedEnv({List<String>? additionalPaths}) {
  final env = Map<String, String>.from(Platform.environment);
  final extras = [...extraCliPaths(), ...?additionalPaths];
  final currentPath = env['PATH'] ?? '';
  env['PATH'] = '${extras.join(pathSeparator)}$pathSeparator$currentPath';
  return env;
}
