//
//  Generated code. Do not modify.
//  source: candela/v1/runtime_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// RuntimeState describes the lifecycle of a runtime server.
class RuntimeState extends $pb.ProtobufEnum {
  static const RuntimeState RUNTIME_STATE_UNSPECIFIED =
      RuntimeState._(0, _omitEnumNames ? '' : 'RUNTIME_STATE_UNSPECIFIED');
  static const RuntimeState RUNTIME_STATE_STOPPED =
      RuntimeState._(1, _omitEnumNames ? '' : 'RUNTIME_STATE_STOPPED');
  static const RuntimeState RUNTIME_STATE_STARTING =
      RuntimeState._(2, _omitEnumNames ? '' : 'RUNTIME_STATE_STARTING');
  static const RuntimeState RUNTIME_STATE_RUNNING =
      RuntimeState._(3, _omitEnumNames ? '' : 'RUNTIME_STATE_RUNNING');
  static const RuntimeState RUNTIME_STATE_ERROR =
      RuntimeState._(4, _omitEnumNames ? '' : 'RUNTIME_STATE_ERROR');

  static const $core.List<RuntimeState> values = <RuntimeState>[
    RUNTIME_STATE_UNSPECIFIED,
    RUNTIME_STATE_STOPPED,
    RUNTIME_STATE_STARTING,
    RUNTIME_STATE_RUNNING,
    RUNTIME_STATE_ERROR,
  ];

  static final $core.List<RuntimeState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RuntimeState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RuntimeState._(super.v, super.n);
}

/// ModelLoadState describes the result of a load/unload operation.
class ModelLoadState extends $pb.ProtobufEnum {
  static const ModelLoadState MODEL_LOAD_STATE_UNSPECIFIED =
      ModelLoadState._(0, _omitEnumNames ? '' : 'MODEL_LOAD_STATE_UNSPECIFIED');
  static const ModelLoadState MODEL_LOAD_STATE_LOADED =
      ModelLoadState._(1, _omitEnumNames ? '' : 'MODEL_LOAD_STATE_LOADED');
  static const ModelLoadState MODEL_LOAD_STATE_STARTING =
      ModelLoadState._(2, _omitEnumNames ? '' : 'MODEL_LOAD_STATE_STARTING');

  static const $core.List<ModelLoadState> values = <ModelLoadState>[
    MODEL_LOAD_STATE_UNSPECIFIED,
    MODEL_LOAD_STATE_LOADED,
    MODEL_LOAD_STATE_STARTING,
  ];

  static final $core.List<ModelLoadState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ModelLoadState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ModelLoadState._(super.v, super.n);
}

const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
