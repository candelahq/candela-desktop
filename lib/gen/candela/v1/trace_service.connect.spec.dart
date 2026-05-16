//
//  Generated code. Do not modify.
//  source: candela/v1/trace_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "trace_service.pb.dart" as candelav1trace_service;

/// TraceService provides APIs for querying and retrieving traces.
/// Exposed via ConnectRPC for the web UI.
abstract final class TraceService {
  /// Fully-qualified name of the TraceService service.
  static const name = 'candela.v1.TraceService';

  /// GetTrace returns a single trace with all its spans.
  static const getTrace = connect.Spec(
    '/$name/GetTrace',
    connect.StreamType.unary,
    candelav1trace_service.GetTraceRequest.new,
    candelav1trace_service.GetTraceResponse.new,
  );

  /// ListTraces returns a paginated list of trace summaries.
  static const listTraces = connect.Spec(
    '/$name/ListTraces',
    connect.StreamType.unary,
    candelav1trace_service.ListTracesRequest.new,
    candelav1trace_service.ListTracesResponse.new,
  );

  /// SearchSpans searches for individual spans matching criteria.
  static const searchSpans = connect.Spec(
    '/$name/SearchSpans',
    connect.StreamType.unary,
    candelav1trace_service.SearchSpansRequest.new,
    candelav1trace_service.SearchSpansResponse.new,
  );
}
