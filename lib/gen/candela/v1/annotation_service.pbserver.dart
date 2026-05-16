//
//  Generated code. Do not modify.
//  source: candela/v1/annotation_service.proto
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

import 'annotation_service.pb.dart' as $6;
import 'annotation_service.pbjson.dart';

export 'annotation_service.pb.dart';

abstract class AnnotationServiceBase extends $pb.GeneratedService {
  $async.Future<$6.SetOutcomeResponse> setOutcome(
      $pb.ServerContext ctx, $6.SetOutcomeRequest request);
  $async.Future<$6.AddLabelResponse> addLabel(
      $pb.ServerContext ctx, $6.AddLabelRequest request);
  $async.Future<$6.LogMetricResponse> logMetric(
      $pb.ServerContext ctx, $6.LogMetricRequest request);
  $async.Future<$6.ListAnnotationsResponse> listAnnotations(
      $pb.ServerContext ctx, $6.ListAnnotationsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'SetOutcome':
        return $6.SetOutcomeRequest();
      case 'AddLabel':
        return $6.AddLabelRequest();
      case 'LogMetric':
        return $6.LogMetricRequest();
      case 'ListAnnotations':
        return $6.ListAnnotationsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'SetOutcome':
        return this.setOutcome(ctx, request as $6.SetOutcomeRequest);
      case 'AddLabel':
        return this.addLabel(ctx, request as $6.AddLabelRequest);
      case 'LogMetric':
        return this.logMetric(ctx, request as $6.LogMetricRequest);
      case 'ListAnnotations':
        return this.listAnnotations(ctx, request as $6.ListAnnotationsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      AnnotationServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AnnotationServiceBase$messageJson;
}
