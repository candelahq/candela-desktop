//
//  Generated code. Do not modify.
//  source: bq_table.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// If set will output the schema file order based on the provided value.
class BigQueryMessageOptions_FieldOrder extends $pb.ProtobufEnum {
  static const BigQueryMessageOptions_FieldOrder FIELD_ORDER_UNSPECIFIED =
      BigQueryMessageOptions_FieldOrder._(
          0, _omitEnumNames ? '' : 'FIELD_ORDER_UNSPECIFIED');
  static const BigQueryMessageOptions_FieldOrder FIELD_ORDER_BY_NUMBER =
      BigQueryMessageOptions_FieldOrder._(
          1, _omitEnumNames ? '' : 'FIELD_ORDER_BY_NUMBER');

  static const $core.List<BigQueryMessageOptions_FieldOrder> values =
      <BigQueryMessageOptions_FieldOrder>[
    FIELD_ORDER_UNSPECIFIED,
    FIELD_ORDER_BY_NUMBER,
  ];

  static final $core.List<BigQueryMessageOptions_FieldOrder?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static BigQueryMessageOptions_FieldOrder? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BigQueryMessageOptions_FieldOrder._(super.v, super.n);
}

const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
