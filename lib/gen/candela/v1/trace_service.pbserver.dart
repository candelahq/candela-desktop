//
//  Generated code. Do not modify.
//  source: candela/v1/trace_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'trace_service.pb.dart' as $14;
import 'trace_service.pbjson.dart';

export 'trace_service.pb.dart';

abstract class TraceServiceBase extends $pb.GeneratedService {
  $async.Future<$14.GetTraceResponse> getTrace(
      $pb.ServerContext ctx, $14.GetTraceRequest request);
  $async.Future<$14.ListTracesResponse> listTraces(
      $pb.ServerContext ctx, $14.ListTracesRequest request);
  $async.Future<$14.SearchSpansResponse> searchSpans(
      $pb.ServerContext ctx, $14.SearchSpansRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetTrace':
        return $14.GetTraceRequest();
      case 'ListTraces':
        return $14.ListTracesRequest();
      case 'SearchSpans':
        return $14.SearchSpansRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetTrace':
        return this.getTrace(ctx, request as $14.GetTraceRequest);
      case 'ListTraces':
        return this.listTraces(ctx, request as $14.ListTracesRequest);
      case 'SearchSpans':
        return this.searchSpans(ctx, request as $14.SearchSpansRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => TraceServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => TraceServiceBase$messageJson;
}
