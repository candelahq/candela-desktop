// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages local processes: configured runtime backend + Candela Proxy.
///
/// Exposed state is immutable [ProcessManagerState]. OS process handles,
/// health timers, and the HTTP client are internal implementation details.

@ProviderFor(ProcessManagerNotifier)
final processManagerProvider = ProcessManagerNotifierProvider._();

/// Manages local processes: configured runtime backend + Candela Proxy.
///
/// Exposed state is immutable [ProcessManagerState]. OS process handles,
/// health timers, and the HTTP client are internal implementation details.
final class ProcessManagerNotifierProvider
    extends $NotifierProvider<ProcessManagerNotifier, ProcessManagerState> {
  /// Manages local processes: configured runtime backend + Candela Proxy.
  ///
  /// Exposed state is immutable [ProcessManagerState]. OS process handles,
  /// health timers, and the HTTP client are internal implementation details.
  ProcessManagerNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$processManagerNotifierHash();

  @$internal
  @override
  ProcessManagerNotifier create() => ProcessManagerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProcessManagerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProcessManagerState>(value),
    );
  }
}

String _$processManagerNotifierHash() =>
    r'8961c59c3e781c31ab74122e56b81688df6e050e';

/// Manages local processes: configured runtime backend + Candela Proxy.
///
/// Exposed state is immutable [ProcessManagerState]. OS process handles,
/// health timers, and the HTTP client are internal implementation details.

abstract class _$ProcessManagerNotifier extends $Notifier<ProcessManagerState> {
  ProcessManagerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ProcessManagerState, ProcessManagerState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ProcessManagerState, ProcessManagerState>,
        ProcessManagerState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
