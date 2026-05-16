//
//  Generated code. Do not modify.
//  source: candela/v1/trace_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "trace_service.pb.dart" as candelav1trace_service;
import "trace_service.connect.spec.dart" as specs;

/// TraceService provides APIs for querying and retrieving traces.
/// Exposed via ConnectRPC for the web UI.
extension type TraceServiceClient(connect.Transport _transport) {
  /// GetTrace returns a single trace with all its spans.
  Future<candelav1trace_service.GetTraceResponse> getTrace(
    candelav1trace_service.GetTraceRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TraceService.getTrace,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListTraces returns a paginated list of trace summaries.
  Future<candelav1trace_service.ListTracesResponse> listTraces(
    candelav1trace_service.ListTracesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TraceService.listTraces,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// SearchSpans searches for individual spans matching criteria.
  Future<candelav1trace_service.SearchSpansResponse> searchSpans(
    candelav1trace_service.SearchSpansRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TraceService.searchSpans,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
