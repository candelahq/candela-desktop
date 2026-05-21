//
//  Generated code. Do not modify.
//  source: candela/v1/trace_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../types/common.pb.dart' as $4;
import '../types/trace.pb.dart' as $9;
import '../types/trace.pbenum.dart' as $9;
import '../types/user.pbenum.dart' as $7;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetTraceRequest extends $pb.GeneratedMessage {
  factory GetTraceRequest({
    $core.String? traceId,
  }) {
    final $result = create();
    if (traceId != null) {
      $result.traceId = traceId;
    }
    return $result;
  }
  GetTraceRequest._() : super();
  factory GetTraceRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetTraceRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTraceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'traceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTraceRequest clone() => GetTraceRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTraceRequest copyWith(void Function(GetTraceRequest) updates) =>
      super.copyWith((message) => updates(message as GetTraceRequest))
          as GetTraceRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTraceRequest create() => GetTraceRequest._();
  GetTraceRequest createEmptyInstance() => create();
  static $pb.PbList<GetTraceRequest> createRepeated() =>
      $pb.PbList<GetTraceRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTraceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTraceRequest>(create);
  static GetTraceRequest? _defaultInstance;

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
}

class GetTraceResponse extends $pb.GeneratedMessage {
  factory GetTraceResponse({
    $9.Trace? trace,
  }) {
    final $result = create();
    if (trace != null) {
      $result.trace = trace;
    }
    return $result;
  }
  GetTraceResponse._() : super();
  factory GetTraceResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetTraceResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTraceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$9.Trace>(1, _omitFieldNames ? '' : 'trace',
        subBuilder: $9.Trace.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTraceResponse clone() => GetTraceResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTraceResponse copyWith(void Function(GetTraceResponse) updates) =>
      super.copyWith((message) => updates(message as GetTraceResponse))
          as GetTraceResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTraceResponse create() => GetTraceResponse._();
  GetTraceResponse createEmptyInstance() => create();
  static $pb.PbList<GetTraceResponse> createRepeated() =>
      $pb.PbList<GetTraceResponse>();
  @$core.pragma('dart2js:noInline')
  static GetTraceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTraceResponse>(create);
  static GetTraceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $9.Trace get trace => $_getN(0);
  @$pb.TagNumber(1)
  set trace($9.Trace v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTrace() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrace() => $_clearField(1);
  @$pb.TagNumber(1)
  $9.Trace ensureTrace() => $_ensure(0);
}

class ListTracesRequest extends $pb.GeneratedMessage {
  factory ListTracesRequest({
    $core.String? projectId,
    $core.String? environment,
    $4.TimeRange? timeRange,
    $core.String? model,
    $core.String? provider,
    $9.SpanStatus? status,
    $core.String? search,
    $core.String? tenantId,
    $core.String? jobId,
    $core.String? traceGroup,
    $4.PaginationRequest? pagination,
    $core.String? orderBy,
    $core.bool? descending,
    $7.UserScope? userScope,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (environment != null) {
      $result.environment = environment;
    }
    if (timeRange != null) {
      $result.timeRange = timeRange;
    }
    if (model != null) {
      $result.model = model;
    }
    if (provider != null) {
      $result.provider = provider;
    }
    if (status != null) {
      $result.status = status;
    }
    if (search != null) {
      $result.search = search;
    }
    if (tenantId != null) {
      $result.tenantId = tenantId;
    }
    if (jobId != null) {
      $result.jobId = jobId;
    }
    if (traceGroup != null) {
      $result.traceGroup = traceGroup;
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    if (orderBy != null) {
      $result.orderBy = orderBy;
    }
    if (descending != null) {
      $result.descending = descending;
    }
    if (userScope != null) {
      $result.userScope = userScope;
    }
    return $result;
  }
  ListTracesRequest._() : super();
  factory ListTracesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListTracesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTracesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'environment')
    ..aOM<$4.TimeRange>(3, _omitFieldNames ? '' : 'timeRange',
        subBuilder: $4.TimeRange.create)
    ..aOS(10, _omitFieldNames ? '' : 'model')
    ..aOS(11, _omitFieldNames ? '' : 'provider')
    ..e<$9.SpanStatus>(12, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: $9.SpanStatus.SPAN_STATUS_UNSPECIFIED,
        valueOf: $9.SpanStatus.valueOf,
        enumValues: $9.SpanStatus.values)
    ..aOS(13, _omitFieldNames ? '' : 'search')
    ..aOS(14, _omitFieldNames ? '' : 'tenantId')
    ..aOS(15, _omitFieldNames ? '' : 'jobId')
    ..aOS(16, _omitFieldNames ? '' : 'traceGroup')
    ..aOM<$4.PaginationRequest>(20, _omitFieldNames ? '' : 'pagination',
        subBuilder: $4.PaginationRequest.create)
    ..aOS(30, _omitFieldNames ? '' : 'orderBy')
    ..aOB(31, _omitFieldNames ? '' : 'descending')
    ..e<$7.UserScope>(
        32, _omitFieldNames ? '' : 'userScope', $pb.PbFieldType.OE,
        defaultOrMaker: $7.UserScope.USER_SCOPE_UNSPECIFIED,
        valueOf: $7.UserScope.valueOf,
        enumValues: $7.UserScope.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTracesRequest clone() => ListTracesRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTracesRequest copyWith(void Function(ListTracesRequest) updates) =>
      super.copyWith((message) => updates(message as ListTracesRequest))
          as ListTracesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTracesRequest create() => ListTracesRequest._();
  ListTracesRequest createEmptyInstance() => create();
  static $pb.PbList<ListTracesRequest> createRepeated() =>
      $pb.PbList<ListTracesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListTracesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTracesRequest>(create);
  static ListTracesRequest? _defaultInstance;

  /// Filters
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
  $core.String get environment => $_getSZ(1);
  @$pb.TagNumber(2)
  set environment($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasEnvironment() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnvironment() => $_clearField(2);

  @$pb.TagNumber(3)
  $4.TimeRange get timeRange => $_getN(2);
  @$pb.TagNumber(3)
  set timeRange($4.TimeRange v) {
    $_setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTimeRange() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeRange() => $_clearField(3);
  @$pb.TagNumber(3)
  $4.TimeRange ensureTimeRange() => $_ensure(2);

  /// Optional filters
  @$pb.TagNumber(10)
  $core.String get model => $_getSZ(3);
  @$pb.TagNumber(10)
  set model($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasModel() => $_has(3);
  @$pb.TagNumber(10)
  void clearModel() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get provider => $_getSZ(4);
  @$pb.TagNumber(11)
  set provider($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasProvider() => $_has(4);
  @$pb.TagNumber(11)
  void clearProvider() => $_clearField(11);

  @$pb.TagNumber(12)
  $9.SpanStatus get status => $_getN(5);
  @$pb.TagNumber(12)
  set status($9.SpanStatus v) {
    $_setField(12, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(12)
  void clearStatus() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get search => $_getSZ(6);
  @$pb.TagNumber(13)
  set search($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasSearch() => $_has(6);
  @$pb.TagNumber(13)
  void clearSearch() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get tenantId => $_getSZ(7);
  @$pb.TagNumber(14)
  set tenantId($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasTenantId() => $_has(7);
  @$pb.TagNumber(14)
  void clearTenantId() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get jobId => $_getSZ(8);
  @$pb.TagNumber(15)
  set jobId($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasJobId() => $_has(8);
  @$pb.TagNumber(15)
  void clearJobId() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get traceGroup => $_getSZ(9);
  @$pb.TagNumber(16)
  set traceGroup($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasTraceGroup() => $_has(9);
  @$pb.TagNumber(16)
  void clearTraceGroup() => $_clearField(16);

  /// Pagination
  @$pb.TagNumber(20)
  $4.PaginationRequest get pagination => $_getN(10);
  @$pb.TagNumber(20)
  set pagination($4.PaginationRequest v) {
    $_setField(20, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasPagination() => $_has(10);
  @$pb.TagNumber(20)
  void clearPagination() => $_clearField(20);
  @$pb.TagNumber(20)
  $4.PaginationRequest ensurePagination() => $_ensure(10);

  /// Sort
  @$pb.TagNumber(30)
  $core.String get orderBy => $_getSZ(11);
  @$pb.TagNumber(30)
  set orderBy($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(30)
  $core.bool hasOrderBy() => $_has(11);
  @$pb.TagNumber(30)
  void clearOrderBy() => $_clearField(30);

  @$pb.TagNumber(31)
  $core.bool get descending => $_getBF(12);
  @$pb.TagNumber(31)
  set descending($core.bool v) {
    $_setBool(12, v);
  }

  @$pb.TagNumber(31)
  $core.bool hasDescending() => $_has(12);
  @$pb.TagNumber(31)
  void clearDescending() => $_clearField(31);

  @$pb.TagNumber(32)
  $7.UserScope get userScope => $_getN(13);
  @$pb.TagNumber(32)
  set userScope($7.UserScope v) {
    $_setField(32, v);
  }

  @$pb.TagNumber(32)
  $core.bool hasUserScope() => $_has(13);
  @$pb.TagNumber(32)
  void clearUserScope() => $_clearField(32);
}

class ListTracesResponse extends $pb.GeneratedMessage {
  factory ListTracesResponse({
    $core.Iterable<$9.TraceSummary>? traces,
    $4.PaginationResponse? pagination,
  }) {
    final $result = create();
    if (traces != null) {
      $result.traces.addAll(traces);
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListTracesResponse._() : super();
  factory ListTracesResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListTracesResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTracesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<$9.TraceSummary>(
        1, _omitFieldNames ? '' : 'traces', $pb.PbFieldType.PM,
        subBuilder: $9.TraceSummary.create)
    ..aOM<$4.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $4.PaginationResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTracesResponse clone() => ListTracesResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTracesResponse copyWith(void Function(ListTracesResponse) updates) =>
      super.copyWith((message) => updates(message as ListTracesResponse))
          as ListTracesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTracesResponse create() => ListTracesResponse._();
  ListTracesResponse createEmptyInstance() => create();
  static $pb.PbList<ListTracesResponse> createRepeated() =>
      $pb.PbList<ListTracesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListTracesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTracesResponse>(create);
  static ListTracesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$9.TraceSummary> get traces => $_getList(0);

  @$pb.TagNumber(2)
  $4.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($4.PaginationResponse v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $4.PaginationResponse ensurePagination() => $_ensure(1);
}

class SearchSpansRequest extends $pb.GeneratedMessage {
  factory SearchSpansRequest({
    $core.String? projectId,
    $4.TimeRange? timeRange,
    $9.SpanKind? kind,
    $core.String? model,
    $core.String? nameContains,
    $core.String? tenantId,
    $core.String? jobId,
    $core.String? traceGroup,
    $4.PaginationRequest? pagination,
    $7.UserScope? userScope,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (timeRange != null) {
      $result.timeRange = timeRange;
    }
    if (kind != null) {
      $result.kind = kind;
    }
    if (model != null) {
      $result.model = model;
    }
    if (nameContains != null) {
      $result.nameContains = nameContains;
    }
    if (tenantId != null) {
      $result.tenantId = tenantId;
    }
    if (jobId != null) {
      $result.jobId = jobId;
    }
    if (traceGroup != null) {
      $result.traceGroup = traceGroup;
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    if (userScope != null) {
      $result.userScope = userScope;
    }
    return $result;
  }
  SearchSpansRequest._() : super();
  factory SearchSpansRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SearchSpansRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchSpansRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<$4.TimeRange>(2, _omitFieldNames ? '' : 'timeRange',
        subBuilder: $4.TimeRange.create)
    ..e<$9.SpanKind>(10, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE,
        defaultOrMaker: $9.SpanKind.SPAN_KIND_UNSPECIFIED,
        valueOf: $9.SpanKind.valueOf,
        enumValues: $9.SpanKind.values)
    ..aOS(11, _omitFieldNames ? '' : 'model')
    ..aOS(12, _omitFieldNames ? '' : 'nameContains')
    ..aOS(13, _omitFieldNames ? '' : 'tenantId')
    ..aOS(14, _omitFieldNames ? '' : 'jobId')
    ..aOS(15, _omitFieldNames ? '' : 'traceGroup')
    ..aOM<$4.PaginationRequest>(20, _omitFieldNames ? '' : 'pagination',
        subBuilder: $4.PaginationRequest.create)
    ..e<$7.UserScope>(
        21, _omitFieldNames ? '' : 'userScope', $pb.PbFieldType.OE,
        defaultOrMaker: $7.UserScope.USER_SCOPE_UNSPECIFIED,
        valueOf: $7.UserScope.valueOf,
        enumValues: $7.UserScope.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSpansRequest clone() => SearchSpansRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSpansRequest copyWith(void Function(SearchSpansRequest) updates) =>
      super.copyWith((message) => updates(message as SearchSpansRequest))
          as SearchSpansRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchSpansRequest create() => SearchSpansRequest._();
  SearchSpansRequest createEmptyInstance() => create();
  static $pb.PbList<SearchSpansRequest> createRepeated() =>
      $pb.PbList<SearchSpansRequest>();
  @$core.pragma('dart2js:noInline')
  static SearchSpansRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchSpansRequest>(create);
  static SearchSpansRequest? _defaultInstance;

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

  /// Span filters
  @$pb.TagNumber(10)
  $9.SpanKind get kind => $_getN(2);
  @$pb.TagNumber(10)
  set kind($9.SpanKind v) {
    $_setField(10, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(10)
  void clearKind() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get model => $_getSZ(3);
  @$pb.TagNumber(11)
  set model($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasModel() => $_has(3);
  @$pb.TagNumber(11)
  void clearModel() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get nameContains => $_getSZ(4);
  @$pb.TagNumber(12)
  set nameContains($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasNameContains() => $_has(4);
  @$pb.TagNumber(12)
  void clearNameContains() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get tenantId => $_getSZ(5);
  @$pb.TagNumber(13)
  set tenantId($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasTenantId() => $_has(5);
  @$pb.TagNumber(13)
  void clearTenantId() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get jobId => $_getSZ(6);
  @$pb.TagNumber(14)
  set jobId($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasJobId() => $_has(6);
  @$pb.TagNumber(14)
  void clearJobId() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get traceGroup => $_getSZ(7);
  @$pb.TagNumber(15)
  set traceGroup($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasTraceGroup() => $_has(7);
  @$pb.TagNumber(15)
  void clearTraceGroup() => $_clearField(15);

  @$pb.TagNumber(20)
  $4.PaginationRequest get pagination => $_getN(8);
  @$pb.TagNumber(20)
  set pagination($4.PaginationRequest v) {
    $_setField(20, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasPagination() => $_has(8);
  @$pb.TagNumber(20)
  void clearPagination() => $_clearField(20);
  @$pb.TagNumber(20)
  $4.PaginationRequest ensurePagination() => $_ensure(8);

  @$pb.TagNumber(21)
  $7.UserScope get userScope => $_getN(9);
  @$pb.TagNumber(21)
  set userScope($7.UserScope v) {
    $_setField(21, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasUserScope() => $_has(9);
  @$pb.TagNumber(21)
  void clearUserScope() => $_clearField(21);
}

class SearchSpansResponse extends $pb.GeneratedMessage {
  factory SearchSpansResponse({
    $core.Iterable<$9.Span>? spans,
    $4.PaginationResponse? pagination,
  }) {
    final $result = create();
    if (spans != null) {
      $result.spans.addAll(spans);
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  SearchSpansResponse._() : super();
  factory SearchSpansResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SearchSpansResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchSpansResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<$9.Span>(1, _omitFieldNames ? '' : 'spans', $pb.PbFieldType.PM,
        subBuilder: $9.Span.create)
    ..aOM<$4.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $4.PaginationResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSpansResponse clone() => SearchSpansResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSpansResponse copyWith(void Function(SearchSpansResponse) updates) =>
      super.copyWith((message) => updates(message as SearchSpansResponse))
          as SearchSpansResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchSpansResponse create() => SearchSpansResponse._();
  SearchSpansResponse createEmptyInstance() => create();
  static $pb.PbList<SearchSpansResponse> createRepeated() =>
      $pb.PbList<SearchSpansResponse>();
  @$core.pragma('dart2js:noInline')
  static SearchSpansResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchSpansResponse>(create);
  static SearchSpansResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$9.Span> get spans => $_getList(0);

  @$pb.TagNumber(2)
  $4.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($4.PaginationResponse v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $4.PaginationResponse ensurePagination() => $_ensure(1);
}

/// TraceService provides APIs for querying and retrieving traces.
/// Exposed via ConnectRPC for the web UI.
class TraceServiceApi {
  $pb.RpcClient _client;
  TraceServiceApi(this._client);

  /// GetTrace returns a single trace with all its spans.
  $async.Future<GetTraceResponse> getTrace(
          $pb.ClientContext? ctx, GetTraceRequest request) =>
      _client.invoke<GetTraceResponse>(
          ctx, 'TraceService', 'GetTrace', request, GetTraceResponse());

  /// ListTraces returns a paginated list of trace summaries.
  $async.Future<ListTracesResponse> listTraces(
          $pb.ClientContext? ctx, ListTracesRequest request) =>
      _client.invoke<ListTracesResponse>(
          ctx, 'TraceService', 'ListTraces', request, ListTracesResponse());

  /// SearchSpans searches for individual spans matching criteria.
  $async.Future<SearchSpansResponse> searchSpans(
          $pb.ClientContext? ctx, SearchSpansRequest request) =>
      _client.invoke<SearchSpansResponse>(
          ctx, 'TraceService', 'SearchSpans', request, SearchSpansResponse());
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
