//
//  Generated code. Do not modify.
//  source: candela/types/trace.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// SpanKind categorizes the type of operation a span represents.
class SpanKind extends $pb.ProtobufEnum {
  static const SpanKind SPAN_KIND_UNSPECIFIED =
      SpanKind._(0, _omitEnumNames ? '' : 'SPAN_KIND_UNSPECIFIED');
  static const SpanKind SPAN_KIND_LLM =
      SpanKind._(1, _omitEnumNames ? '' : 'SPAN_KIND_LLM');
  static const SpanKind SPAN_KIND_AGENT =
      SpanKind._(2, _omitEnumNames ? '' : 'SPAN_KIND_AGENT');
  static const SpanKind SPAN_KIND_TOOL =
      SpanKind._(3, _omitEnumNames ? '' : 'SPAN_KIND_TOOL');
  static const SpanKind SPAN_KIND_RETRIEVAL =
      SpanKind._(4, _omitEnumNames ? '' : 'SPAN_KIND_RETRIEVAL');
  static const SpanKind SPAN_KIND_EMBEDDING =
      SpanKind._(5, _omitEnumNames ? '' : 'SPAN_KIND_EMBEDDING');
  static const SpanKind SPAN_KIND_CHAIN =
      SpanKind._(6, _omitEnumNames ? '' : 'SPAN_KIND_CHAIN');
  static const SpanKind SPAN_KIND_GENERAL =
      SpanKind._(7, _omitEnumNames ? '' : 'SPAN_KIND_GENERAL');

  static const $core.List<SpanKind> values = <SpanKind>[
    SPAN_KIND_UNSPECIFIED,
    SPAN_KIND_LLM,
    SPAN_KIND_AGENT,
    SPAN_KIND_TOOL,
    SPAN_KIND_RETRIEVAL,
    SPAN_KIND_EMBEDDING,
    SPAN_KIND_CHAIN,
    SPAN_KIND_GENERAL,
  ];

  static final $core.List<SpanKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static SpanKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SpanKind._(super.v, super.n);
}

/// SpanStatus represents the outcome of a span.
class SpanStatus extends $pb.ProtobufEnum {
  static const SpanStatus SPAN_STATUS_UNSPECIFIED =
      SpanStatus._(0, _omitEnumNames ? '' : 'SPAN_STATUS_UNSPECIFIED');
  static const SpanStatus SPAN_STATUS_OK =
      SpanStatus._(1, _omitEnumNames ? '' : 'SPAN_STATUS_OK');
  static const SpanStatus SPAN_STATUS_ERROR =
      SpanStatus._(2, _omitEnumNames ? '' : 'SPAN_STATUS_ERROR');

  static const $core.List<SpanStatus> values = <SpanStatus>[
    SPAN_STATUS_UNSPECIFIED,
    SPAN_STATUS_OK,
    SPAN_STATUS_ERROR,
  ];

  static final $core.List<SpanStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SpanStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SpanStatus._(super.v, super.n);
}

const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
