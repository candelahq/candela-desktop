//
//  Generated code. Do not modify.
//  source: candela/v1/ingestion_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../types/trace.pb.dart' as $9;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class IngestSpansRequest extends $pb.GeneratedMessage {
  factory IngestSpansRequest({
    $core.Iterable<$9.Span>? spans,
  }) {
    final $result = create();
    if (spans != null) {
      $result.spans.addAll(spans);
    }
    return $result;
  }
  IngestSpansRequest._() : super();
  factory IngestSpansRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory IngestSpansRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IngestSpansRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<$9.Span>(1, _omitFieldNames ? '' : 'spans', $pb.PbFieldType.PM,
        subBuilder: $9.Span.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngestSpansRequest clone() => IngestSpansRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngestSpansRequest copyWith(void Function(IngestSpansRequest) updates) =>
      super.copyWith((message) => updates(message as IngestSpansRequest))
          as IngestSpansRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngestSpansRequest create() => IngestSpansRequest._();
  IngestSpansRequest createEmptyInstance() => create();
  static $pb.PbList<IngestSpansRequest> createRepeated() =>
      $pb.PbList<IngestSpansRequest>();
  @$core.pragma('dart2js:noInline')
  static IngestSpansRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IngestSpansRequest>(create);
  static IngestSpansRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$9.Span> get spans => $_getList(0);
}

class IngestSpansResponse extends $pb.GeneratedMessage {
  factory IngestSpansResponse({
    $core.int? acceptedCount,
    $core.int? rejectedCount,
    $core.Iterable<$core.String>? errors,
  }) {
    final $result = create();
    if (acceptedCount != null) {
      $result.acceptedCount = acceptedCount;
    }
    if (rejectedCount != null) {
      $result.rejectedCount = rejectedCount;
    }
    if (errors != null) {
      $result.errors.addAll(errors);
    }
    return $result;
  }
  IngestSpansResponse._() : super();
  factory IngestSpansResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory IngestSpansResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IngestSpansResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1, _omitFieldNames ? '' : 'acceptedCount', $pb.PbFieldType.O3)
    ..a<$core.int>(
        2, _omitFieldNames ? '' : 'rejectedCount', $pb.PbFieldType.O3)
    ..pPS(3, _omitFieldNames ? '' : 'errors')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngestSpansResponse clone() => IngestSpansResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngestSpansResponse copyWith(void Function(IngestSpansResponse) updates) =>
      super.copyWith((message) => updates(message as IngestSpansResponse))
          as IngestSpansResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngestSpansResponse create() => IngestSpansResponse._();
  IngestSpansResponse createEmptyInstance() => create();
  static $pb.PbList<IngestSpansResponse> createRepeated() =>
      $pb.PbList<IngestSpansResponse>();
  @$core.pragma('dart2js:noInline')
  static IngestSpansResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IngestSpansResponse>(create);
  static IngestSpansResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get acceptedCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set acceptedCount($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAcceptedCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAcceptedCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get rejectedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set rejectedCount($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRejectedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearRejectedCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get errors => $_getList(2);
}

/// IngestionService handles internal span ingestion from the OTel Collector.
/// This is an internal gRPC service, not exposed externally.
class IngestionServiceApi {
  $pb.RpcClient _client;
  IngestionServiceApi(this._client);

  /// IngestSpans receives a batch of spans for processing and storage.
  $async.Future<IngestSpansResponse> ingestSpans(
          $pb.ClientContext? ctx, IngestSpansRequest request) =>
      _client.invoke<IngestSpansResponse>(ctx, 'IngestionService',
          'IngestSpans', request, IngestSpansResponse());
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
