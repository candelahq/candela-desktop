//
//  Generated code. Do not modify.
//  source: candela/v1/annotation_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../types/annotation.pb.dart' as $5;
import '../types/annotation.pbenum.dart' as $5;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class SetOutcomeRequest extends $pb.GeneratedMessage {
  factory SetOutcomeRequest({
    $core.String? traceId,
    $core.bool? success,
    $core.double? score,
    $core.String? comment,
  }) {
    final $result = create();
    if (traceId != null) {
      $result.traceId = traceId;
    }
    if (success != null) {
      $result.success = success;
    }
    if (score != null) {
      $result.score = score;
    }
    if (comment != null) {
      $result.comment = comment;
    }
    return $result;
  }
  SetOutcomeRequest._() : super();
  factory SetOutcomeRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SetOutcomeRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetOutcomeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'traceId')
    ..aOB(2, _omitFieldNames ? '' : 'success')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'score', $pb.PbFieldType.OD)
    ..aOS(4, _omitFieldNames ? '' : 'comment')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetOutcomeRequest clone() => SetOutcomeRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetOutcomeRequest copyWith(void Function(SetOutcomeRequest) updates) =>
      super.copyWith((message) => updates(message as SetOutcomeRequest))
          as SetOutcomeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetOutcomeRequest create() => SetOutcomeRequest._();
  SetOutcomeRequest createEmptyInstance() => create();
  static $pb.PbList<SetOutcomeRequest> createRepeated() =>
      $pb.PbList<SetOutcomeRequest>();
  @$core.pragma('dart2js:noInline')
  static SetOutcomeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetOutcomeRequest>(create);
  static SetOutcomeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get traceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set traceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTraceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTraceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get success => $_getBF(1);
  @$pb.TagNumber(2)
  set success($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get score => $_getN(2);
  @$pb.TagNumber(3)
  set score($core.double v) {
    $_setDouble(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearScore() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get comment => $_getSZ(3);
  @$pb.TagNumber(4)
  set comment($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasComment() => $_has(3);
  @$pb.TagNumber(4)
  void clearComment() => $_clearField(4);
}

class SetOutcomeResponse extends $pb.GeneratedMessage {
  factory SetOutcomeResponse({
    $5.Annotation? annotation,
  }) {
    final $result = create();
    if (annotation != null) {
      $result.annotation = annotation;
    }
    return $result;
  }
  SetOutcomeResponse._() : super();
  factory SetOutcomeResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SetOutcomeResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetOutcomeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$5.Annotation>(1, _omitFieldNames ? '' : 'annotation',
        subBuilder: $5.Annotation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetOutcomeResponse clone() => SetOutcomeResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetOutcomeResponse copyWith(void Function(SetOutcomeResponse) updates) =>
      super.copyWith((message) => updates(message as SetOutcomeResponse))
          as SetOutcomeResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetOutcomeResponse create() => SetOutcomeResponse._();
  SetOutcomeResponse createEmptyInstance() => create();
  static $pb.PbList<SetOutcomeResponse> createRepeated() =>
      $pb.PbList<SetOutcomeResponse>();
  @$core.pragma('dart2js:noInline')
  static SetOutcomeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetOutcomeResponse>(create);
  static SetOutcomeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $5.Annotation get annotation => $_getN(0);
  @$pb.TagNumber(1)
  set annotation($5.Annotation v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAnnotation() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnnotation() => $_clearField(1);
  @$pb.TagNumber(1)
  $5.Annotation ensureAnnotation() => $_ensure(0);
}

class AddLabelRequest extends $pb.GeneratedMessage {
  factory AddLabelRequest({
    $core.String? traceId,
    $core.String? label,
    $core.String? reviewer,
    $core.String? comment,
  }) {
    final $result = create();
    if (traceId != null) {
      $result.traceId = traceId;
    }
    if (label != null) {
      $result.label = label;
    }
    if (reviewer != null) {
      $result.reviewer = reviewer;
    }
    if (comment != null) {
      $result.comment = comment;
    }
    return $result;
  }
  AddLabelRequest._() : super();
  factory AddLabelRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AddLabelRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddLabelRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'traceId')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOS(3, _omitFieldNames ? '' : 'reviewer')
    ..aOS(4, _omitFieldNames ? '' : 'comment')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddLabelRequest clone() => AddLabelRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddLabelRequest copyWith(void Function(AddLabelRequest) updates) =>
      super.copyWith((message) => updates(message as AddLabelRequest))
          as AddLabelRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddLabelRequest create() => AddLabelRequest._();
  AddLabelRequest createEmptyInstance() => create();
  static $pb.PbList<AddLabelRequest> createRepeated() =>
      $pb.PbList<AddLabelRequest>();
  @$core.pragma('dart2js:noInline')
  static AddLabelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddLabelRequest>(create);
  static AddLabelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get traceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set traceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTraceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTraceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reviewer => $_getSZ(2);
  @$pb.TagNumber(3)
  set reviewer($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasReviewer() => $_has(2);
  @$pb.TagNumber(3)
  void clearReviewer() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get comment => $_getSZ(3);
  @$pb.TagNumber(4)
  set comment($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasComment() => $_has(3);
  @$pb.TagNumber(4)
  void clearComment() => $_clearField(4);
}

class AddLabelResponse extends $pb.GeneratedMessage {
  factory AddLabelResponse({
    $5.Annotation? annotation,
  }) {
    final $result = create();
    if (annotation != null) {
      $result.annotation = annotation;
    }
    return $result;
  }
  AddLabelResponse._() : super();
  factory AddLabelResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AddLabelResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddLabelResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$5.Annotation>(1, _omitFieldNames ? '' : 'annotation',
        subBuilder: $5.Annotation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddLabelResponse clone() => AddLabelResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddLabelResponse copyWith(void Function(AddLabelResponse) updates) =>
      super.copyWith((message) => updates(message as AddLabelResponse))
          as AddLabelResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddLabelResponse create() => AddLabelResponse._();
  AddLabelResponse createEmptyInstance() => create();
  static $pb.PbList<AddLabelResponse> createRepeated() =>
      $pb.PbList<AddLabelResponse>();
  @$core.pragma('dart2js:noInline')
  static AddLabelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddLabelResponse>(create);
  static AddLabelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $5.Annotation get annotation => $_getN(0);
  @$pb.TagNumber(1)
  set annotation($5.Annotation v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAnnotation() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnnotation() => $_clearField(1);
  @$pb.TagNumber(1)
  $5.Annotation ensureAnnotation() => $_ensure(0);
}

class LogMetricRequest extends $pb.GeneratedMessage {
  factory LogMetricRequest({
    $core.String? traceId,
    $core.String? metricName,
    $core.double? metricValue,
    $core.String? comment,
  }) {
    final $result = create();
    if (traceId != null) {
      $result.traceId = traceId;
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
    return $result;
  }
  LogMetricRequest._() : super();
  factory LogMetricRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory LogMetricRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogMetricRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'traceId')
    ..aOS(2, _omitFieldNames ? '' : 'metricName')
    ..a<$core.double>(
        3, _omitFieldNames ? '' : 'metricValue', $pb.PbFieldType.OD)
    ..aOS(4, _omitFieldNames ? '' : 'comment')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogMetricRequest clone() => LogMetricRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogMetricRequest copyWith(void Function(LogMetricRequest) updates) =>
      super.copyWith((message) => updates(message as LogMetricRequest))
          as LogMetricRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogMetricRequest create() => LogMetricRequest._();
  LogMetricRequest createEmptyInstance() => create();
  static $pb.PbList<LogMetricRequest> createRepeated() =>
      $pb.PbList<LogMetricRequest>();
  @$core.pragma('dart2js:noInline')
  static LogMetricRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogMetricRequest>(create);
  static LogMetricRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get traceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set traceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTraceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTraceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get metricName => $_getSZ(1);
  @$pb.TagNumber(2)
  set metricName($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMetricName() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetricName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get metricValue => $_getN(2);
  @$pb.TagNumber(3)
  set metricValue($core.double v) {
    $_setDouble(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMetricValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearMetricValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get comment => $_getSZ(3);
  @$pb.TagNumber(4)
  set comment($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasComment() => $_has(3);
  @$pb.TagNumber(4)
  void clearComment() => $_clearField(4);
}

class LogMetricResponse extends $pb.GeneratedMessage {
  factory LogMetricResponse({
    $5.Annotation? annotation,
  }) {
    final $result = create();
    if (annotation != null) {
      $result.annotation = annotation;
    }
    return $result;
  }
  LogMetricResponse._() : super();
  factory LogMetricResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory LogMetricResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogMetricResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$5.Annotation>(1, _omitFieldNames ? '' : 'annotation',
        subBuilder: $5.Annotation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogMetricResponse clone() => LogMetricResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogMetricResponse copyWith(void Function(LogMetricResponse) updates) =>
      super.copyWith((message) => updates(message as LogMetricResponse))
          as LogMetricResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogMetricResponse create() => LogMetricResponse._();
  LogMetricResponse createEmptyInstance() => create();
  static $pb.PbList<LogMetricResponse> createRepeated() =>
      $pb.PbList<LogMetricResponse>();
  @$core.pragma('dart2js:noInline')
  static LogMetricResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogMetricResponse>(create);
  static LogMetricResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $5.Annotation get annotation => $_getN(0);
  @$pb.TagNumber(1)
  set annotation($5.Annotation v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAnnotation() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnnotation() => $_clearField(1);
  @$pb.TagNumber(1)
  $5.Annotation ensureAnnotation() => $_ensure(0);
}

class ListAnnotationsRequest extends $pb.GeneratedMessage {
  factory ListAnnotationsRequest({
    $core.String? traceId,
    $5.AnnotationType? typeFilter,
  }) {
    final $result = create();
    if (traceId != null) {
      $result.traceId = traceId;
    }
    if (typeFilter != null) {
      $result.typeFilter = typeFilter;
    }
    return $result;
  }
  ListAnnotationsRequest._() : super();
  factory ListAnnotationsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListAnnotationsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAnnotationsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'traceId')
    ..e<$5.AnnotationType>(
        2, _omitFieldNames ? '' : 'typeFilter', $pb.PbFieldType.OE,
        defaultOrMaker: $5.AnnotationType.ANNOTATION_TYPE_UNSPECIFIED,
        valueOf: $5.AnnotationType.valueOf,
        enumValues: $5.AnnotationType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAnnotationsRequest clone() =>
      ListAnnotationsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAnnotationsRequest copyWith(
          void Function(ListAnnotationsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAnnotationsRequest))
          as ListAnnotationsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAnnotationsRequest create() => ListAnnotationsRequest._();
  ListAnnotationsRequest createEmptyInstance() => create();
  static $pb.PbList<ListAnnotationsRequest> createRepeated() =>
      $pb.PbList<ListAnnotationsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAnnotationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAnnotationsRequest>(create);
  static ListAnnotationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get traceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set traceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTraceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTraceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $5.AnnotationType get typeFilter => $_getN(1);
  @$pb.TagNumber(2)
  set typeFilter($5.AnnotationType v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTypeFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearTypeFilter() => $_clearField(2);
}

class ListAnnotationsResponse extends $pb.GeneratedMessage {
  factory ListAnnotationsResponse({
    $core.Iterable<$5.Annotation>? annotations,
  }) {
    final $result = create();
    if (annotations != null) {
      $result.annotations.addAll(annotations);
    }
    return $result;
  }
  ListAnnotationsResponse._() : super();
  factory ListAnnotationsResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListAnnotationsResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAnnotationsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<$5.Annotation>(
        1, _omitFieldNames ? '' : 'annotations', $pb.PbFieldType.PM,
        subBuilder: $5.Annotation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAnnotationsResponse clone() =>
      ListAnnotationsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAnnotationsResponse copyWith(
          void Function(ListAnnotationsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAnnotationsResponse))
          as ListAnnotationsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAnnotationsResponse create() => ListAnnotationsResponse._();
  ListAnnotationsResponse createEmptyInstance() => create();
  static $pb.PbList<ListAnnotationsResponse> createRepeated() =>
      $pb.PbList<ListAnnotationsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAnnotationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAnnotationsResponse>(create);
  static ListAnnotationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$5.Annotation> get annotations => $_getList(0);
}

/// AnnotationService provides APIs for post-hoc trace enrichment.
/// This backs the Layer 3 SDK (outcome logging, human labeling, custom metrics).
/// Exposed via ConnectRPC for SDK clients and the web UI review queue.
///
/// Annotations are stored in a dedicated AnnotationStore (not piped through
/// the span ingestion pipeline) because they have CRUD semantics, low volume,
/// and arrive after trace completion.
class AnnotationServiceApi {
  $pb.RpcClient _client;
  AnnotationServiceApi(this._client);

  /// SetOutcome records a business outcome for a trace.
  $async.Future<SetOutcomeResponse> setOutcome(
          $pb.ClientContext? ctx, SetOutcomeRequest request) =>
      _client.invoke<SetOutcomeResponse>(ctx, 'AnnotationService', 'SetOutcome',
          request, SetOutcomeResponse());

  /// AddLabel attaches a human review label to a trace.
  $async.Future<AddLabelResponse> addLabel(
          $pb.ClientContext? ctx, AddLabelRequest request) =>
      _client.invoke<AddLabelResponse>(
          ctx, 'AnnotationService', 'AddLabel', request, AddLabelResponse());

  /// LogMetric records a custom domain metric for a trace.
  $async.Future<LogMetricResponse> logMetric(
          $pb.ClientContext? ctx, LogMetricRequest request) =>
      _client.invoke<LogMetricResponse>(
          ctx, 'AnnotationService', 'LogMetric', request, LogMetricResponse());

  /// ListAnnotations returns all annotations for a trace.
  $async.Future<ListAnnotationsResponse> listAnnotations(
          $pb.ClientContext? ctx, ListAnnotationsRequest request) =>
      _client.invoke<ListAnnotationsResponse>(ctx, 'AnnotationService',
          'ListAnnotations', request, ListAnnotationsResponse());
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
