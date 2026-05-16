//
//  Generated code. Do not modify.
//  source: candela/v1/annotation_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "annotation_service.pb.dart" as candelav1annotation_service;

/// AnnotationService provides APIs for post-hoc trace enrichment.
/// This backs the Layer 3 SDK (outcome logging, human labeling, custom metrics).
/// Exposed via ConnectRPC for SDK clients and the web UI review queue.
/// Annotations are stored in a dedicated AnnotationStore (not piped through
/// the span ingestion pipeline) because they have CRUD semantics, low volume,
/// and arrive after trace completion.
abstract final class AnnotationService {
  /// Fully-qualified name of the AnnotationService service.
  static const name = 'candela.v1.AnnotationService';

  /// SetOutcome records a business outcome for a trace.
  static const setOutcome = connect.Spec(
    '/$name/SetOutcome',
    connect.StreamType.unary,
    candelav1annotation_service.SetOutcomeRequest.new,
    candelav1annotation_service.SetOutcomeResponse.new,
  );

  /// AddLabel attaches a human review label to a trace.
  static const addLabel = connect.Spec(
    '/$name/AddLabel',
    connect.StreamType.unary,
    candelav1annotation_service.AddLabelRequest.new,
    candelav1annotation_service.AddLabelResponse.new,
  );

  /// LogMetric records a custom domain metric for a trace.
  static const logMetric = connect.Spec(
    '/$name/LogMetric',
    connect.StreamType.unary,
    candelav1annotation_service.LogMetricRequest.new,
    candelav1annotation_service.LogMetricResponse.new,
  );

  /// ListAnnotations returns all annotations for a trace.
  static const listAnnotations = connect.Spec(
    '/$name/ListAnnotations',
    connect.StreamType.unary,
    candelav1annotation_service.ListAnnotationsRequest.new,
    candelav1annotation_service.ListAnnotationsResponse.new,
  );
}
