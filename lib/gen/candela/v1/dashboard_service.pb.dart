//
//  Generated code. Do not modify.
//  source: candela/v1/dashboard_service.proto
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

import '../types/common.pb.dart' as $4;
import '../types/user.pb.dart' as $7;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetUsageSummaryRequest extends $pb.GeneratedMessage {
  factory GetUsageSummaryRequest({
    $core.String? projectId,
    $4.TimeRange? timeRange,
    $core.String? environment,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (timeRange != null) {
      $result.timeRange = timeRange;
    }
    if (environment != null) {
      $result.environment = environment;
    }
    return $result;
  }
  GetUsageSummaryRequest._() : super();
  factory GetUsageSummaryRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetUsageSummaryRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUsageSummaryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<$4.TimeRange>(2, _omitFieldNames ? '' : 'timeRange',
        subBuilder: $4.TimeRange.create)
    ..aOS(3, _omitFieldNames ? '' : 'environment')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageSummaryRequest clone() =>
      GetUsageSummaryRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageSummaryRequest copyWith(
          void Function(GetUsageSummaryRequest) updates) =>
      super.copyWith((message) => updates(message as GetUsageSummaryRequest))
          as GetUsageSummaryRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUsageSummaryRequest create() => GetUsageSummaryRequest._();
  GetUsageSummaryRequest createEmptyInstance() => create();
  static $pb.PbList<GetUsageSummaryRequest> createRepeated() =>
      $pb.PbList<GetUsageSummaryRequest>();
  @$core.pragma('dart2js:noInline')
  static GetUsageSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUsageSummaryRequest>(create);
  static GetUsageSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $4.TimeRange get timeRange => $_getN(1);
  @$pb.TagNumber(2)
  set timeRange($4.TimeRange v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTimeRange() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeRange() => $_clearField(2);
  @$pb.TagNumber(2)
  $4.TimeRange ensureTimeRange() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get environment => $_getSZ(2);
  @$pb.TagNumber(3)
  set environment($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasEnvironment() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnvironment() => $_clearField(3);
}

class GetUsageSummaryResponse extends $pb.GeneratedMessage {
  factory GetUsageSummaryResponse({
    $fixnum.Int64? totalTraces,
    $fixnum.Int64? totalSpans,
    $fixnum.Int64? totalLlmCalls,
    $fixnum.Int64? totalInputTokens,
    $fixnum.Int64? totalOutputTokens,
    $core.double? totalCostUsd,
    $core.double? avgLatencyMs,
    $core.double? errorRate,
    $fixnum.Int64? totalCacheReadTokens,
    $fixnum.Int64? totalCacheCreationTokens,
    $core.Iterable<TimeSeriesPoint>? tracesOverTime,
    $core.Iterable<TimeSeriesPoint>? costOverTime,
    $core.Iterable<TimeSeriesPoint>? tokensOverTime,
    $core.Iterable<TimeSeriesPoint>? cacheReadTokensOverTime,
    $core.Iterable<TimeSeriesPoint>? cacheCreationTokensOverTime,
    $core.Iterable<TimeSeriesPoint>? inputTokensOverTime,
    $core.Iterable<TimeSeriesPoint>? outputTokensOverTime,
  }) {
    final $result = create();
    if (totalTraces != null) {
      $result.totalTraces = totalTraces;
    }
    if (totalSpans != null) {
      $result.totalSpans = totalSpans;
    }
    if (totalLlmCalls != null) {
      $result.totalLlmCalls = totalLlmCalls;
    }
    if (totalInputTokens != null) {
      $result.totalInputTokens = totalInputTokens;
    }
    if (totalOutputTokens != null) {
      $result.totalOutputTokens = totalOutputTokens;
    }
    if (totalCostUsd != null) {
      $result.totalCostUsd = totalCostUsd;
    }
    if (avgLatencyMs != null) {
      $result.avgLatencyMs = avgLatencyMs;
    }
    if (errorRate != null) {
      $result.errorRate = errorRate;
    }
    if (totalCacheReadTokens != null) {
      $result.totalCacheReadTokens = totalCacheReadTokens;
    }
    if (totalCacheCreationTokens != null) {
      $result.totalCacheCreationTokens = totalCacheCreationTokens;
    }
    if (tracesOverTime != null) {
      $result.tracesOverTime.addAll(tracesOverTime);
    }
    if (costOverTime != null) {
      $result.costOverTime.addAll(costOverTime);
    }
    if (tokensOverTime != null) {
      $result.tokensOverTime.addAll(tokensOverTime);
    }
    if (cacheReadTokensOverTime != null) {
      $result.cacheReadTokensOverTime.addAll(cacheReadTokensOverTime);
    }
    if (cacheCreationTokensOverTime != null) {
      $result.cacheCreationTokensOverTime.addAll(cacheCreationTokensOverTime);
    }
    if (inputTokensOverTime != null) {
      $result.inputTokensOverTime.addAll(inputTokensOverTime);
    }
    if (outputTokensOverTime != null) {
      $result.outputTokensOverTime.addAll(outputTokensOverTime);
    }
    return $result;
  }
  GetUsageSummaryResponse._() : super();
  factory GetUsageSummaryResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetUsageSummaryResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUsageSummaryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'totalTraces')
    ..aInt64(2, _omitFieldNames ? '' : 'totalSpans')
    ..aInt64(3, _omitFieldNames ? '' : 'totalLlmCalls')
    ..aInt64(4, _omitFieldNames ? '' : 'totalInputTokens')
    ..aInt64(5, _omitFieldNames ? '' : 'totalOutputTokens')
    ..a<$core.double>(
        6, _omitFieldNames ? '' : 'totalCostUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(
        7, _omitFieldNames ? '' : 'avgLatencyMs', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'errorRate', $pb.PbFieldType.OD)
    ..aInt64(9, _omitFieldNames ? '' : 'totalCacheReadTokens')
    ..aInt64(10, _omitFieldNames ? '' : 'totalCacheCreationTokens')
    ..pc<TimeSeriesPoint>(
        20, _omitFieldNames ? '' : 'tracesOverTime', $pb.PbFieldType.PM,
        subBuilder: TimeSeriesPoint.create)
    ..pc<TimeSeriesPoint>(
        21, _omitFieldNames ? '' : 'costOverTime', $pb.PbFieldType.PM,
        subBuilder: TimeSeriesPoint.create)
    ..pc<TimeSeriesPoint>(
        22, _omitFieldNames ? '' : 'tokensOverTime', $pb.PbFieldType.PM,
        subBuilder: TimeSeriesPoint.create)
    ..pc<TimeSeriesPoint>(23, _omitFieldNames ? '' : 'cacheReadTokensOverTime',
        $pb.PbFieldType.PM,
        subBuilder: TimeSeriesPoint.create)
    ..pc<TimeSeriesPoint>(
        24,
        _omitFieldNames ? '' : 'cacheCreationTokensOverTime',
        $pb.PbFieldType.PM,
        subBuilder: TimeSeriesPoint.create)
    ..pc<TimeSeriesPoint>(
        25, _omitFieldNames ? '' : 'inputTokensOverTime', $pb.PbFieldType.PM,
        subBuilder: TimeSeriesPoint.create)
    ..pc<TimeSeriesPoint>(
        26, _omitFieldNames ? '' : 'outputTokensOverTime', $pb.PbFieldType.PM,
        subBuilder: TimeSeriesPoint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageSummaryResponse clone() =>
      GetUsageSummaryResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageSummaryResponse copyWith(
          void Function(GetUsageSummaryResponse) updates) =>
      super.copyWith((message) => updates(message as GetUsageSummaryResponse))
          as GetUsageSummaryResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUsageSummaryResponse create() => GetUsageSummaryResponse._();
  GetUsageSummaryResponse createEmptyInstance() => create();
  static $pb.PbList<GetUsageSummaryResponse> createRepeated() =>
      $pb.PbList<GetUsageSummaryResponse>();
  @$core.pragma('dart2js:noInline')
  static GetUsageSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUsageSummaryResponse>(create);
  static GetUsageSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get totalTraces => $_getI64(0);
  @$pb.TagNumber(1)
  set totalTraces($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTotalTraces() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalTraces() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalSpans => $_getI64(1);
  @$pb.TagNumber(2)
  set totalSpans($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTotalSpans() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalSpans() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalLlmCalls => $_getI64(2);
  @$pb.TagNumber(3)
  set totalLlmCalls($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTotalLlmCalls() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalLlmCalls() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalInputTokens => $_getI64(3);
  @$pb.TagNumber(4)
  set totalInputTokens($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTotalInputTokens() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalInputTokens() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get totalOutputTokens => $_getI64(4);
  @$pb.TagNumber(5)
  set totalOutputTokens($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasTotalOutputTokens() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalOutputTokens() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalCostUsd => $_getN(5);
  @$pb.TagNumber(6)
  set totalCostUsd($core.double v) {
    $_setDouble(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasTotalCostUsd() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalCostUsd() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get avgLatencyMs => $_getN(6);
  @$pb.TagNumber(7)
  set avgLatencyMs($core.double v) {
    $_setDouble(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasAvgLatencyMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvgLatencyMs() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get errorRate => $_getN(7);
  @$pb.TagNumber(8)
  set errorRate($core.double v) {
    $_setDouble(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasErrorRate() => $_has(7);
  @$pb.TagNumber(8)
  void clearErrorRate() => $_clearField(8);

  /// Cache metrics — these fields are subsets of total_input_tokens.
  /// Cache hit rate = cache_read_tokens / input_tokens (excludes output tokens).
  @$pb.TagNumber(9)
  $fixnum.Int64 get totalCacheReadTokens => $_getI64(8);
  @$pb.TagNumber(9)
  set totalCacheReadTokens($fixnum.Int64 v) {
    $_setInt64(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasTotalCacheReadTokens() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotalCacheReadTokens() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get totalCacheCreationTokens => $_getI64(9);
  @$pb.TagNumber(10)
  set totalCacheCreationTokens($fixnum.Int64 v) {
    $_setInt64(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasTotalCacheCreationTokens() => $_has(9);
  @$pb.TagNumber(10)
  void clearTotalCacheCreationTokens() => $_clearField(10);

  /// Time series for charts
  @$pb.TagNumber(20)
  $pb.PbList<TimeSeriesPoint> get tracesOverTime => $_getList(10);

  @$pb.TagNumber(21)
  $pb.PbList<TimeSeriesPoint> get costOverTime => $_getList(11);

  @$pb.TagNumber(22)
  $pb.PbList<TimeSeriesPoint> get tokensOverTime => $_getList(12);

  @$pb.TagNumber(23)
  $pb.PbList<TimeSeriesPoint> get cacheReadTokensOverTime => $_getList(13);

  @$pb.TagNumber(24)
  $pb.PbList<TimeSeriesPoint> get cacheCreationTokensOverTime => $_getList(14);

  @$pb.TagNumber(25)
  $pb.PbList<TimeSeriesPoint> get inputTokensOverTime => $_getList(15);

  @$pb.TagNumber(26)
  $pb.PbList<TimeSeriesPoint> get outputTokensOverTime => $_getList(16);
}

class TimeSeriesPoint extends $pb.GeneratedMessage {
  factory TimeSeriesPoint({
    $core.String? timestamp,
    $core.double? value,
  }) {
    final $result = create();
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (value != null) {
      $result.value = value;
    }
    return $result;
  }
  TimeSeriesPoint._() : super();
  factory TimeSeriesPoint.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TimeSeriesPoint.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TimeSeriesPoint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'timestamp')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeSeriesPoint clone() => TimeSeriesPoint()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeSeriesPoint copyWith(void Function(TimeSeriesPoint) updates) =>
      super.copyWith((message) => updates(message as TimeSeriesPoint))
          as TimeSeriesPoint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TimeSeriesPoint create() => TimeSeriesPoint._();
  TimeSeriesPoint createEmptyInstance() => create();
  static $pb.PbList<TimeSeriesPoint> createRepeated() =>
      $pb.PbList<TimeSeriesPoint>();
  @$core.pragma('dart2js:noInline')
  static TimeSeriesPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TimeSeriesPoint>(create);
  static TimeSeriesPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get timestamp => $_getSZ(0);
  @$pb.TagNumber(1)
  set timestamp($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.double v) {
    $_setDouble(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class GetModelBreakdownRequest extends $pb.GeneratedMessage {
  factory GetModelBreakdownRequest({
    $core.String? projectId,
    $4.TimeRange? timeRange,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (timeRange != null) {
      $result.timeRange = timeRange;
    }
    return $result;
  }
  GetModelBreakdownRequest._() : super();
  factory GetModelBreakdownRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetModelBreakdownRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetModelBreakdownRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<$4.TimeRange>(2, _omitFieldNames ? '' : 'timeRange',
        subBuilder: $4.TimeRange.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetModelBreakdownRequest clone() =>
      GetModelBreakdownRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetModelBreakdownRequest copyWith(
          void Function(GetModelBreakdownRequest) updates) =>
      super.copyWith((message) => updates(message as GetModelBreakdownRequest))
          as GetModelBreakdownRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetModelBreakdownRequest create() => GetModelBreakdownRequest._();
  GetModelBreakdownRequest createEmptyInstance() => create();
  static $pb.PbList<GetModelBreakdownRequest> createRepeated() =>
      $pb.PbList<GetModelBreakdownRequest>();
  @$core.pragma('dart2js:noInline')
  static GetModelBreakdownRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetModelBreakdownRequest>(create);
  static GetModelBreakdownRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $4.TimeRange get timeRange => $_getN(1);
  @$pb.TagNumber(2)
  set timeRange($4.TimeRange v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTimeRange() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeRange() => $_clearField(2);
  @$pb.TagNumber(2)
  $4.TimeRange ensureTimeRange() => $_ensure(1);
}

class GetModelBreakdownResponse extends $pb.GeneratedMessage {
  factory GetModelBreakdownResponse({
    $core.Iterable<ModelUsage>? models,
  }) {
    final $result = create();
    if (models != null) {
      $result.models.addAll(models);
    }
    return $result;
  }
  GetModelBreakdownResponse._() : super();
  factory GetModelBreakdownResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetModelBreakdownResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetModelBreakdownResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<ModelUsage>(1, _omitFieldNames ? '' : 'models', $pb.PbFieldType.PM,
        subBuilder: ModelUsage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetModelBreakdownResponse clone() =>
      GetModelBreakdownResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetModelBreakdownResponse copyWith(
          void Function(GetModelBreakdownResponse) updates) =>
      super.copyWith((message) => updates(message as GetModelBreakdownResponse))
          as GetModelBreakdownResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetModelBreakdownResponse create() => GetModelBreakdownResponse._();
  GetModelBreakdownResponse createEmptyInstance() => create();
  static $pb.PbList<GetModelBreakdownResponse> createRepeated() =>
      $pb.PbList<GetModelBreakdownResponse>();
  @$core.pragma('dart2js:noInline')
  static GetModelBreakdownResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetModelBreakdownResponse>(create);
  static GetModelBreakdownResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ModelUsage> get models => $_getList(0);
}

class ModelUsage extends $pb.GeneratedMessage {
  factory ModelUsage({
    $core.String? model,
    $core.String? provider,
    $fixnum.Int64? callCount,
    $fixnum.Int64? inputTokens,
    $fixnum.Int64? outputTokens,
    $core.double? costUsd,
    $core.double? avgLatencyMs,
    $fixnum.Int64? cacheReadTokens,
    $fixnum.Int64? cacheCreationTokens,
  }) {
    final $result = create();
    if (model != null) {
      $result.model = model;
    }
    if (provider != null) {
      $result.provider = provider;
    }
    if (callCount != null) {
      $result.callCount = callCount;
    }
    if (inputTokens != null) {
      $result.inputTokens = inputTokens;
    }
    if (outputTokens != null) {
      $result.outputTokens = outputTokens;
    }
    if (costUsd != null) {
      $result.costUsd = costUsd;
    }
    if (avgLatencyMs != null) {
      $result.avgLatencyMs = avgLatencyMs;
    }
    if (cacheReadTokens != null) {
      $result.cacheReadTokens = cacheReadTokens;
    }
    if (cacheCreationTokens != null) {
      $result.cacheCreationTokens = cacheCreationTokens;
    }
    return $result;
  }
  ModelUsage._() : super();
  factory ModelUsage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ModelUsage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModelUsage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'model')
    ..aOS(2, _omitFieldNames ? '' : 'provider')
    ..aInt64(3, _omitFieldNames ? '' : 'callCount')
    ..aInt64(4, _omitFieldNames ? '' : 'inputTokens')
    ..aInt64(5, _omitFieldNames ? '' : 'outputTokens')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'costUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(
        7, _omitFieldNames ? '' : 'avgLatencyMs', $pb.PbFieldType.OD)
    ..aInt64(8, _omitFieldNames ? '' : 'cacheReadTokens')
    ..aInt64(9, _omitFieldNames ? '' : 'cacheCreationTokens')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModelUsage clone() => ModelUsage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModelUsage copyWith(void Function(ModelUsage) updates) =>
      super.copyWith((message) => updates(message as ModelUsage)) as ModelUsage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ModelUsage create() => ModelUsage._();
  ModelUsage createEmptyInstance() => create();
  static $pb.PbList<ModelUsage> createRepeated() => $pb.PbList<ModelUsage>();
  @$core.pragma('dart2js:noInline')
  static ModelUsage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModelUsage>(create);
  static ModelUsage? _defaultInstance;

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

  @$pb.TagNumber(2)
  $core.String get provider => $_getSZ(1);
  @$pb.TagNumber(2)
  set provider($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProvider() => $_has(1);
  @$pb.TagNumber(2)
  void clearProvider() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get callCount => $_getI64(2);
  @$pb.TagNumber(3)
  set callCount($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCallCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCallCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get inputTokens => $_getI64(3);
  @$pb.TagNumber(4)
  set inputTokens($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasInputTokens() => $_has(3);
  @$pb.TagNumber(4)
  void clearInputTokens() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get outputTokens => $_getI64(4);
  @$pb.TagNumber(5)
  set outputTokens($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasOutputTokens() => $_has(4);
  @$pb.TagNumber(5)
  void clearOutputTokens() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get costUsd => $_getN(5);
  @$pb.TagNumber(6)
  set costUsd($core.double v) {
    $_setDouble(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasCostUsd() => $_has(5);
  @$pb.TagNumber(6)
  void clearCostUsd() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get avgLatencyMs => $_getN(6);
  @$pb.TagNumber(7)
  set avgLatencyMs($core.double v) {
    $_setDouble(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasAvgLatencyMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvgLatencyMs() => $_clearField(7);

  /// Cache metrics per model — subset of input_tokens.
  /// Cache hit rate = cache_read_tokens / input_tokens.
  @$pb.TagNumber(8)
  $fixnum.Int64 get cacheReadTokens => $_getI64(7);
  @$pb.TagNumber(8)
  set cacheReadTokens($fixnum.Int64 v) {
    $_setInt64(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasCacheReadTokens() => $_has(7);
  @$pb.TagNumber(8)
  void clearCacheReadTokens() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get cacheCreationTokens => $_getI64(8);
  @$pb.TagNumber(9)
  set cacheCreationTokens($fixnum.Int64 v) {
    $_setInt64(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasCacheCreationTokens() => $_has(8);
  @$pb.TagNumber(9)
  void clearCacheCreationTokens() => $_clearField(9);
}

class GetLatencyPercentilesRequest extends $pb.GeneratedMessage {
  factory GetLatencyPercentilesRequest({
    $core.String? projectId,
    $4.TimeRange? timeRange,
    $core.String? model,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (timeRange != null) {
      $result.timeRange = timeRange;
    }
    if (model != null) {
      $result.model = model;
    }
    return $result;
  }
  GetLatencyPercentilesRequest._() : super();
  factory GetLatencyPercentilesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetLatencyPercentilesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLatencyPercentilesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<$4.TimeRange>(2, _omitFieldNames ? '' : 'timeRange',
        subBuilder: $4.TimeRange.create)
    ..aOS(3, _omitFieldNames ? '' : 'model')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLatencyPercentilesRequest clone() =>
      GetLatencyPercentilesRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLatencyPercentilesRequest copyWith(
          void Function(GetLatencyPercentilesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetLatencyPercentilesRequest))
          as GetLatencyPercentilesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLatencyPercentilesRequest create() =>
      GetLatencyPercentilesRequest._();
  GetLatencyPercentilesRequest createEmptyInstance() => create();
  static $pb.PbList<GetLatencyPercentilesRequest> createRepeated() =>
      $pb.PbList<GetLatencyPercentilesRequest>();
  @$core.pragma('dart2js:noInline')
  static GetLatencyPercentilesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLatencyPercentilesRequest>(create);
  static GetLatencyPercentilesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $4.TimeRange get timeRange => $_getN(1);
  @$pb.TagNumber(2)
  set timeRange($4.TimeRange v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTimeRange() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeRange() => $_clearField(2);
  @$pb.TagNumber(2)
  $4.TimeRange ensureTimeRange() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get model => $_getSZ(2);
  @$pb.TagNumber(3)
  set model($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasModel() => $_has(2);
  @$pb.TagNumber(3)
  void clearModel() => $_clearField(3);
}

class GetLatencyPercentilesResponse extends $pb.GeneratedMessage {
  factory GetLatencyPercentilesResponse({
    $core.double? p50Ms,
    $core.double? p90Ms,
    $core.double? p95Ms,
    $core.double? p99Ms,
    $core.Iterable<TimeSeriesPoint>? latencyOverTime,
  }) {
    final $result = create();
    if (p50Ms != null) {
      $result.p50Ms = p50Ms;
    }
    if (p90Ms != null) {
      $result.p90Ms = p90Ms;
    }
    if (p95Ms != null) {
      $result.p95Ms = p95Ms;
    }
    if (p99Ms != null) {
      $result.p99Ms = p99Ms;
    }
    if (latencyOverTime != null) {
      $result.latencyOverTime.addAll(latencyOverTime);
    }
    return $result;
  }
  GetLatencyPercentilesResponse._() : super();
  factory GetLatencyPercentilesResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetLatencyPercentilesResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLatencyPercentilesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'p50Ms', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'p90Ms', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'p95Ms', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'p99Ms', $pb.PbFieldType.OD)
    ..pc<TimeSeriesPoint>(
        10, _omitFieldNames ? '' : 'latencyOverTime', $pb.PbFieldType.PM,
        subBuilder: TimeSeriesPoint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLatencyPercentilesResponse clone() =>
      GetLatencyPercentilesResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLatencyPercentilesResponse copyWith(
          void Function(GetLatencyPercentilesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetLatencyPercentilesResponse))
          as GetLatencyPercentilesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLatencyPercentilesResponse create() =>
      GetLatencyPercentilesResponse._();
  GetLatencyPercentilesResponse createEmptyInstance() => create();
  static $pb.PbList<GetLatencyPercentilesResponse> createRepeated() =>
      $pb.PbList<GetLatencyPercentilesResponse>();
  @$core.pragma('dart2js:noInline')
  static GetLatencyPercentilesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLatencyPercentilesResponse>(create);
  static GetLatencyPercentilesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get p50Ms => $_getN(0);
  @$pb.TagNumber(1)
  set p50Ms($core.double v) {
    $_setDouble(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasP50Ms() => $_has(0);
  @$pb.TagNumber(1)
  void clearP50Ms() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get p90Ms => $_getN(1);
  @$pb.TagNumber(2)
  set p90Ms($core.double v) {
    $_setDouble(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasP90Ms() => $_has(1);
  @$pb.TagNumber(2)
  void clearP90Ms() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get p95Ms => $_getN(2);
  @$pb.TagNumber(3)
  set p95Ms($core.double v) {
    $_setDouble(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasP95Ms() => $_has(2);
  @$pb.TagNumber(3)
  void clearP95Ms() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get p99Ms => $_getN(3);
  @$pb.TagNumber(4)
  set p99Ms($core.double v) {
    $_setDouble(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasP99Ms() => $_has(3);
  @$pb.TagNumber(4)
  void clearP99Ms() => $_clearField(4);

  @$pb.TagNumber(10)
  $pb.PbList<TimeSeriesPoint> get latencyOverTime => $_getList(4);
}

class GetMyUsageRequest extends $pb.GeneratedMessage {
  factory GetMyUsageRequest({
    $core.String? projectId,
    $4.TimeRange? timeRange,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (timeRange != null) {
      $result.timeRange = timeRange;
    }
    return $result;
  }
  GetMyUsageRequest._() : super();
  factory GetMyUsageRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetMyUsageRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyUsageRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<$4.TimeRange>(2, _omitFieldNames ? '' : 'timeRange',
        subBuilder: $4.TimeRange.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyUsageRequest clone() => GetMyUsageRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyUsageRequest copyWith(void Function(GetMyUsageRequest) updates) =>
      super.copyWith((message) => updates(message as GetMyUsageRequest))
          as GetMyUsageRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMyUsageRequest create() => GetMyUsageRequest._();
  GetMyUsageRequest createEmptyInstance() => create();
  static $pb.PbList<GetMyUsageRequest> createRepeated() =>
      $pb.PbList<GetMyUsageRequest>();
  @$core.pragma('dart2js:noInline')
  static GetMyUsageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMyUsageRequest>(create);
  static GetMyUsageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $4.TimeRange get timeRange => $_getN(1);
  @$pb.TagNumber(2)
  set timeRange($4.TimeRange v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTimeRange() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeRange() => $_clearField(2);
  @$pb.TagNumber(2)
  $4.TimeRange ensureTimeRange() => $_ensure(1);
}

class GetMyUsageResponse extends $pb.GeneratedMessage {
  factory GetMyUsageResponse({
    $fixnum.Int64? totalCalls,
    $fixnum.Int64? totalInputTokens,
    $fixnum.Int64? totalOutputTokens,
    $core.double? totalCostUsd,
    $core.double? avgLatencyMs,
    $fixnum.Int64? totalCacheReadTokens,
    $fixnum.Int64? totalCacheCreationTokens,
    $core.Iterable<ModelUsage>? models,
    $7.UserBudget? budget,
    $core.double? totalRemainingUsd,
    $core.Iterable<$7.BudgetGrant>? activeGrants,
  }) {
    final $result = create();
    if (totalCalls != null) {
      $result.totalCalls = totalCalls;
    }
    if (totalInputTokens != null) {
      $result.totalInputTokens = totalInputTokens;
    }
    if (totalOutputTokens != null) {
      $result.totalOutputTokens = totalOutputTokens;
    }
    if (totalCostUsd != null) {
      $result.totalCostUsd = totalCostUsd;
    }
    if (avgLatencyMs != null) {
      $result.avgLatencyMs = avgLatencyMs;
    }
    if (totalCacheReadTokens != null) {
      $result.totalCacheReadTokens = totalCacheReadTokens;
    }
    if (totalCacheCreationTokens != null) {
      $result.totalCacheCreationTokens = totalCacheCreationTokens;
    }
    if (models != null) {
      $result.models.addAll(models);
    }
    if (budget != null) {
      $result.budget = budget;
    }
    if (totalRemainingUsd != null) {
      $result.totalRemainingUsd = totalRemainingUsd;
    }
    if (activeGrants != null) {
      $result.activeGrants.addAll(activeGrants);
    }
    return $result;
  }
  GetMyUsageResponse._() : super();
  factory GetMyUsageResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetMyUsageResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyUsageResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'totalCalls')
    ..aInt64(2, _omitFieldNames ? '' : 'totalInputTokens')
    ..aInt64(3, _omitFieldNames ? '' : 'totalOutputTokens')
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'totalCostUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(
        5, _omitFieldNames ? '' : 'avgLatencyMs', $pb.PbFieldType.OD)
    ..aInt64(6, _omitFieldNames ? '' : 'totalCacheReadTokens')
    ..aInt64(7, _omitFieldNames ? '' : 'totalCacheCreationTokens')
    ..pc<ModelUsage>(10, _omitFieldNames ? '' : 'models', $pb.PbFieldType.PM,
        subBuilder: ModelUsage.create)
    ..aOM<$7.UserBudget>(20, _omitFieldNames ? '' : 'budget',
        subBuilder: $7.UserBudget.create)
    ..a<$core.double>(
        21, _omitFieldNames ? '' : 'totalRemainingUsd', $pb.PbFieldType.OD)
    ..pc<$7.BudgetGrant>(
        22, _omitFieldNames ? '' : 'activeGrants', $pb.PbFieldType.PM,
        subBuilder: $7.BudgetGrant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyUsageResponse clone() => GetMyUsageResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyUsageResponse copyWith(void Function(GetMyUsageResponse) updates) =>
      super.copyWith((message) => updates(message as GetMyUsageResponse))
          as GetMyUsageResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMyUsageResponse create() => GetMyUsageResponse._();
  GetMyUsageResponse createEmptyInstance() => create();
  static $pb.PbList<GetMyUsageResponse> createRepeated() =>
      $pb.PbList<GetMyUsageResponse>();
  @$core.pragma('dart2js:noInline')
  static GetMyUsageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMyUsageResponse>(create);
  static GetMyUsageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get totalCalls => $_getI64(0);
  @$pb.TagNumber(1)
  set totalCalls($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTotalCalls() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalCalls() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalInputTokens => $_getI64(1);
  @$pb.TagNumber(2)
  set totalInputTokens($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTotalInputTokens() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalInputTokens() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalOutputTokens => $_getI64(2);
  @$pb.TagNumber(3)
  set totalOutputTokens($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTotalOutputTokens() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalOutputTokens() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get totalCostUsd => $_getN(3);
  @$pb.TagNumber(4)
  set totalCostUsd($core.double v) {
    $_setDouble(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTotalCostUsd() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalCostUsd() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get avgLatencyMs => $_getN(4);
  @$pb.TagNumber(5)
  set avgLatencyMs($core.double v) {
    $_setDouble(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasAvgLatencyMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvgLatencyMs() => $_clearField(5);

  /// Cache metrics — subset of total_input_tokens.
  @$pb.TagNumber(6)
  $fixnum.Int64 get totalCacheReadTokens => $_getI64(5);
  @$pb.TagNumber(6)
  set totalCacheReadTokens($fixnum.Int64 v) {
    $_setInt64(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasTotalCacheReadTokens() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalCacheReadTokens() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get totalCacheCreationTokens => $_getI64(6);
  @$pb.TagNumber(7)
  set totalCacheCreationTokens($fixnum.Int64 v) {
    $_setInt64(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasTotalCacheCreationTokens() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalCacheCreationTokens() => $_clearField(7);

  /// Per-model breakdown for this user
  @$pb.TagNumber(10)
  $pb.PbList<ModelUsage> get models => $_getList(7);

  /// Budget context
  @$pb.TagNumber(20)
  $7.UserBudget get budget => $_getN(8);
  @$pb.TagNumber(20)
  set budget($7.UserBudget v) {
    $_setField(20, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasBudget() => $_has(8);
  @$pb.TagNumber(20)
  void clearBudget() => $_clearField(20);
  @$pb.TagNumber(20)
  $7.UserBudget ensureBudget() => $_ensure(8);

  @$pb.TagNumber(21)
  $core.double get totalRemainingUsd => $_getN(9);
  @$pb.TagNumber(21)
  set totalRemainingUsd($core.double v) {
    $_setDouble(9, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasTotalRemainingUsd() => $_has(9);
  @$pb.TagNumber(21)
  void clearTotalRemainingUsd() => $_clearField(21);

  /// Active grants
  @$pb.TagNumber(22)
  $pb.PbList<$7.BudgetGrant> get activeGrants => $_getList(10);
}

class GetTeamLeaderboardRequest extends $pb.GeneratedMessage {
  factory GetTeamLeaderboardRequest({
    $core.String? projectId,
    $4.TimeRange? timeRange,
    $core.int? limit,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (timeRange != null) {
      $result.timeRange = timeRange;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    return $result;
  }
  GetTeamLeaderboardRequest._() : super();
  factory GetTeamLeaderboardRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetTeamLeaderboardRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTeamLeaderboardRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<$4.TimeRange>(2, _omitFieldNames ? '' : 'timeRange',
        subBuilder: $4.TimeRange.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTeamLeaderboardRequest clone() =>
      GetTeamLeaderboardRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTeamLeaderboardRequest copyWith(
          void Function(GetTeamLeaderboardRequest) updates) =>
      super.copyWith((message) => updates(message as GetTeamLeaderboardRequest))
          as GetTeamLeaderboardRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTeamLeaderboardRequest create() => GetTeamLeaderboardRequest._();
  GetTeamLeaderboardRequest createEmptyInstance() => create();
  static $pb.PbList<GetTeamLeaderboardRequest> createRepeated() =>
      $pb.PbList<GetTeamLeaderboardRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTeamLeaderboardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTeamLeaderboardRequest>(create);
  static GetTeamLeaderboardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $4.TimeRange get timeRange => $_getN(1);
  @$pb.TagNumber(2)
  set timeRange($4.TimeRange v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTimeRange() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeRange() => $_clearField(2);
  @$pb.TagNumber(2)
  $4.TimeRange ensureTimeRange() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class GetTeamLeaderboardResponse extends $pb.GeneratedMessage {
  factory GetTeamLeaderboardResponse({
    $core.Iterable<UserUsage>? users,
  }) {
    final $result = create();
    if (users != null) {
      $result.users.addAll(users);
    }
    return $result;
  }
  GetTeamLeaderboardResponse._() : super();
  factory GetTeamLeaderboardResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetTeamLeaderboardResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTeamLeaderboardResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<UserUsage>(1, _omitFieldNames ? '' : 'users', $pb.PbFieldType.PM,
        subBuilder: UserUsage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTeamLeaderboardResponse clone() =>
      GetTeamLeaderboardResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTeamLeaderboardResponse copyWith(
          void Function(GetTeamLeaderboardResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetTeamLeaderboardResponse))
          as GetTeamLeaderboardResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTeamLeaderboardResponse create() => GetTeamLeaderboardResponse._();
  GetTeamLeaderboardResponse createEmptyInstance() => create();
  static $pb.PbList<GetTeamLeaderboardResponse> createRepeated() =>
      $pb.PbList<GetTeamLeaderboardResponse>();
  @$core.pragma('dart2js:noInline')
  static GetTeamLeaderboardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTeamLeaderboardResponse>(create);
  static GetTeamLeaderboardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<UserUsage> get users => $_getList(0);
}

class UserUsage extends $pb.GeneratedMessage {
  factory UserUsage({
    $core.String? userId,
    $core.String? email,
    $core.String? displayName,
    $fixnum.Int64? callCount,
    $fixnum.Int64? totalTokens,
    $core.double? costUsd,
    $core.double? avgLatencyMs,
    $core.String? topModel,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (email != null) {
      $result.email = email;
    }
    if (displayName != null) {
      $result.displayName = displayName;
    }
    if (callCount != null) {
      $result.callCount = callCount;
    }
    if (totalTokens != null) {
      $result.totalTokens = totalTokens;
    }
    if (costUsd != null) {
      $result.costUsd = costUsd;
    }
    if (avgLatencyMs != null) {
      $result.avgLatencyMs = avgLatencyMs;
    }
    if (topModel != null) {
      $result.topModel = topModel;
    }
    return $result;
  }
  UserUsage._() : super();
  factory UserUsage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UserUsage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserUsage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..aInt64(4, _omitFieldNames ? '' : 'callCount')
    ..aInt64(5, _omitFieldNames ? '' : 'totalTokens')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'costUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(
        7, _omitFieldNames ? '' : 'avgLatencyMs', $pb.PbFieldType.OD)
    ..aOS(8, _omitFieldNames ? '' : 'topModel')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserUsage clone() => UserUsage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserUsage copyWith(void Function(UserUsage) updates) =>
      super.copyWith((message) => updates(message as UserUsage)) as UserUsage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserUsage create() => UserUsage._();
  UserUsage createEmptyInstance() => create();
  static $pb.PbList<UserUsage> createRepeated() => $pb.PbList<UserUsage>();
  @$core.pragma('dart2js:noInline')
  static UserUsage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserUsage>(create);
  static UserUsage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get callCount => $_getI64(3);
  @$pb.TagNumber(4)
  set callCount($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCallCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearCallCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get totalTokens => $_getI64(4);
  @$pb.TagNumber(5)
  set totalTokens($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasTotalTokens() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalTokens() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get costUsd => $_getN(5);
  @$pb.TagNumber(6)
  set costUsd($core.double v) {
    $_setDouble(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasCostUsd() => $_has(5);
  @$pb.TagNumber(6)
  void clearCostUsd() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get avgLatencyMs => $_getN(6);
  @$pb.TagNumber(7)
  set avgLatencyMs($core.double v) {
    $_setDouble(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasAvgLatencyMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvgLatencyMs() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get topModel => $_getSZ(7);
  @$pb.TagNumber(8)
  set topModel($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasTopModel() => $_has(7);
  @$pb.TagNumber(8)
  void clearTopModel() => $_clearField(8);
}

class GetJobLeaderboardRequest extends $pb.GeneratedMessage {
  factory GetJobLeaderboardRequest({
    $core.String? projectId,
    $4.TimeRange? timeRange,
    $core.int? limit,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (timeRange != null) {
      $result.timeRange = timeRange;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    return $result;
  }
  GetJobLeaderboardRequest._() : super();
  factory GetJobLeaderboardRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetJobLeaderboardRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetJobLeaderboardRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<$4.TimeRange>(2, _omitFieldNames ? '' : 'timeRange',
        subBuilder: $4.TimeRange.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetJobLeaderboardRequest clone() =>
      GetJobLeaderboardRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetJobLeaderboardRequest copyWith(
          void Function(GetJobLeaderboardRequest) updates) =>
      super.copyWith((message) => updates(message as GetJobLeaderboardRequest))
          as GetJobLeaderboardRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetJobLeaderboardRequest create() => GetJobLeaderboardRequest._();
  GetJobLeaderboardRequest createEmptyInstance() => create();
  static $pb.PbList<GetJobLeaderboardRequest> createRepeated() =>
      $pb.PbList<GetJobLeaderboardRequest>();
  @$core.pragma('dart2js:noInline')
  static GetJobLeaderboardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetJobLeaderboardRequest>(create);
  static GetJobLeaderboardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $4.TimeRange get timeRange => $_getN(1);
  @$pb.TagNumber(2)
  set timeRange($4.TimeRange v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTimeRange() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeRange() => $_clearField(2);
  @$pb.TagNumber(2)
  $4.TimeRange ensureTimeRange() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class GetJobLeaderboardResponse extends $pb.GeneratedMessage {
  factory GetJobLeaderboardResponse({
    $core.Iterable<JobUsage>? jobs,
  }) {
    final $result = create();
    if (jobs != null) {
      $result.jobs.addAll(jobs);
    }
    return $result;
  }
  GetJobLeaderboardResponse._() : super();
  factory GetJobLeaderboardResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetJobLeaderboardResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetJobLeaderboardResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<JobUsage>(1, _omitFieldNames ? '' : 'jobs', $pb.PbFieldType.PM,
        subBuilder: JobUsage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetJobLeaderboardResponse clone() =>
      GetJobLeaderboardResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetJobLeaderboardResponse copyWith(
          void Function(GetJobLeaderboardResponse) updates) =>
      super.copyWith((message) => updates(message as GetJobLeaderboardResponse))
          as GetJobLeaderboardResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetJobLeaderboardResponse create() => GetJobLeaderboardResponse._();
  GetJobLeaderboardResponse createEmptyInstance() => create();
  static $pb.PbList<GetJobLeaderboardResponse> createRepeated() =>
      $pb.PbList<GetJobLeaderboardResponse>();
  @$core.pragma('dart2js:noInline')
  static GetJobLeaderboardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetJobLeaderboardResponse>(create);
  static GetJobLeaderboardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<JobUsage> get jobs => $_getList(0);
}

class JobUsage extends $pb.GeneratedMessage {
  factory JobUsage({
    $core.String? jobId,
    $fixnum.Int64? callCount,
    $fixnum.Int64? totalTokens,
    $core.double? costUsd,
    $core.double? avgLatencyMs,
    $core.String? topModel,
  }) {
    final $result = create();
    if (jobId != null) {
      $result.jobId = jobId;
    }
    if (callCount != null) {
      $result.callCount = callCount;
    }
    if (totalTokens != null) {
      $result.totalTokens = totalTokens;
    }
    if (costUsd != null) {
      $result.costUsd = costUsd;
    }
    if (avgLatencyMs != null) {
      $result.avgLatencyMs = avgLatencyMs;
    }
    if (topModel != null) {
      $result.topModel = topModel;
    }
    return $result;
  }
  JobUsage._() : super();
  factory JobUsage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory JobUsage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JobUsage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..aInt64(2, _omitFieldNames ? '' : 'callCount')
    ..aInt64(3, _omitFieldNames ? '' : 'totalTokens')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'costUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(
        5, _omitFieldNames ? '' : 'avgLatencyMs', $pb.PbFieldType.OD)
    ..aOS(6, _omitFieldNames ? '' : 'topModel')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JobUsage clone() => JobUsage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JobUsage copyWith(void Function(JobUsage) updates) =>
      super.copyWith((message) => updates(message as JobUsage)) as JobUsage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JobUsage create() => JobUsage._();
  JobUsage createEmptyInstance() => create();
  static $pb.PbList<JobUsage> createRepeated() => $pb.PbList<JobUsage>();
  @$core.pragma('dart2js:noInline')
  static JobUsage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JobUsage>(create);
  static JobUsage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get callCount => $_getI64(1);
  @$pb.TagNumber(2)
  set callCount($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCallCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalTokens => $_getI64(2);
  @$pb.TagNumber(3)
  set totalTokens($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTotalTokens() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalTokens() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get costUsd => $_getN(3);
  @$pb.TagNumber(4)
  set costUsd($core.double v) {
    $_setDouble(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCostUsd() => $_has(3);
  @$pb.TagNumber(4)
  void clearCostUsd() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get avgLatencyMs => $_getN(4);
  @$pb.TagNumber(5)
  set avgLatencyMs($core.double v) {
    $_setDouble(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasAvgLatencyMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvgLatencyMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get topModel => $_getSZ(5);
  @$pb.TagNumber(6)
  set topModel($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasTopModel() => $_has(5);
  @$pb.TagNumber(6)
  void clearTopModel() => $_clearField(6);
}

class GetDashboardDataRequest extends $pb.GeneratedMessage {
  factory GetDashboardDataRequest({
    $core.String? projectId,
    $4.TimeRange? timeRange,
    $core.String? environment,
    $core.bool? includeBudget,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (timeRange != null) {
      $result.timeRange = timeRange;
    }
    if (environment != null) {
      $result.environment = environment;
    }
    if (includeBudget != null) {
      $result.includeBudget = includeBudget;
    }
    return $result;
  }
  GetDashboardDataRequest._() : super();
  factory GetDashboardDataRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetDashboardDataRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDashboardDataRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<$4.TimeRange>(2, _omitFieldNames ? '' : 'timeRange',
        subBuilder: $4.TimeRange.create)
    ..aOS(3, _omitFieldNames ? '' : 'environment')
    ..aOB(4, _omitFieldNames ? '' : 'includeBudget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardDataRequest clone() =>
      GetDashboardDataRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardDataRequest copyWith(
          void Function(GetDashboardDataRequest) updates) =>
      super.copyWith((message) => updates(message as GetDashboardDataRequest))
          as GetDashboardDataRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDashboardDataRequest create() => GetDashboardDataRequest._();
  GetDashboardDataRequest createEmptyInstance() => create();
  static $pb.PbList<GetDashboardDataRequest> createRepeated() =>
      $pb.PbList<GetDashboardDataRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDashboardDataRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDashboardDataRequest>(create);
  static GetDashboardDataRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $4.TimeRange get timeRange => $_getN(1);
  @$pb.TagNumber(2)
  set timeRange($4.TimeRange v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTimeRange() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeRange() => $_clearField(2);
  @$pb.TagNumber(2)
  $4.TimeRange ensureTimeRange() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get environment => $_getSZ(2);
  @$pb.TagNumber(3)
  set environment($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasEnvironment() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnvironment() => $_clearField(3);

  /// If true, includes per-user budget and grant context (requires auth).
  /// When false or unauthenticated, the budget/grant fields are omitted.
  @$pb.TagNumber(4)
  $core.bool get includeBudget => $_getBF(3);
  @$pb.TagNumber(4)
  set includeBudget($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasIncludeBudget() => $_has(3);
  @$pb.TagNumber(4)
  void clearIncludeBudget() => $_clearField(4);
}

/// Per-user budget context (populated when include_budget=true + auth).
/// Absent when budget was not requested or user is unauthenticated.
class GetDashboardDataResponse_BudgetContext extends $pb.GeneratedMessage {
  factory GetDashboardDataResponse_BudgetContext({
    $7.UserBudget? budget,
    $core.double? totalRemainingUsd,
    $core.Iterable<$7.BudgetGrant>? activeGrants,
  }) {
    final $result = create();
    if (budget != null) {
      $result.budget = budget;
    }
    if (totalRemainingUsd != null) {
      $result.totalRemainingUsd = totalRemainingUsd;
    }
    if (activeGrants != null) {
      $result.activeGrants.addAll(activeGrants);
    }
    return $result;
  }
  GetDashboardDataResponse_BudgetContext._() : super();
  factory GetDashboardDataResponse_BudgetContext.fromBuffer(
          $core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetDashboardDataResponse_BudgetContext.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDashboardDataResponse.BudgetContext',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$7.UserBudget>(1, _omitFieldNames ? '' : 'budget',
        subBuilder: $7.UserBudget.create)
    ..a<$core.double>(
        2, _omitFieldNames ? '' : 'totalRemainingUsd', $pb.PbFieldType.OD)
    ..pc<$7.BudgetGrant>(
        3, _omitFieldNames ? '' : 'activeGrants', $pb.PbFieldType.PM,
        subBuilder: $7.BudgetGrant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardDataResponse_BudgetContext clone() =>
      GetDashboardDataResponse_BudgetContext()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardDataResponse_BudgetContext copyWith(
          void Function(GetDashboardDataResponse_BudgetContext) updates) =>
      super.copyWith((message) =>
              updates(message as GetDashboardDataResponse_BudgetContext))
          as GetDashboardDataResponse_BudgetContext;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDashboardDataResponse_BudgetContext create() =>
      GetDashboardDataResponse_BudgetContext._();
  GetDashboardDataResponse_BudgetContext createEmptyInstance() => create();
  static $pb.PbList<GetDashboardDataResponse_BudgetContext> createRepeated() =>
      $pb.PbList<GetDashboardDataResponse_BudgetContext>();
  @$core.pragma('dart2js:noInline')
  static GetDashboardDataResponse_BudgetContext getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetDashboardDataResponse_BudgetContext>(create);
  static GetDashboardDataResponse_BudgetContext? _defaultInstance;

  @$pb.TagNumber(1)
  $7.UserBudget get budget => $_getN(0);
  @$pb.TagNumber(1)
  set budget($7.UserBudget v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBudget() => $_has(0);
  @$pb.TagNumber(1)
  void clearBudget() => $_clearField(1);
  @$pb.TagNumber(1)
  $7.UserBudget ensureBudget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get totalRemainingUsd => $_getN(1);
  @$pb.TagNumber(2)
  set totalRemainingUsd($core.double v) {
    $_setDouble(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTotalRemainingUsd() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalRemainingUsd() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$7.BudgetGrant> get activeGrants => $_getList(2);
}

class GetDashboardDataResponse extends $pb.GeneratedMessage {
  factory GetDashboardDataResponse({
    GetUsageSummaryResponse? summary,
    $core.Iterable<ModelUsage>? models,
    GetDashboardDataResponse_BudgetContext? budgetContext,
  }) {
    final $result = create();
    if (summary != null) {
      $result.summary = summary;
    }
    if (models != null) {
      $result.models.addAll(models);
    }
    if (budgetContext != null) {
      $result.budgetContext = budgetContext;
    }
    return $result;
  }
  GetDashboardDataResponse._() : super();
  factory GetDashboardDataResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetDashboardDataResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDashboardDataResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<GetUsageSummaryResponse>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: GetUsageSummaryResponse.create)
    ..pc<ModelUsage>(2, _omitFieldNames ? '' : 'models', $pb.PbFieldType.PM,
        subBuilder: ModelUsage.create)
    ..aOM<GetDashboardDataResponse_BudgetContext>(
        3, _omitFieldNames ? '' : 'budgetContext',
        subBuilder: GetDashboardDataResponse_BudgetContext.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardDataResponse clone() =>
      GetDashboardDataResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardDataResponse copyWith(
          void Function(GetDashboardDataResponse) updates) =>
      super.copyWith((message) => updates(message as GetDashboardDataResponse))
          as GetDashboardDataResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDashboardDataResponse create() => GetDashboardDataResponse._();
  GetDashboardDataResponse createEmptyInstance() => create();
  static $pb.PbList<GetDashboardDataResponse> createRepeated() =>
      $pb.PbList<GetDashboardDataResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDashboardDataResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDashboardDataResponse>(create);
  static GetDashboardDataResponse? _defaultInstance;

  /// Consolidated usage summary and time series.
  @$pb.TagNumber(1)
  GetUsageSummaryResponse get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(GetUsageSummaryResponse v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  GetUsageSummaryResponse ensureSummary() => $_ensure(0);

  /// Per-model breakdown.
  @$pb.TagNumber(2)
  $pb.PbList<ModelUsage> get models => $_getList(1);

  @$pb.TagNumber(3)
  GetDashboardDataResponse_BudgetContext get budgetContext => $_getN(2);
  @$pb.TagNumber(3)
  set budgetContext(GetDashboardDataResponse_BudgetContext v) {
    $_setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasBudgetContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearBudgetContext() => $_clearField(3);
  @$pb.TagNumber(3)
  GetDashboardDataResponse_BudgetContext ensureBudgetContext() => $_ensure(2);
}

/// DashboardService provides aggregated metrics and usage data.
/// Exposed via ConnectRPC for the web UI dashboards.
class DashboardServiceApi {
  $pb.RpcClient _client;
  DashboardServiceApi(this._client);

  /// GetDashboardData returns a consolidated dashboard view including usage
  /// summary, per-model breakdown, and (if authenticated) per-user budget
  /// context. Replaces the concurrent fan-out of GetUsageSummary +
  /// GetModelBreakdown + GetMyUsage with a single round-trip.
  $async.Future<GetDashboardDataResponse> getDashboardData(
          $pb.ClientContext? ctx, GetDashboardDataRequest request) =>
      _client.invoke<GetDashboardDataResponse>(ctx, 'DashboardService',
          'GetDashboardData', request, GetDashboardDataResponse());

  /// Deprecated: use GetDashboardData instead.
  @$core.Deprecated('This method is deprecated')
  $async.Future<GetUsageSummaryResponse> getUsageSummary(
          $pb.ClientContext? ctx, GetUsageSummaryRequest request) =>
      _client.invoke<GetUsageSummaryResponse>(ctx, 'DashboardService',
          'GetUsageSummary', request, GetUsageSummaryResponse());

  /// Deprecated: use GetDashboardData instead.
  @$core.Deprecated('This method is deprecated')
  $async.Future<GetModelBreakdownResponse> getModelBreakdown(
          $pb.ClientContext? ctx, GetModelBreakdownRequest request) =>
      _client.invoke<GetModelBreakdownResponse>(ctx, 'DashboardService',
          'GetModelBreakdown', request, GetModelBreakdownResponse());

  /// GetLatencyPercentiles returns latency distribution data.
  $async.Future<GetLatencyPercentilesResponse> getLatencyPercentiles(
          $pb.ClientContext? ctx, GetLatencyPercentilesRequest request) =>
      _client.invoke<GetLatencyPercentilesResponse>(ctx, 'DashboardService',
          'GetLatencyPercentiles', request, GetLatencyPercentilesResponse());

  /// Deprecated: use GetDashboardData with include_budget=true instead.
  /// For real-time budget/grant progress, see UserService.GetMyBudget.
  @$core.Deprecated('This method is deprecated')
  $async.Future<GetMyUsageResponse> getMyUsage(
          $pb.ClientContext? ctx, GetMyUsageRequest request) =>
      _client.invoke<GetMyUsageResponse>(
          ctx, 'DashboardService', 'GetMyUsage', request, GetMyUsageResponse());

  /// GetTeamLeaderboard returns per-user usage for the team (admin only).
  $async.Future<GetTeamLeaderboardResponse> getTeamLeaderboard(
          $pb.ClientContext? ctx, GetTeamLeaderboardRequest request) =>
      _client.invoke<GetTeamLeaderboardResponse>(ctx, 'DashboardService',
          'GetTeamLeaderboard', request, GetTeamLeaderboardResponse());

  /// GetJobLeaderboard returns per-job usage for cost attribution.
  $async.Future<GetJobLeaderboardResponse> getJobLeaderboard(
          $pb.ClientContext? ctx, GetJobLeaderboardRequest request) =>
      _client.invoke<GetJobLeaderboardResponse>(ctx, 'DashboardService',
          'GetJobLeaderboard', request, GetJobLeaderboardResponse());
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
