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

import '../../google/protobuf/timestamp.pb.dart' as $2;
import 'annotation.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'annotation.pbenum.dart';

/// Annotation is a post-hoc enrichment attached to a trace after execution.
/// This enables business outcome correlation, eval ground truth, and compliance review.
///
/// Storage: annotations table (DuckDB/SQLite/BigQuery) with trace_id FK for JOINs.
/// Not stored in Firestore — annotations are analytical data that belongs with traces.
class Annotation extends $pb.GeneratedMessage {
  factory Annotation({
    $core.String? id,
    $core.String? traceId,
    AnnotationType? type,
    $core.bool? success,
    $core.double? score,
    $core.String? label,
    $core.String? reviewer,
    $core.String? metricName,
    $core.double? metricValue,
    $core.String? comment,
    $2.Timestamp? createdAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (traceId != null) {
      $result.traceId = traceId;
    }
    if (type != null) {
      $result.type = type;
    }
    if (success != null) {
      $result.success = success;
    }
    if (score != null) {
      $result.score = score;
    }
    if (label != null) {
      $result.label = label;
    }
    if (reviewer != null) {
      $result.reviewer = reviewer;
    }
    if (metricName != null) {
      $result.metricName = metricName;
    }
    if (metricValue != null) {
      $result.metricValue = metricValue;
    }
    if (comment != null) {
      $result.comment = comment;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  Annotation._() : super();
  factory Annotation.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Annotation.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Annotation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'traceId')
    ..e<AnnotationType>(3, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE,
        defaultOrMaker: AnnotationType.ANNOTATION_TYPE_UNSPECIFIED,
        valueOf: AnnotationType.valueOf,
        enumValues: AnnotationType.values)
    ..aOB(10, _omitFieldNames ? '' : 'success')
    ..a<$core.double>(11, _omitFieldNames ? '' : 'score', $pb.PbFieldType.OD)
    ..aOS(20, _omitFieldNames ? '' : 'label')
    ..aOS(21, _omitFieldNames ? '' : 'reviewer')
    ..aOS(30, _omitFieldNames ? '' : 'metricName')
    ..a<$core.double>(
        31, _omitFieldNames ? '' : 'metricValue', $pb.PbFieldType.OD)
    ..aOS(40, _omitFieldNames ? '' : 'comment')
    ..aOM<$2.Timestamp>(50, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Annotation clone() => Annotation()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Annotation copyWith(void Function(Annotation) updates) =>
      super.copyWith((message) => updates(message as Annotation)) as Annotation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Annotation create() => Annotation._();
  Annotation createEmptyInstance() => create();
  static $pb.PbList<Annotation> createRepeated() => $pb.PbList<Annotation>();
  @$core.pragma('dart2js:noInline')
  static Annotation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Annotation>(create);
  static Annotation? _defaultInstance;

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

  @$pb.TagNumber(2)
  $core.String get traceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set traceId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTraceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTraceId() => $_clearField(2);

  @$pb.TagNumber(3)
  AnnotationType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(AnnotationType v) {
    $_setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  /// Outcome fields (when type = OUTCOME)
  @$pb.TagNumber(10)
  $core.bool get success => $_getBF(3);
  @$pb.TagNumber(10)
  set success($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasSuccess() => $_has(3);
  @$pb.TagNumber(10)
  void clearSuccess() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get score => $_getN(4);
  @$pb.TagNumber(11)
  set score($core.double v) {
    $_setDouble(4, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasScore() => $_has(4);
  @$pb.TagNumber(11)
  void clearScore() => $_clearField(11);

  /// Label fields (when type = LABEL)
  @$pb.TagNumber(20)
  $core.String get label => $_getSZ(5);
  @$pb.TagNumber(20)
  set label($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasLabel() => $_has(5);
  @$pb.TagNumber(20)
  void clearLabel() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get reviewer => $_getSZ(6);
  @$pb.TagNumber(21)
  set reviewer($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasReviewer() => $_has(6);
  @$pb.TagNumber(21)
  void clearReviewer() => $_clearField(21);

  /// Metric fields (when type = METRIC)
  @$pb.TagNumber(30)
  $core.String get metricName => $_getSZ(7);
  @$pb.TagNumber(30)
  set metricName($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(30)
  $core.bool hasMetricName() => $_has(7);
  @$pb.TagNumber(30)
  void clearMetricName() => $_clearField(30);

  @$pb.TagNumber(31)
  $core.double get metricValue => $_getN(8);
  @$pb.TagNumber(31)
  set metricValue($core.double v) {
    $_setDouble(8, v);
  }

  @$pb.TagNumber(31)
  $core.bool hasMetricValue() => $_has(8);
  @$pb.TagNumber(31)
  void clearMetricValue() => $_clearField(31);

  /// Common
  @$pb.TagNumber(40)
  $core.String get comment => $_getSZ(9);
  @$pb.TagNumber(40)
  set comment($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(40)
  $core.bool hasComment() => $_has(9);
  @$pb.TagNumber(40)
  void clearComment() => $_clearField(40);

  @$pb.TagNumber(50)
  $2.Timestamp get createdAt => $_getN(10);
  @$pb.TagNumber(50)
  set createdAt($2.Timestamp v) {
    $_setField(50, v);
  }

  @$pb.TagNumber(50)
  $core.bool hasCreatedAt() => $_has(10);
  @$pb.TagNumber(50)
  void clearCreatedAt() => $_clearField(50);
  @$pb.TagNumber(50)
  $2.Timestamp ensureCreatedAt() => $_ensure(10);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
