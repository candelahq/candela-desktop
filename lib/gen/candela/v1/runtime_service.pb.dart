//
//  Generated code. Do not modify.
//  source: candela/v1/runtime_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $2;
import 'runtime_service.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'runtime_service.pbenum.dart';

/// RuntimeStatus describes the current state of a runtime server.
class RuntimeStatus extends $pb.GeneratedMessage {
  factory RuntimeStatus({
    RuntimeState? state,
    $core.String? backend,
    $core.String? endpoint,
    $core.double? uptimeSeconds,
    $core.String? error,
    $2.Timestamp? checkedAt,
  }) {
    final $result = create();
    if (state != null) {
      $result.state = state;
    }
    if (backend != null) {
      $result.backend = backend;
    }
    if (endpoint != null) {
      $result.endpoint = endpoint;
    }
    if (uptimeSeconds != null) {
      $result.uptimeSeconds = uptimeSeconds;
    }
    if (error != null) {
      $result.error = error;
    }
    if (checkedAt != null) {
      $result.checkedAt = checkedAt;
    }
    return $result;
  }
  RuntimeStatus._() : super();
  factory RuntimeStatus.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RuntimeStatus.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..e<RuntimeState>(1, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE,
        defaultOrMaker: RuntimeState.RUNTIME_STATE_UNSPECIFIED,
        valueOf: RuntimeState.valueOf,
        enumValues: RuntimeState.values)
    ..aOS(2, _omitFieldNames ? '' : 'backend')
    ..aOS(3, _omitFieldNames ? '' : 'endpoint')
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'uptimeSeconds', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'error')
    ..aOM<$2.Timestamp>(6, _omitFieldNames ? '' : 'checkedAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeStatus clone() => RuntimeStatus()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeStatus copyWith(void Function(RuntimeStatus) updates) =>
      super.copyWith((message) => updates(message as RuntimeStatus))
          as RuntimeStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RuntimeStatus create() => RuntimeStatus._();
  RuntimeStatus createEmptyInstance() => create();
  static $pb.PbList<RuntimeStatus> createRepeated() =>
      $pb.PbList<RuntimeStatus>();
  @$core.pragma('dart2js:noInline')
  static RuntimeStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuntimeStatus>(create);
  static RuntimeStatus? _defaultInstance;

  /// Current lifecycle state.
  @$pb.TagNumber(1)
  RuntimeState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(RuntimeState v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  /// Backend name: "ollama", "vllm", "lmstudio".
  @$pb.TagNumber(2)
  $core.String get backend => $_getSZ(1);
  @$pb.TagNumber(2)
  set backend($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasBackend() => $_has(1);
  @$pb.TagNumber(2)
  void clearBackend() => $_clearField(2);

  /// OpenAI-compatible API endpoint (e.g. "http://127.0.0.1:11434/v1").
  @$pb.TagNumber(3)
  $core.String get endpoint => $_getSZ(2);
  @$pb.TagNumber(3)
  set endpoint($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasEndpoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndpoint() => $_clearField(3);

  /// Seconds since the runtime was started.
  @$pb.TagNumber(4)
  $core.double get uptimeSeconds => $_getN(3);
  @$pb.TagNumber(4)
  set uptimeSeconds($core.double v) {
    $_setDouble(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasUptimeSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearUptimeSeconds() => $_clearField(4);

  /// Error message if state is RUNTIME_STATE_ERROR.
  @$pb.TagNumber(5)
  $core.String get error => $_getSZ(4);
  @$pb.TagNumber(5)
  set error($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasError() => $_has(4);
  @$pb.TagNumber(5)
  void clearError() => $_clearField(5);

  /// When the health check was last performed.
  @$pb.TagNumber(6)
  $2.Timestamp get checkedAt => $_getN(5);
  @$pb.TagNumber(6)
  set checkedAt($2.Timestamp v) {
    $_setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasCheckedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCheckedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureCheckedAt() => $_ensure(5);
}

/// RuntimeModel describes a model in the runtime.
class RuntimeModel extends $pb.GeneratedMessage {
  factory RuntimeModel({
    $core.String? id,
    $fixnum.Int64? sizeBytes,
    $core.String? family,
    $core.String? parameters,
    $core.String? quantization,
    $core.bool? loaded,
    $core.bool? available,
    $2.Timestamp? lastUsed,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (sizeBytes != null) {
      $result.sizeBytes = sizeBytes;
    }
    if (family != null) {
      $result.family = family;
    }
    if (parameters != null) {
      $result.parameters = parameters;
    }
    if (quantization != null) {
      $result.quantization = quantization;
    }
    if (loaded != null) {
      $result.loaded = loaded;
    }
    if (available != null) {
      $result.available = available;
    }
    if (lastUsed != null) {
      $result.lastUsed = lastUsed;
    }
    return $result;
  }
  RuntimeModel._() : super();
  factory RuntimeModel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RuntimeModel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeModel',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'sizeBytes')
    ..aOS(3, _omitFieldNames ? '' : 'family')
    ..aOS(4, _omitFieldNames ? '' : 'parameters')
    ..aOS(5, _omitFieldNames ? '' : 'quantization')
    ..aOB(6, _omitFieldNames ? '' : 'loaded')
    ..aOB(7, _omitFieldNames ? '' : 'available')
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'lastUsed',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeModel clone() => RuntimeModel()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeModel copyWith(void Function(RuntimeModel) updates) =>
      super.copyWith((message) => updates(message as RuntimeModel))
          as RuntimeModel;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RuntimeModel create() => RuntimeModel._();
  RuntimeModel createEmptyInstance() => create();
  static $pb.PbList<RuntimeModel> createRepeated() =>
      $pb.PbList<RuntimeModel>();
  @$core.pragma('dart2js:noInline')
  static RuntimeModel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuntimeModel>(create);
  static RuntimeModel? _defaultInstance;

  /// Model identifier (e.g. "llama3.2:8b").
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Size of the model files on disk.
  @$pb.TagNumber(2)
  $fixnum.Int64 get sizeBytes => $_getI64(1);
  @$pb.TagNumber(2)
  set sizeBytes($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSizeBytes() => $_has(1);
  @$pb.TagNumber(2)
  void clearSizeBytes() => $_clearField(2);

  /// Model family (e.g. "llama", "codellama").
  @$pb.TagNumber(3)
  $core.String get family => $_getSZ(2);
  @$pb.TagNumber(3)
  set family($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasFamily() => $_has(2);
  @$pb.TagNumber(3)
  void clearFamily() => $_clearField(3);

  /// Parameter count description (e.g. "8B").
  @$pb.TagNumber(4)
  $core.String get parameters => $_getSZ(3);
  @$pb.TagNumber(4)
  set parameters($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasParameters() => $_has(3);
  @$pb.TagNumber(4)
  void clearParameters() => $_clearField(4);

  /// Quantization format (e.g. "Q4_K_M").
  @$pb.TagNumber(5)
  $core.String get quantization => $_getSZ(4);
  @$pb.TagNumber(5)
  set quantization($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasQuantization() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantization() => $_clearField(5);

  /// True if the model is currently loaded in GPU memory.
  @$pb.TagNumber(6)
  $core.bool get loaded => $_getBF(5);
  @$pb.TagNumber(6)
  set loaded($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasLoaded() => $_has(5);
  @$pb.TagNumber(6)
  void clearLoaded() => $_clearField(6);

  /// True if the model is on disk and available to load.
  @$pb.TagNumber(7)
  $core.bool get available => $_getBF(6);
  @$pb.TagNumber(7)
  set available($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasAvailable() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvailable() => $_clearField(7);

  /// When the model was last used for inference.
  @$pb.TagNumber(8)
  $2.Timestamp get lastUsed => $_getN(7);
  @$pb.TagNumber(8)
  set lastUsed($2.Timestamp v) {
    $_setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasLastUsed() => $_has(7);
  @$pb.TagNumber(8)
  void clearLastUsed() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureLastUsed() => $_ensure(7);
}

/// BackendInfo describes a runtime backend and its install status.
class BackendInfo extends $pb.GeneratedMessage {
  factory BackendInfo({
    $core.String? name,
    $core.bool? installed,
    $core.String? binaryPath,
    $core.String? installHint,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (installed != null) {
      $result.installed = installed;
    }
    if (binaryPath != null) {
      $result.binaryPath = binaryPath;
    }
    if (installHint != null) {
      $result.installHint = installHint;
    }
    return $result;
  }
  BackendInfo._() : super();
  factory BackendInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BackendInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackendInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOB(2, _omitFieldNames ? '' : 'installed')
    ..aOS(3, _omitFieldNames ? '' : 'binaryPath')
    ..aOS(4, _omitFieldNames ? '' : 'installHint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackendInfo clone() => BackendInfo()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackendInfo copyWith(void Function(BackendInfo) updates) =>
      super.copyWith((message) => updates(message as BackendInfo))
          as BackendInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackendInfo create() => BackendInfo._();
  BackendInfo createEmptyInstance() => create();
  static $pb.PbList<BackendInfo> createRepeated() => $pb.PbList<BackendInfo>();
  @$core.pragma('dart2js:noInline')
  static BackendInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackendInfo>(create);
  static BackendInfo? _defaultInstance;

  /// Backend name (e.g. "ollama").
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// Whether the binary was found on PATH.
  @$pb.TagNumber(2)
  $core.bool get installed => $_getBF(1);
  @$pb.TagNumber(2)
  set installed($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasInstalled() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstalled() => $_clearField(2);

  /// Absolute path to the binary (if installed).
  @$pb.TagNumber(3)
  $core.String get binaryPath => $_getSZ(2);
  @$pb.TagNumber(3)
  set binaryPath($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasBinaryPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearBinaryPath() => $_clearField(3);

  /// Human-readable install hint (e.g. "brew install ollama").
  @$pb.TagNumber(4)
  $core.String get installHint => $_getSZ(3);
  @$pb.TagNumber(4)
  set installHint($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasInstallHint() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstallHint() => $_clearField(4);
}

class StartRuntimeRequest extends $pb.GeneratedMessage {
  factory StartRuntimeRequest({
    $core.String? backend,
  }) {
    final $result = create();
    if (backend != null) {
      $result.backend = backend;
    }
    return $result;
  }
  StartRuntimeRequest._() : super();
  factory StartRuntimeRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory StartRuntimeRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartRuntimeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'backend')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartRuntimeRequest clone() => StartRuntimeRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartRuntimeRequest copyWith(void Function(StartRuntimeRequest) updates) =>
      super.copyWith((message) => updates(message as StartRuntimeRequest))
          as StartRuntimeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartRuntimeRequest create() => StartRuntimeRequest._();
  StartRuntimeRequest createEmptyInstance() => create();
  static $pb.PbList<StartRuntimeRequest> createRepeated() =>
      $pb.PbList<StartRuntimeRequest>();
  @$core.pragma('dart2js:noInline')
  static StartRuntimeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartRuntimeRequest>(create);
  static StartRuntimeRequest? _defaultInstance;

  /// Optional backend override. If empty, uses the configured runtime_backend.
  /// If different from the current backend, the current one is stopped first.
  @$pb.TagNumber(1)
  $core.String get backend => $_getSZ(0);
  @$pb.TagNumber(1)
  set backend($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBackend() => $_has(0);
  @$pb.TagNumber(1)
  void clearBackend() => $_clearField(1);
}

class StartRuntimeResponse extends $pb.GeneratedMessage {
  factory StartRuntimeResponse({
    RuntimeStatus? status,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  StartRuntimeResponse._() : super();
  factory StartRuntimeResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory StartRuntimeResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartRuntimeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<RuntimeStatus>(1, _omitFieldNames ? '' : 'status',
        subBuilder: RuntimeStatus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartRuntimeResponse clone() =>
      StartRuntimeResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartRuntimeResponse copyWith(void Function(StartRuntimeResponse) updates) =>
      super.copyWith((message) => updates(message as StartRuntimeResponse))
          as StartRuntimeResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartRuntimeResponse create() => StartRuntimeResponse._();
  StartRuntimeResponse createEmptyInstance() => create();
  static $pb.PbList<StartRuntimeResponse> createRepeated() =>
      $pb.PbList<StartRuntimeResponse>();
  @$core.pragma('dart2js:noInline')
  static StartRuntimeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartRuntimeResponse>(create);
  static StartRuntimeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RuntimeStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(RuntimeStatus v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  RuntimeStatus ensureStatus() => $_ensure(0);
}

class StopRuntimeRequest extends $pb.GeneratedMessage {
  factory StopRuntimeRequest() => create();
  StopRuntimeRequest._() : super();
  factory StopRuntimeRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory StopRuntimeRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopRuntimeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopRuntimeRequest clone() => StopRuntimeRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopRuntimeRequest copyWith(void Function(StopRuntimeRequest) updates) =>
      super.copyWith((message) => updates(message as StopRuntimeRequest))
          as StopRuntimeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopRuntimeRequest create() => StopRuntimeRequest._();
  StopRuntimeRequest createEmptyInstance() => create();
  static $pb.PbList<StopRuntimeRequest> createRepeated() =>
      $pb.PbList<StopRuntimeRequest>();
  @$core.pragma('dart2js:noInline')
  static StopRuntimeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopRuntimeRequest>(create);
  static StopRuntimeRequest? _defaultInstance;
}

class StopRuntimeResponse extends $pb.GeneratedMessage {
  factory StopRuntimeResponse({
    RuntimeStatus? status,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  StopRuntimeResponse._() : super();
  factory StopRuntimeResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory StopRuntimeResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopRuntimeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<RuntimeStatus>(1, _omitFieldNames ? '' : 'status',
        subBuilder: RuntimeStatus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopRuntimeResponse clone() => StopRuntimeResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopRuntimeResponse copyWith(void Function(StopRuntimeResponse) updates) =>
      super.copyWith((message) => updates(message as StopRuntimeResponse))
          as StopRuntimeResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopRuntimeResponse create() => StopRuntimeResponse._();
  StopRuntimeResponse createEmptyInstance() => create();
  static $pb.PbList<StopRuntimeResponse> createRepeated() =>
      $pb.PbList<StopRuntimeResponse>();
  @$core.pragma('dart2js:noInline')
  static StopRuntimeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopRuntimeResponse>(create);
  static StopRuntimeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RuntimeStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(RuntimeStatus v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  RuntimeStatus ensureStatus() => $_ensure(0);
}

class GetHealthRequest extends $pb.GeneratedMessage {
  factory GetHealthRequest() => create();
  GetHealthRequest._() : super();
  factory GetHealthRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetHealthRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHealthRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthRequest clone() => GetHealthRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthRequest copyWith(void Function(GetHealthRequest) updates) =>
      super.copyWith((message) => updates(message as GetHealthRequest))
          as GetHealthRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHealthRequest create() => GetHealthRequest._();
  GetHealthRequest createEmptyInstance() => create();
  static $pb.PbList<GetHealthRequest> createRepeated() =>
      $pb.PbList<GetHealthRequest>();
  @$core.pragma('dart2js:noInline')
  static GetHealthRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHealthRequest>(create);
  static GetHealthRequest? _defaultInstance;
}

class GetHealthResponse extends $pb.GeneratedMessage {
  factory GetHealthResponse({
    RuntimeStatus? status,
    $core.Iterable<RuntimeModel>? models,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (models != null) {
      $result.models.addAll(models);
    }
    return $result;
  }
  GetHealthResponse._() : super();
  factory GetHealthResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetHealthResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHealthResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<RuntimeStatus>(1, _omitFieldNames ? '' : 'status',
        subBuilder: RuntimeStatus.create)
    ..pc<RuntimeModel>(2, _omitFieldNames ? '' : 'models', $pb.PbFieldType.PM,
        subBuilder: RuntimeModel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthResponse clone() => GetHealthResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthResponse copyWith(void Function(GetHealthResponse) updates) =>
      super.copyWith((message) => updates(message as GetHealthResponse))
          as GetHealthResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHealthResponse create() => GetHealthResponse._();
  GetHealthResponse createEmptyInstance() => create();
  static $pb.PbList<GetHealthResponse> createRepeated() =>
      $pb.PbList<GetHealthResponse>();
  @$core.pragma('dart2js:noInline')
  static GetHealthResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHealthResponse>(create);
  static GetHealthResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RuntimeStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(RuntimeStatus v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  RuntimeStatus ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<RuntimeModel> get models => $_getList(1);
}

class LoadModelRequest extends $pb.GeneratedMessage {
  factory LoadModelRequest({
    $core.String? model,
  }) {
    final $result = create();
    if (model != null) {
      $result.model = model;
    }
    return $result;
  }
  LoadModelRequest._() : super();
  factory LoadModelRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory LoadModelRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoadModelRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'model')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadModelRequest clone() => LoadModelRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadModelRequest copyWith(void Function(LoadModelRequest) updates) =>
      super.copyWith((message) => updates(message as LoadModelRequest))
          as LoadModelRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoadModelRequest create() => LoadModelRequest._();
  LoadModelRequest createEmptyInstance() => create();
  static $pb.PbList<LoadModelRequest> createRepeated() =>
      $pb.PbList<LoadModelRequest>();
  @$core.pragma('dart2js:noInline')
  static LoadModelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoadModelRequest>(create);
  static LoadModelRequest? _defaultInstance;

  /// Model to load into GPU memory (e.g. "llama3.2:8b").
  @$pb.TagNumber(1)
  $core.String get model => $_getSZ(0);
  @$pb.TagNumber(1)
  set model($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearModel() => $_clearField(1);
}

class LoadModelResponse extends $pb.GeneratedMessage {
  factory LoadModelResponse({
    ModelLoadState? state,
  }) {
    final $result = create();
    if (state != null) {
      $result.state = state;
    }
    return $result;
  }
  LoadModelResponse._() : super();
  factory LoadModelResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory LoadModelResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoadModelResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..e<ModelLoadState>(1, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE,
        defaultOrMaker: ModelLoadState.MODEL_LOAD_STATE_UNSPECIFIED,
        valueOf: ModelLoadState.valueOf,
        enumValues: ModelLoadState.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadModelResponse clone() => LoadModelResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadModelResponse copyWith(void Function(LoadModelResponse) updates) =>
      super.copyWith((message) => updates(message as LoadModelResponse))
          as LoadModelResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoadModelResponse create() => LoadModelResponse._();
  LoadModelResponse createEmptyInstance() => create();
  static $pb.PbList<LoadModelResponse> createRepeated() =>
      $pb.PbList<LoadModelResponse>();
  @$core.pragma('dart2js:noInline')
  static LoadModelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoadModelResponse>(create);
  static LoadModelResponse? _defaultInstance;

  /// Result of the load operation.
  @$pb.TagNumber(1)
  ModelLoadState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(ModelLoadState v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
}

class UnloadModelRequest extends $pb.GeneratedMessage {
  factory UnloadModelRequest({
    $core.String? model,
  }) {
    final $result = create();
    if (model != null) {
      $result.model = model;
    }
    return $result;
  }
  UnloadModelRequest._() : super();
  factory UnloadModelRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UnloadModelRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnloadModelRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'model')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnloadModelRequest clone() => UnloadModelRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnloadModelRequest copyWith(void Function(UnloadModelRequest) updates) =>
      super.copyWith((message) => updates(message as UnloadModelRequest))
          as UnloadModelRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnloadModelRequest create() => UnloadModelRequest._();
  UnloadModelRequest createEmptyInstance() => create();
  static $pb.PbList<UnloadModelRequest> createRepeated() =>
      $pb.PbList<UnloadModelRequest>();
  @$core.pragma('dart2js:noInline')
  static UnloadModelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnloadModelRequest>(create);
  static UnloadModelRequest? _defaultInstance;

  /// Model to remove from GPU memory.
  @$pb.TagNumber(1)
  $core.String get model => $_getSZ(0);
  @$pb.TagNumber(1)
  set model($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearModel() => $_clearField(1);
}

class UnloadModelResponse extends $pb.GeneratedMessage {
  factory UnloadModelResponse() => create();
  UnloadModelResponse._() : super();
  factory UnloadModelResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UnloadModelResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnloadModelResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnloadModelResponse clone() => UnloadModelResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnloadModelResponse copyWith(void Function(UnloadModelResponse) updates) =>
      super.copyWith((message) => updates(message as UnloadModelResponse))
          as UnloadModelResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnloadModelResponse create() => UnloadModelResponse._();
  UnloadModelResponse createEmptyInstance() => create();
  static $pb.PbList<UnloadModelResponse> createRepeated() =>
      $pb.PbList<UnloadModelResponse>();
  @$core.pragma('dart2js:noInline')
  static UnloadModelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnloadModelResponse>(create);
  static UnloadModelResponse? _defaultInstance;
}

class ListModelsRequest extends $pb.GeneratedMessage {
  factory ListModelsRequest() => create();
  ListModelsRequest._() : super();
  factory ListModelsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListModelsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListModelsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListModelsRequest clone() => ListModelsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListModelsRequest copyWith(void Function(ListModelsRequest) updates) =>
      super.copyWith((message) => updates(message as ListModelsRequest))
          as ListModelsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListModelsRequest create() => ListModelsRequest._();
  ListModelsRequest createEmptyInstance() => create();
  static $pb.PbList<ListModelsRequest> createRepeated() =>
      $pb.PbList<ListModelsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListModelsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListModelsRequest>(create);
  static ListModelsRequest? _defaultInstance;
}

class ListModelsResponse extends $pb.GeneratedMessage {
  factory ListModelsResponse({
    $core.Iterable<RuntimeModel>? models,
  }) {
    final $result = create();
    if (models != null) {
      $result.models.addAll(models);
    }
    return $result;
  }
  ListModelsResponse._() : super();
  factory ListModelsResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListModelsResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListModelsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<RuntimeModel>(1, _omitFieldNames ? '' : 'models', $pb.PbFieldType.PM,
        subBuilder: RuntimeModel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListModelsResponse clone() => ListModelsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListModelsResponse copyWith(void Function(ListModelsResponse) updates) =>
      super.copyWith((message) => updates(message as ListModelsResponse))
          as ListModelsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListModelsResponse create() => ListModelsResponse._();
  ListModelsResponse createEmptyInstance() => create();
  static $pb.PbList<ListModelsResponse> createRepeated() =>
      $pb.PbList<ListModelsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListModelsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListModelsResponse>(create);
  static ListModelsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RuntimeModel> get models => $_getList(0);
}

class PullModelRequest extends $pb.GeneratedMessage {
  factory PullModelRequest({
    $core.String? model,
  }) {
    final $result = create();
    if (model != null) {
      $result.model = model;
    }
    return $result;
  }
  PullModelRequest._() : super();
  factory PullModelRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PullModelRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PullModelRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'model')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullModelRequest clone() => PullModelRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullModelRequest copyWith(void Function(PullModelRequest) updates) =>
      super.copyWith((message) => updates(message as PullModelRequest))
          as PullModelRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PullModelRequest create() => PullModelRequest._();
  PullModelRequest createEmptyInstance() => create();
  static $pb.PbList<PullModelRequest> createRepeated() =>
      $pb.PbList<PullModelRequest>();
  @$core.pragma('dart2js:noInline')
  static PullModelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PullModelRequest>(create);
  static PullModelRequest? _defaultInstance;

  /// Model to download (e.g. "llama3.2:8b").
  @$pb.TagNumber(1)
  $core.String get model => $_getSZ(0);
  @$pb.TagNumber(1)
  set model($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearModel() => $_clearField(1);
}

class PullModelResponse extends $pb.GeneratedMessage {
  factory PullModelResponse() => create();
  PullModelResponse._() : super();
  factory PullModelResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PullModelResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PullModelResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullModelResponse clone() => PullModelResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullModelResponse copyWith(void Function(PullModelResponse) updates) =>
      super.copyWith((message) => updates(message as PullModelResponse))
          as PullModelResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PullModelResponse create() => PullModelResponse._();
  PullModelResponse createEmptyInstance() => create();
  static $pb.PbList<PullModelResponse> createRepeated() =>
      $pb.PbList<PullModelResponse>();
  @$core.pragma('dart2js:noInline')
  static PullModelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PullModelResponse>(create);
  static PullModelResponse? _defaultInstance;
}

class ListBackendsRequest extends $pb.GeneratedMessage {
  factory ListBackendsRequest() => create();
  ListBackendsRequest._() : super();
  factory ListBackendsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListBackendsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBackendsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBackendsRequest clone() => ListBackendsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBackendsRequest copyWith(void Function(ListBackendsRequest) updates) =>
      super.copyWith((message) => updates(message as ListBackendsRequest))
          as ListBackendsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBackendsRequest create() => ListBackendsRequest._();
  ListBackendsRequest createEmptyInstance() => create();
  static $pb.PbList<ListBackendsRequest> createRepeated() =>
      $pb.PbList<ListBackendsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListBackendsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBackendsRequest>(create);
  static ListBackendsRequest? _defaultInstance;
}

class ListBackendsResponse extends $pb.GeneratedMessage {
  factory ListBackendsResponse({
    $core.Iterable<BackendInfo>? backends,
    $core.String? active,
  }) {
    final $result = create();
    if (backends != null) {
      $result.backends.addAll(backends);
    }
    if (active != null) {
      $result.active = active;
    }
    return $result;
  }
  ListBackendsResponse._() : super();
  factory ListBackendsResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListBackendsResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBackendsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<BackendInfo>(1, _omitFieldNames ? '' : 'backends', $pb.PbFieldType.PM,
        subBuilder: BackendInfo.create)
    ..aOS(2, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBackendsResponse clone() =>
      ListBackendsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBackendsResponse copyWith(void Function(ListBackendsResponse) updates) =>
      super.copyWith((message) => updates(message as ListBackendsResponse))
          as ListBackendsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBackendsResponse create() => ListBackendsResponse._();
  ListBackendsResponse createEmptyInstance() => create();
  static $pb.PbList<ListBackendsResponse> createRepeated() =>
      $pb.PbList<ListBackendsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListBackendsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBackendsResponse>(create);
  static ListBackendsResponse? _defaultInstance;

  /// All known backends with install status.
  @$pb.TagNumber(1)
  $pb.PbList<BackendInfo> get backends => $_getList(0);

  /// Currently configured/active backend name.
  @$pb.TagNumber(2)
  $core.String get active => $_getSZ(1);
  @$pb.TagNumber(2)
  set active($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasActive() => $_has(1);
  @$pb.TagNumber(2)
  void clearActive() => $_clearField(2);
}

class ResetStateRequest extends $pb.GeneratedMessage {
  factory ResetStateRequest() => create();
  ResetStateRequest._() : super();
  factory ResetStateRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ResetStateRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetStateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetStateRequest clone() => ResetStateRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetStateRequest copyWith(void Function(ResetStateRequest) updates) =>
      super.copyWith((message) => updates(message as ResetStateRequest))
          as ResetStateRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetStateRequest create() => ResetStateRequest._();
  ResetStateRequest createEmptyInstance() => create();
  static $pb.PbList<ResetStateRequest> createRepeated() =>
      $pb.PbList<ResetStateRequest>();
  @$core.pragma('dart2js:noInline')
  static ResetStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResetStateRequest>(create);
  static ResetStateRequest? _defaultInstance;
}

class ResetStateResponse extends $pb.GeneratedMessage {
  factory ResetStateResponse() => create();
  ResetStateResponse._() : super();
  factory ResetStateResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ResetStateResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetStateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetStateResponse clone() => ResetStateResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetStateResponse copyWith(void Function(ResetStateResponse) updates) =>
      super.copyWith((message) => updates(message as ResetStateResponse))
          as ResetStateResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetStateResponse create() => ResetStateResponse._();
  ResetStateResponse createEmptyInstance() => create();
  static $pb.PbList<ResetStateResponse> createRepeated() =>
      $pb.PbList<ResetStateResponse>();
  @$core.pragma('dart2js:noInline')
  static ResetStateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResetStateResponse>(create);
  static ResetStateResponse? _defaultInstance;
}

class CancelPullRequest extends $pb.GeneratedMessage {
  factory CancelPullRequest({
    $core.String? model,
  }) {
    final $result = create();
    if (model != null) {
      $result.model = model;
    }
    return $result;
  }
  CancelPullRequest._() : super();
  factory CancelPullRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CancelPullRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelPullRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'model')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPullRequest clone() => CancelPullRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPullRequest copyWith(void Function(CancelPullRequest) updates) =>
      super.copyWith((message) => updates(message as CancelPullRequest))
          as CancelPullRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelPullRequest create() => CancelPullRequest._();
  CancelPullRequest createEmptyInstance() => create();
  static $pb.PbList<CancelPullRequest> createRepeated() =>
      $pb.PbList<CancelPullRequest>();
  @$core.pragma('dart2js:noInline')
  static CancelPullRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelPullRequest>(create);
  static CancelPullRequest? _defaultInstance;

  /// Model whose pull should be cancelled.
  @$pb.TagNumber(1)
  $core.String get model => $_getSZ(0);
  @$pb.TagNumber(1)
  set model($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearModel() => $_clearField(1);
}

class CancelPullResponse extends $pb.GeneratedMessage {
  factory CancelPullResponse() => create();
  CancelPullResponse._() : super();
  factory CancelPullResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CancelPullResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelPullResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPullResponse clone() => CancelPullResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPullResponse copyWith(void Function(CancelPullResponse) updates) =>
      super.copyWith((message) => updates(message as CancelPullResponse))
          as CancelPullResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelPullResponse create() => CancelPullResponse._();
  CancelPullResponse createEmptyInstance() => create();
  static $pb.PbList<CancelPullResponse> createRepeated() =>
      $pb.PbList<CancelPullResponse>();
  @$core.pragma('dart2js:noInline')
  static CancelPullResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelPullResponse>(create);
  static CancelPullResponse? _defaultInstance;
}

class DeleteModelRequest extends $pb.GeneratedMessage {
  factory DeleteModelRequest({
    $core.String? model,
  }) {
    final $result = create();
    if (model != null) {
      $result.model = model;
    }
    return $result;
  }
  DeleteModelRequest._() : super();
  factory DeleteModelRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeleteModelRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteModelRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'model')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteModelRequest clone() => DeleteModelRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteModelRequest copyWith(void Function(DeleteModelRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteModelRequest))
          as DeleteModelRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteModelRequest create() => DeleteModelRequest._();
  DeleteModelRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteModelRequest> createRepeated() =>
      $pb.PbList<DeleteModelRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteModelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteModelRequest>(create);
  static DeleteModelRequest? _defaultInstance;

  /// Model to delete from disk (e.g. "llama3.2:3b").
  @$pb.TagNumber(1)
  $core.String get model => $_getSZ(0);
  @$pb.TagNumber(1)
  set model($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearModel() => $_clearField(1);
}

class DeleteModelResponse extends $pb.GeneratedMessage {
  factory DeleteModelResponse() => create();
  DeleteModelResponse._() : super();
  factory DeleteModelResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeleteModelResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteModelResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteModelResponse clone() => DeleteModelResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteModelResponse copyWith(void Function(DeleteModelResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteModelResponse))
          as DeleteModelResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteModelResponse create() => DeleteModelResponse._();
  DeleteModelResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteModelResponse> createRepeated() =>
      $pb.PbList<DeleteModelResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteModelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteModelResponse>(create);
  static DeleteModelResponse? _defaultInstance;
}

/// CatalogModel describes a suggested model in the user's catalog.
class CatalogModel extends $pb.GeneratedMessage {
  factory CatalogModel({
    $core.String? id,
    $core.String? name,
    $core.String? description,
    $core.String? sizeHint,
    $core.bool? pinned,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (sizeHint != null) {
      $result.sizeHint = sizeHint;
    }
    if (pinned != null) {
      $result.pinned = pinned;
    }
    return $result;
  }
  CatalogModel._() : super();
  factory CatalogModel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CatalogModel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CatalogModel',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'sizeHint')
    ..aOB(5, _omitFieldNames ? '' : 'pinned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogModel clone() => CatalogModel()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogModel copyWith(void Function(CatalogModel) updates) =>
      super.copyWith((message) => updates(message as CatalogModel))
          as CatalogModel;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CatalogModel create() => CatalogModel._();
  CatalogModel createEmptyInstance() => create();
  static $pb.PbList<CatalogModel> createRepeated() =>
      $pb.PbList<CatalogModel>();
  @$core.pragma('dart2js:noInline')
  static CatalogModel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CatalogModel>(create);
  static CatalogModel? _defaultInstance;

  /// Model identifier (e.g. "llama3.2:3b").
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Display name.
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// Short description.
  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  /// Approximate download size (e.g. "2.0 GB").
  @$pb.TagNumber(4)
  $core.String get sizeHint => $_getSZ(3);
  @$pb.TagNumber(4)
  set sizeHint($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSizeHint() => $_has(3);
  @$pb.TagNumber(4)
  void clearSizeHint() => $_clearField(4);

  /// User-pinned favorite.
  @$pb.TagNumber(5)
  $core.bool get pinned => $_getBF(4);
  @$pb.TagNumber(5)
  set pinned($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPinned() => $_has(4);
  @$pb.TagNumber(5)
  void clearPinned() => $_clearField(5);
}

class ListCatalogRequest extends $pb.GeneratedMessage {
  factory ListCatalogRequest() => create();
  ListCatalogRequest._() : super();
  factory ListCatalogRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListCatalogRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCatalogRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCatalogRequest clone() => ListCatalogRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCatalogRequest copyWith(void Function(ListCatalogRequest) updates) =>
      super.copyWith((message) => updates(message as ListCatalogRequest))
          as ListCatalogRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCatalogRequest create() => ListCatalogRequest._();
  ListCatalogRequest createEmptyInstance() => create();
  static $pb.PbList<ListCatalogRequest> createRepeated() =>
      $pb.PbList<ListCatalogRequest>();
  @$core.pragma('dart2js:noInline')
  static ListCatalogRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCatalogRequest>(create);
  static ListCatalogRequest? _defaultInstance;
}

class ListCatalogResponse extends $pb.GeneratedMessage {
  factory ListCatalogResponse({
    $core.Iterable<CatalogModel>? models,
  }) {
    final $result = create();
    if (models != null) {
      $result.models.addAll(models);
    }
    return $result;
  }
  ListCatalogResponse._() : super();
  factory ListCatalogResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListCatalogResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCatalogResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<CatalogModel>(1, _omitFieldNames ? '' : 'models', $pb.PbFieldType.PM,
        subBuilder: CatalogModel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCatalogResponse clone() => ListCatalogResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCatalogResponse copyWith(void Function(ListCatalogResponse) updates) =>
      super.copyWith((message) => updates(message as ListCatalogResponse))
          as ListCatalogResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCatalogResponse create() => ListCatalogResponse._();
  ListCatalogResponse createEmptyInstance() => create();
  static $pb.PbList<ListCatalogResponse> createRepeated() =>
      $pb.PbList<ListCatalogResponse>();
  @$core.pragma('dart2js:noInline')
  static ListCatalogResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCatalogResponse>(create);
  static ListCatalogResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CatalogModel> get models => $_getList(0);
}

/// RuntimeService manages local LLM inference servers (Ollama, vLLM, LM Studio).
/// Used by the embedded management UI and future Flutter desktop client.
///
/// All RPCs operate on the locally configured runtime backend. The service
/// runs in candela-local and does not require the cloud backend.
class RuntimeServiceApi {
  $pb.RpcClient _client;
  RuntimeServiceApi(this._client);

  /// StartRuntime launches the configured runtime process.
  /// If already running, this is a no-op. If a backend override is provided,
  /// the current runtime is stopped and the new one is started.
  $async.Future<StartRuntimeResponse> startRuntime(
          $pb.ClientContext? ctx, StartRuntimeRequest request) =>
      _client.invoke<StartRuntimeResponse>(ctx, 'RuntimeService',
          'StartRuntime', request, StartRuntimeResponse());

  /// StopRuntime gracefully shuts down the running runtime process.
  $async.Future<StopRuntimeResponse> stopRuntime(
          $pb.ClientContext? ctx, StopRuntimeRequest request) =>
      _client.invoke<StopRuntimeResponse>(
          ctx, 'RuntimeService', 'StopRuntime', request, StopRuntimeResponse());

  /// GetHealth returns the cached health status and loaded models.
  $async.Future<GetHealthResponse> getHealth(
          $pb.ClientContext? ctx, GetHealthRequest request) =>
      _client.invoke<GetHealthResponse>(
          ctx, 'RuntimeService', 'GetHealth', request, GetHealthResponse());

  /// LoadModel loads a model into GPU memory. For vLLM this triggers a
  /// process restart (returns status "starting"). Poll GetHealth for readiness.
  $async.Future<LoadModelResponse> loadModel(
          $pb.ClientContext? ctx, LoadModelRequest request) =>
      _client.invoke<LoadModelResponse>(
          ctx, 'RuntimeService', 'LoadModel', request, LoadModelResponse());

  /// UnloadModel removes a model from GPU memory. For vLLM this stops the process.
  $async.Future<UnloadModelResponse> unloadModel(
          $pb.ClientContext? ctx, UnloadModelRequest request) =>
      _client.invoke<UnloadModelResponse>(
          ctx, 'RuntimeService', 'UnloadModel', request, UnloadModelResponse());

  /// ListModels returns all models available in the runtime (both loaded and on-disk).
  $async.Future<ListModelsResponse> listModels(
          $pb.ClientContext? ctx, ListModelsRequest request) =>
      _client.invoke<ListModelsResponse>(
          ctx, 'RuntimeService', 'ListModels', request, ListModelsResponse());

  /// PullModel starts an asynchronous model download. Returns immediately.
  /// Poll GetHealth or ListModels to see when the model appears.
  $async.Future<PullModelResponse> pullModel(
          $pb.ClientContext? ctx, PullModelRequest request) =>
      _client.invoke<PullModelResponse>(
          ctx, 'RuntimeService', 'PullModel', request, PullModelResponse());

  /// CancelPull cancels an in-flight model download.
  $async.Future<CancelPullResponse> cancelPull(
          $pb.ClientContext? ctx, CancelPullRequest request) =>
      _client.invoke<CancelPullResponse>(
          ctx, 'RuntimeService', 'CancelPull', request, CancelPullResponse());

  /// DeleteModel removes a model from disk. Only supported by Ollama.
  $async.Future<DeleteModelResponse> deleteModel(
          $pb.ClientContext? ctx, DeleteModelRequest request) =>
      _client.invoke<DeleteModelResponse>(
          ctx, 'RuntimeService', 'DeleteModel', request, DeleteModelResponse());

  /// ListBackends returns registered runtime backends and their install status.
  $async.Future<ListBackendsResponse> listBackends(
          $pb.ClientContext? ctx, ListBackendsRequest request) =>
      _client.invoke<ListBackendsResponse>(ctx, 'RuntimeService',
          'ListBackends', request, ListBackendsResponse());

  /// ResetState clears all local state (preferences, pull history) from the
  /// state database. The YAML config file is not affected.
  $async.Future<ResetStateResponse> resetState(
          $pb.ClientContext? ctx, ResetStateRequest request) =>
      _client.invoke<ResetStateResponse>(
          ctx, 'RuntimeService', 'ResetState', request, ResetStateResponse());

  /// ListCatalog returns the user's model catalog (suggested models to pull).
  $async.Future<ListCatalogResponse> listCatalog(
          $pb.ClientContext? ctx, ListCatalogRequest request) =>
      _client.invoke<ListCatalogResponse>(
          ctx, 'RuntimeService', 'ListCatalog', request, ListCatalogResponse());
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
