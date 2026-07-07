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

/// Shared dashboard state — the single source of truth for telemetry data.
///
/// Both DashboardScreen and TodayScreen consume this provider instead of each
/// maintaining their own [TelemetryService] and 30-second timer. This cuts
/// BigQuery queries by 50% and enables TTL-based caching + visibility-aware
/// polling.
///
/// The notifier is lazily configured on first read using the current config,
/// then re-configured automatically when the config file changes.
///
/// Usage:
///   final state = ref.watch(dashboardProvider);  // DashboardState
///   ref.read(dashboardProvider.notifier).fetch(); // methods

@ProviderFor(DashboardNotifier)
final dashboardProvider = DashboardNotifierProvider._();

/// Shared dashboard state — the single source of truth for telemetry data.
///
/// Both DashboardScreen and TodayScreen consume this provider instead of each
/// maintaining their own [TelemetryService] and 30-second timer. This cuts
/// BigQuery queries by 50% and enables TTL-based caching + visibility-aware
/// polling.
///
/// The notifier is lazily configured on first read using the current config,
/// then re-configured automatically when the config file changes.
///
/// Usage:
///   final state = ref.watch(dashboardProvider);  // DashboardState
///   ref.read(dashboardProvider.notifier).fetch(); // methods
final class DashboardNotifierProvider extends $NotifierProvider<
    DashboardNotifier, dashboard_notifier.DashboardState> {
  /// Shared dashboard state — the single source of truth for telemetry data.
  ///
  /// Both DashboardScreen and TodayScreen consume this provider instead of each
  /// maintaining their own [TelemetryService] and 30-second timer. This cuts
  /// BigQuery queries by 50% and enables TTL-based caching + visibility-aware
  /// polling.
  ///
  /// The notifier is lazily configured on first read using the current config,
  /// then re-configured automatically when the config file changes.
  ///
  /// Usage:
  ///   final state = ref.watch(dashboardProvider);  // DashboardState
  ///   ref.read(dashboardProvider.notifier).fetch(); // methods
  DashboardNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dashboardProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dashboardNotifierHash();

  @$internal
  @override
  DashboardNotifier create() => DashboardNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(dashboard_notifier.DashboardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<dashboard_notifier.DashboardState>(value),
    );
  }
}

String _$dashboardNotifierHash() => r'ac01071e376c4692b3f07741661f93469fca8642';

/// Shared dashboard state — the single source of truth for telemetry data.
///
/// Both DashboardScreen and TodayScreen consume this provider instead of each
/// maintaining their own [TelemetryService] and 30-second timer. This cuts
/// BigQuery queries by 50% and enables TTL-based caching + visibility-aware
/// polling.
///
/// The notifier is lazily configured on first read using the current config,
/// then re-configured automatically when the config file changes.
///
/// Usage:
///   final state = ref.watch(dashboardProvider);  // DashboardState
///   ref.read(dashboardProvider.notifier).fetch(); // methods

abstract class _$DashboardNotifier
    extends $Notifier<dashboard_notifier.DashboardState> {
  dashboard_notifier.DashboardState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<dashboard_notifier.DashboardState,
        dashboard_notifier.DashboardState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<dashboard_notifier.DashboardState,
            dashboard_notifier.DashboardState>,
        dashboard_notifier.DashboardState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Shared catalog state — the single source of truth for the model catalog.
///
/// Lazily configured from the config stream, auto-fetches on init.
///
/// Usage:
///   final state = ref.watch(catalogProvider);          // CatalogState
///   ref.read(catalogProvider.notifier).fetch();        // methods
///   ref.read(catalogProvider.notifier).toggleEnabled(…);

@ProviderFor(CatalogNotifier)
final catalogProvider = CatalogNotifierProvider._();

/// Shared catalog state — the single source of truth for the model catalog.
///
/// Lazily configured from the config stream, auto-fetches on init.
///
/// Usage:
///   final state = ref.watch(catalogProvider);          // CatalogState
///   ref.read(catalogProvider.notifier).fetch();        // methods
///   ref.read(catalogProvider.notifier).toggleEnabled(…);
final class CatalogNotifierProvider
    extends $NotifierProvider<CatalogNotifier, catalog_notifier.CatalogState> {
  /// Shared catalog state — the single source of truth for the model catalog.
  ///
  /// Lazily configured from the config stream, auto-fetches on init.
  ///
  /// Usage:
  ///   final state = ref.watch(catalogProvider);          // CatalogState
  ///   ref.read(catalogProvider.notifier).fetch();        // methods
  ///   ref.read(catalogProvider.notifier).toggleEnabled(…);
  CatalogNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'catalogProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$catalogNotifierHash();

  @$internal
  @override
  CatalogNotifier create() => CatalogNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(catalog_notifier.CatalogState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<catalog_notifier.CatalogState>(value),
    );
  }
}

String _$catalogNotifierHash() => r'65bdc5552dd81fac83255021294a1f9e5f5a65cc';

/// Shared catalog state — the single source of truth for the model catalog.
///
/// Lazily configured from the config stream, auto-fetches on init.
///
/// Usage:
///   final state = ref.watch(catalogProvider);          // CatalogState
///   ref.read(catalogProvider.notifier).fetch();        // methods
///   ref.read(catalogProvider.notifier).toggleEnabled(…);

abstract class _$CatalogNotifier
    extends $Notifier<catalog_notifier.CatalogState> {
  catalog_notifier.CatalogState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<catalog_notifier.CatalogState, catalog_notifier.CatalogState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<catalog_notifier.CatalogState,
            catalog_notifier.CatalogState>,
        catalog_notifier.CatalogState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Auto-configures the ProcessManagerNotifier when config changes.

@ProviderFor(processManagerSetup)
final processManagerSetupProvider = ProcessManagerSetupProvider._();

/// Auto-configures the ProcessManagerNotifier when config changes.

final class ProcessManagerSetupProvider
    extends $FunctionalProvider<void, void, void> with $Provider<void> {
  /// Auto-configures the ProcessManagerNotifier when config changes.
  ProcessManagerSetupProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'processManagerSetupProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$processManagerSetupHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return processManagerSetup(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$processManagerSetupHash() =>
    r'cf9ca3908064cb42ce0aa02ececd41a530e9075a';

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

/// System tray service, wired to the process manager notifier.

@ProviderFor(trayService)
final trayServiceProvider = TrayServiceProvider._();

/// System tray service, wired to the process manager notifier.

final class TrayServiceProvider
    extends $FunctionalProvider<TrayService, TrayService, TrayService>
    with $Provider<TrayService> {
  /// System tray service, wired to the process manager notifier.
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

String _$trayServiceHash() => r'f0ed9a9f44a59dc2ed14e488da6523122bf7ac82';
