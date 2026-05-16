//
//  Generated code. Do not modify.
//  source: candela/types/annotation.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// AnnotationType categorizes the kind of post-hoc annotation.
class AnnotationType extends $pb.ProtobufEnum {
  static const AnnotationType ANNOTATION_TYPE_UNSPECIFIED =
      AnnotationType._(0, _omitEnumNames ? '' : 'ANNOTATION_TYPE_UNSPECIFIED');
  static const AnnotationType ANNOTATION_TYPE_OUTCOME =
      AnnotationType._(1, _omitEnumNames ? '' : 'ANNOTATION_TYPE_OUTCOME');
  static const AnnotationType ANNOTATION_TYPE_LABEL =
      AnnotationType._(2, _omitEnumNames ? '' : 'ANNOTATION_TYPE_LABEL');
  static const AnnotationType ANNOTATION_TYPE_METRIC =
      AnnotationType._(3, _omitEnumNames ? '' : 'ANNOTATION_TYPE_METRIC');

  static const $core.List<AnnotationType> values = <AnnotationType>[
    ANNOTATION_TYPE_UNSPECIFIED,
    ANNOTATION_TYPE_OUTCOME,
    ANNOTATION_TYPE_LABEL,
    ANNOTATION_TYPE_METRIC,
  ];

  static final $core.List<AnnotationType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AnnotationType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AnnotationType._(super.v, super.n);
}

const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
