//
//  Generated code. Do not modify.
//  source: candela/v1/ingestion_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "ingestion_service.pb.dart" as candelav1ingestion_service;

/// IngestionService handles internal span ingestion from the OTel Collector.
/// This is an internal gRPC service, not exposed externally.
abstract final class IngestionService {
  /// Fully-qualified name of the IngestionService service.
  static const name = 'candela.v1.IngestionService';

  /// IngestSpans receives a batch of spans for processing and storage.
  static const ingestSpans = connect.Spec(
    '/$name/IngestSpans',
    connect.StreamType.unary,
    candelav1ingestion_service.IngestSpansRequest.new,
    candelav1ingestion_service.IngestSpansResponse.new,
  );
}
