//
//  Generated code. Do not modify.
//  source: candela/v1/ingestion_service.proto
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

import 'ingestion_service.pb.dart' as $10;
import 'ingestion_service.pbjson.dart';

export 'ingestion_service.pb.dart';

abstract class IngestionServiceBase extends $pb.GeneratedService {
  $async.Future<$10.IngestSpansResponse> ingestSpans(
      $pb.ServerContext ctx, $10.IngestSpansRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'IngestSpans':
        return $10.IngestSpansRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'IngestSpans':
        return this.ingestSpans(ctx, request as $10.IngestSpansRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => IngestionServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => IngestionServiceBase$messageJson;
}
