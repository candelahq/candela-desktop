//
//  Generated code. Do not modify.
//  source: bq_field.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Message containing options related to BigQuery schema generation
/// and management via Protobuf.
class BigQueryFieldOptions extends $pb.GeneratedMessage {
  factory BigQueryFieldOptions({
    $core.bool? require,
    $core.String? typeOverride,
    $core.bool? ignore,
    $core.String? description,
    $core.String? name,
    $core.String? policyTags,
    $core.String? defaultValueExpression,
  }) {
    final $result = create();
    if (require != null) {
      $result.require = require;
    }
    if (typeOverride != null) {
      $result.typeOverride = typeOverride;
    }
    if (ignore != null) {
      $result.ignore = ignore;
    }
    if (description != null) {
      $result.description = description;
    }
    if (name != null) {
      $result.name = name;
    }
    if (policyTags != null) {
      $result.policyTags = policyTags;
    }
    if (defaultValueExpression != null) {
      $result.defaultValueExpression = defaultValueExpression;
    }
    return $result;
  }
  BigQueryFieldOptions._() : super();
  factory BigQueryFieldOptions.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BigQueryFieldOptions.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BigQueryFieldOptions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gen_bq_schema'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'require')
    ..aOS(2, _omitFieldNames ? '' : 'typeOverride')
    ..aOB(3, _omitFieldNames ? '' : 'ignore')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..aOS(6, _omitFieldNames ? '' : 'policyTags')
    ..aOS(7, _omitFieldNames ? '' : 'defaultValueExpression')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BigQueryFieldOptions clone() =>
      BigQueryFieldOptions()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BigQueryFieldOptions copyWith(void Function(BigQueryFieldOptions) updates) =>
      super.copyWith((message) => updates(message as BigQueryFieldOptions))
          as BigQueryFieldOptions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BigQueryFieldOptions create() => BigQueryFieldOptions._();
  BigQueryFieldOptions createEmptyInstance() => create();
  static $pb.PbList<BigQueryFieldOptions> createRepeated() =>
      $pb.PbList<BigQueryFieldOptions>();
  @$core.pragma('dart2js:noInline')
  static BigQueryFieldOptions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BigQueryFieldOptions>(create);
  static BigQueryFieldOptions? _defaultInstance;

  /// Flag to specify that a field should be marked as 'REQUIRED' when
  /// used to generate schema for BigQuery.
  @$pb.TagNumber(1)
  $core.bool get require => $_getBF(0);
  @$pb.TagNumber(1)
  set require($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRequire() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequire() => $_clearField(1);

  /// Optionally override whatever type is resolved by the schema
  /// generator. This is useful, for example, to store epoch timestamps
  /// with the underlying 'TIMESTAMP' type, when normally, they would
  /// be structured as 'INTEGER' fields.
  @$pb.TagNumber(2)
  $core.String get typeOverride => $_getSZ(1);
  @$pb.TagNumber(2)
  set typeOverride($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTypeOverride() => $_has(1);
  @$pb.TagNumber(2)
  void clearTypeOverride() => $_clearField(2);

  /// Optionally omit a field from BigQuery schema.
  @$pb.TagNumber(3)
  $core.bool get ignore => $_getBF(2);
  @$pb.TagNumber(3)
  set ignore($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasIgnore() => $_has(2);
  @$pb.TagNumber(3)
  void clearIgnore() => $_clearField(3);

  /// Set the description for a field in BigQuery schema.
  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  /// Customize the name of the field in the BigQuery schema.
  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);

  /// Optionally add PolicyTag for a field in BigQuery schema.
  @$pb.TagNumber(6)
  $core.String get policyTags => $_getSZ(5);
  @$pb.TagNumber(6)
  set policyTags($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPolicyTags() => $_has(5);
  @$pb.TagNumber(6)
  void clearPolicyTags() => $_clearField(6);

  /// Optional default value.
  ///
  /// See https://cloud.google.com/bigquery/docs/default-values for possible
  /// values.
  @$pb.TagNumber(7)
  $core.String get defaultValueExpression => $_getSZ(6);
  @$pb.TagNumber(7)
  set defaultValueExpression($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasDefaultValueExpression() => $_has(6);
  @$pb.TagNumber(7)
  void clearDefaultValueExpression() => $_clearField(7);
}

class Bq_field {
  static final bigquery = $pb.Extension<BigQueryFieldOptions>(
      _omitMessageNames ? '' : 'google.protobuf.FieldOptions',
      _omitFieldNames ? '' : 'bigquery',
      1021,
      $pb.PbFieldType.OM,
      defaultOrMaker: BigQueryFieldOptions.getDefault,
      subBuilder: BigQueryFieldOptions.create);
  static void registerAllExtensions($pb.ExtensionRegistry registry) {
    registry.add(bigquery);
  }
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
