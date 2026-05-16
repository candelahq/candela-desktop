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

import 'bq_table.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'bq_table.pbenum.dart';

class BigQueryMessageOptions extends $pb.GeneratedMessage {
  factory BigQueryMessageOptions({
    $core.String? tableName,
    $core.bool? useJsonNames,
    $core.Iterable<$core.String>? extraFields,
    BigQueryMessageOptions_FieldOrder? outputFieldOrder,
  }) {
    final $result = create();
    if (tableName != null) {
      $result.tableName = tableName;
    }
    if (useJsonNames != null) {
      $result.useJsonNames = useJsonNames;
    }
    if (extraFields != null) {
      $result.extraFields.addAll(extraFields);
    }
    if (outputFieldOrder != null) {
      $result.outputFieldOrder = outputFieldOrder;
    }
    return $result;
  }
  BigQueryMessageOptions._() : super();
  factory BigQueryMessageOptions.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BigQueryMessageOptions.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BigQueryMessageOptions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gen_bq_schema'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tableName')
    ..aOB(2, _omitFieldNames ? '' : 'useJsonNames')
    ..pPS(3, _omitFieldNames ? '' : 'extraFields')
    ..e<BigQueryMessageOptions_FieldOrder>(
        4, _omitFieldNames ? '' : 'outputFieldOrder', $pb.PbFieldType.OE,
        defaultOrMaker:
            BigQueryMessageOptions_FieldOrder.FIELD_ORDER_UNSPECIFIED,
        valueOf: BigQueryMessageOptions_FieldOrder.valueOf,
        enumValues: BigQueryMessageOptions_FieldOrder.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BigQueryMessageOptions clone() =>
      BigQueryMessageOptions()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BigQueryMessageOptions copyWith(
          void Function(BigQueryMessageOptions) updates) =>
      super.copyWith((message) => updates(message as BigQueryMessageOptions))
          as BigQueryMessageOptions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BigQueryMessageOptions create() => BigQueryMessageOptions._();
  BigQueryMessageOptions createEmptyInstance() => create();
  static $pb.PbList<BigQueryMessageOptions> createRepeated() =>
      $pb.PbList<BigQueryMessageOptions>();
  @$core.pragma('dart2js:noInline')
  static BigQueryMessageOptions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BigQueryMessageOptions>(create);
  static BigQueryMessageOptions? _defaultInstance;

  /// Specifies a name of table in BigQuery for the message.
  ///
  /// If not blank, indicates the message is a type of record to be stored into BigQuery.
  @$pb.TagNumber(1)
  $core.String get tableName => $_getSZ(0);
  @$pb.TagNumber(1)
  set tableName($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTableName() => $_has(0);
  @$pb.TagNumber(1)
  void clearTableName() => $_clearField(1);

  /// If true, BigQuery field names will default to a field's JSON name,
  /// not its original/proto field name.
  @$pb.TagNumber(2)
  $core.bool get useJsonNames => $_getBF(1);
  @$pb.TagNumber(2)
  set useJsonNames($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUseJsonNames() => $_has(1);
  @$pb.TagNumber(2)
  void clearUseJsonNames() => $_clearField(2);

  /// If set, adds defined extra fields to a JSON representation of the message.
  /// Value format: "<field name>:<BigQuery field type>" for basic types
  /// or "<field name>:RECORD:<protobuf type>" for message types.
  /// "NULLABLE" by default, different mode may be set via optional suffix ":<mode>"
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get extraFields => $_getList(2);

  @$pb.TagNumber(4)
  BigQueryMessageOptions_FieldOrder get outputFieldOrder => $_getN(3);
  @$pb.TagNumber(4)
  set outputFieldOrder(BigQueryMessageOptions_FieldOrder v) {
    $_setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasOutputFieldOrder() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutputFieldOrder() => $_clearField(4);
}

class Bq_table {
  static final bigqueryOpts = $pb.Extension<BigQueryMessageOptions>(
      _omitMessageNames ? '' : 'google.protobuf.MessageOptions',
      _omitFieldNames ? '' : 'bigqueryOpts',
      1021,
      $pb.PbFieldType.OM,
      defaultOrMaker: BigQueryMessageOptions.getDefault,
      subBuilder: BigQueryMessageOptions.create);
  static void registerAllExtensions($pb.ExtensionRegistry registry) {
    registry.add(bigqueryOpts);
  }
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
