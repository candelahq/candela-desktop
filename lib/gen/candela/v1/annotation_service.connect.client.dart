//
//  Generated code. Do not modify.
//  source: candela/v1/annotation_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "annotation_service.pb.dart" as candelav1annotation_service;
import "annotation_service.connect.spec.dart" as specs;

/// AnnotationService provides APIs for post-hoc trace enrichment.
/// This backs the Layer 3 SDK (outcome logging, human labeling, custom metrics).
/// Exposed via ConnectRPC for SDK clients and the web UI review queue.
/// Annotations are stored in a dedicated AnnotationStore (not piped through
/// the span ingestion pipeline) because they have CRUD semantics, low volume,
/// and arrive after trace completion.
extension type AnnotationServiceClient(connect.Transport _transport) {
  /// SetOutcome records a business outcome for a trace.
  Future<candelav1annotation_service.SetOutcomeResponse> setOutcome(
    candelav1annotation_service.SetOutcomeRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AnnotationService.setOutcome,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// AddLabel attaches a human review label to a trace.
  Future<candelav1annotation_service.AddLabelResponse> addLabel(
    candelav1annotation_service.AddLabelRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AnnotationService.addLabel,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LogMetric records a custom domain metric for a trace.
  Future<candelav1annotation_service.LogMetricResponse> logMetric(
    candelav1annotation_service.LogMetricRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AnnotationService.logMetric,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListAnnotations returns all annotations for a trace.
  Future<candelav1annotation_service.ListAnnotationsResponse> listAnnotations(
    candelav1annotation_service.ListAnnotationsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AnnotationService.listAnnotations,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
