//
//  Generated code. Do not modify.
//  source: candela/v1/ingestion_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "ingestion_service.pb.dart" as candelav1ingestion_service;
import "ingestion_service.connect.spec.dart" as specs;

/// IngestionService handles internal span ingestion from the OTel Collector.
/// This is an internal gRPC service, not exposed externally.
extension type IngestionServiceClient(connect.Transport _transport) {
  /// IngestSpans receives a batch of spans for processing and storage.
  Future<candelav1ingestion_service.IngestSpansResponse> ingestSpans(
    candelav1ingestion_service.IngestSpansRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IngestionService.ingestSpans,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
