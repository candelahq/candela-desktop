// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The singleton ConfigService instance.

@ProviderFor(configService)
final configServiceProvider = ConfigServiceProvider._();

/// The singleton ConfigService instance.

final class ConfigServiceProvider
    extends $FunctionalProvider<ConfigService, ConfigService, ConfigService>
    with $Provider<ConfigService> {
  /// The singleton ConfigService instance.
  ConfigServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'configServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$configServiceHash();

  @$internal
  @override
  $ProviderElement<ConfigService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ConfigService create(Ref ref) {
    return configService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConfigService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConfigService>(value),
    );
  }
}

String _$configServiceHash() => r'61290a5d2807ead1e9d37c8d6ff5b931cea27b18';

/// Reactive config that auto-reloads when the config file changes on disk.
///
/// Emits the initial config, then re-emits whenever the file is modified.
/// Debouncing is handled inside [ConfigService.watchForChanges].

@ProviderFor(config)
final configProvider = ConfigProvider._();

/// Reactive config that auto-reloads when the config file changes on disk.
///
/// Emits the initial config, then re-emits whenever the file is modified.
/// Debouncing is handled inside [ConfigService.watchForChanges].

final class ConfigProvider extends $FunctionalProvider<
        AsyncValue<CandelaConfig>, CandelaConfig, Stream<CandelaConfig>>
    with $FutureModifier<CandelaConfig>, $StreamProvider<CandelaConfig> {
  /// Reactive config that auto-reloads when the config file changes on disk.
  ///
  /// Emits the initial config, then re-emits whenever the file is modified.
  /// Debouncing is handled inside [ConfigService.watchForChanges].
  ConfigProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'configProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$configHash();

  @$internal
  @override
  $StreamProviderElement<CandelaConfig> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<CandelaConfig> create(Ref ref) {
    return config(ref);
  }
}

String _$configHash() => r'1dc24e74f7dee07e7658c47f6de79ed8fb4ac5e0';

/// The singleton ProcessManager, auto-configured when config changes.

@ProviderFor(processManager)
final processManagerProvider = ProcessManagerProvider._();

/// The singleton ProcessManager, auto-configured when config changes.

final class ProcessManagerProvider
    extends $FunctionalProvider<ProcessManager, ProcessManager, ProcessManager>
    with $Provider<ProcessManager> {
  /// The singleton ProcessManager, auto-configured when config changes.
  ProcessManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'processManagerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$processManagerHash();

  @$internal
  @override
  $ProviderElement<ProcessManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProcessManager create(Ref ref) {
    return processManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProcessManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProcessManager>(value),
    );
  }
}

String _$processManagerHash() => r'14a390b49e43422b6ef4c4f7eb88d92526049f8c';

/// Homebrew CLI wrapper for install/upgrade operations.

@ProviderFor(brewService)
final brewServiceProvider = BrewServiceProvider._();

/// Homebrew CLI wrapper for install/upgrade operations.

final class BrewServiceProvider
    extends $FunctionalProvider<BrewService, BrewService, BrewService>
    with $Provider<BrewService> {
  /// Homebrew CLI wrapper for install/upgrade operations.
  BrewServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'brewServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$brewServiceHash();

  @$internal
  @override
  $ProviderElement<BrewService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BrewService create(Ref ref) {
    return brewService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrewService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrewService>(value),
    );
  }
}

String _$brewServiceHash() => r'aa1487c7bf80333253703e58cbb368c98397ad5e';

/// System tray service, wired to the process manager.

@ProviderFor(trayService)
final trayServiceProvider = TrayServiceProvider._();

/// System tray service, wired to the process manager.

final class TrayServiceProvider
    extends $FunctionalProvider<TrayService, TrayService, TrayService>
    with $Provider<TrayService> {
  /// System tray service, wired to the process manager.
  TrayServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'trayServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$trayServiceHash();

  @$internal
  @override
  $ProviderElement<TrayService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TrayService create(Ref ref) {
    return trayService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrayService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrayService>(value),
    );
  }
}

String _$trayServiceHash() => r'12b936d5a0d61baa8b474020f1c1910eab2ea8c8';
