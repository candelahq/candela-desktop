//
//  Generated code. Do not modify.
//  source: candela/v1/trace_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../google/protobuf/duration.pbjson.dart' as $0;
import '../../google/protobuf/timestamp.pbjson.dart' as $2;
import '../types/common.pbjson.dart' as $4;
import '../types/trace.pbjson.dart' as $9;

@$core.Deprecated('Use getTraceRequestDescriptor instead')
const GetTraceRequest$json = {
  '1': 'GetTraceRequest',
  '2': [
    {'1': 'trace_id', '3': 1, '4': 1, '5': 9, '10': 'traceId'},
  ],
};

/// Descriptor for `GetTraceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTraceRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRUcmFjZVJlcXVlc3QSGQoIdHJhY2VfaWQYASABKAlSB3RyYWNlSWQ=');

@$core.Deprecated('Use getTraceResponseDescriptor instead')
const GetTraceResponse$json = {
  '1': 'GetTraceResponse',
  '2': [
    {
      '1': 'trace',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.Trace',
      '10': 'trace'
    },
  ],
};

/// Descriptor for `GetTraceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTraceResponseDescriptor = $convert.base64Decode(
    'ChBHZXRUcmFjZVJlc3BvbnNlEioKBXRyYWNlGAEgASgLMhQuY2FuZGVsYS50eXBlcy5UcmFjZV'
    'IFdHJhY2U=');

@$core.Deprecated('Use listTracesRequestDescriptor instead')
const ListTracesRequest$json = {
  '1': 'ListTracesRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'environment', '3': 2, '4': 1, '5': 9, '10': 'environment'},
    {
      '1': 'time_range',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.candela.types.TimeRange',
      '10': 'timeRange'
    },
    {'1': 'model', '3': 10, '4': 1, '5': 9, '10': 'model'},
    {'1': 'provider', '3': 11, '4': 1, '5': 9, '10': 'provider'},
    {
      '1': 'status',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.candela.types.SpanStatus',
      '10': 'status'
    },
    {'1': 'search', '3': 13, '4': 1, '5': 9, '10': 'search'},
    {'1': 'tenant_id', '3': 14, '4': 1, '5': 9, '10': 'tenantId'},
    {'1': 'job_id', '3': 15, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'trace_group', '3': 16, '4': 1, '5': 9, '10': 'traceGroup'},
    {
      '1': 'pagination',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.candela.types.PaginationRequest',
      '10': 'pagination'
    },
    {'1': 'order_by', '3': 30, '4': 1, '5': 9, '10': 'orderBy'},
    {'1': 'descending', '3': 31, '4': 1, '5': 8, '10': 'descending'},
    {
      '1': 'user_scope',
      '3': 32,
      '4': 1,
      '5': 14,
      '6': '.candela.types.UserScope',
      '10': 'userScope'
    },
  ],
};

/// Descriptor for `ListTracesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTracesRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0VHJhY2VzUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SWQSIAoLZW'
    '52aXJvbm1lbnQYAiABKAlSC2Vudmlyb25tZW50EjcKCnRpbWVfcmFuZ2UYAyABKAsyGC5jYW5k'
    'ZWxhLnR5cGVzLlRpbWVSYW5nZVIJdGltZVJhbmdlEhQKBW1vZGVsGAogASgJUgVtb2RlbBIaCg'
    'hwcm92aWRlchgLIAEoCVIIcHJvdmlkZXISMQoGc3RhdHVzGAwgASgOMhkuY2FuZGVsYS50eXBl'
    'cy5TcGFuU3RhdHVzUgZzdGF0dXMSFgoGc2VhcmNoGA0gASgJUgZzZWFyY2gSGwoJdGVuYW50X2'
    'lkGA4gASgJUgh0ZW5hbnRJZBIVCgZqb2JfaWQYDyABKAlSBWpvYklkEh8KC3RyYWNlX2dyb3Vw'
    'GBAgASgJUgp0cmFjZUdyb3VwEkAKCnBhZ2luYXRpb24YFCABKAsyIC5jYW5kZWxhLnR5cGVzLl'
    'BhZ2luYXRpb25SZXF1ZXN0UgpwYWdpbmF0aW9uEhkKCG9yZGVyX2J5GB4gASgJUgdvcmRlckJ5'
    'Eh4KCmRlc2NlbmRpbmcYHyABKAhSCmRlc2NlbmRpbmcSNwoKdXNlcl9zY29wZRggIAEoDjIYLm'
    'NhbmRlbGEudHlwZXMuVXNlclNjb3BlUgl1c2VyU2NvcGU=');

@$core.Deprecated('Use listTracesResponseDescriptor instead')
const ListTracesResponse$json = {
  '1': 'ListTracesResponse',
  '2': [
    {
      '1': 'traces',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.types.TraceSummary',
      '10': 'traces'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.candela.types.PaginationResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListTracesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTracesResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0VHJhY2VzUmVzcG9uc2USMwoGdHJhY2VzGAEgAygLMhsuY2FuZGVsYS50eXBlcy5Ucm'
    'FjZVN1bW1hcnlSBnRyYWNlcxJBCgpwYWdpbmF0aW9uGAIgASgLMiEuY2FuZGVsYS50eXBlcy5Q'
    'YWdpbmF0aW9uUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use searchSpansRequestDescriptor instead')
const SearchSpansRequest$json = {
  '1': 'SearchSpansRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {
      '1': 'time_range',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.candela.types.TimeRange',
      '10': 'timeRange'
    },
    {
      '1': 'kind',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.candela.types.SpanKind',
      '10': 'kind'
    },
    {'1': 'model', '3': 11, '4': 1, '5': 9, '10': 'model'},
    {'1': 'name_contains', '3': 12, '4': 1, '5': 9, '10': 'nameContains'},
    {'1': 'tenant_id', '3': 13, '4': 1, '5': 9, '10': 'tenantId'},
    {'1': 'job_id', '3': 14, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'trace_group', '3': 15, '4': 1, '5': 9, '10': 'traceGroup'},
    {
      '1': 'pagination',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.candela.types.PaginationRequest',
      '10': 'pagination'
    },
    {
      '1': 'user_scope',
      '3': 21,
      '4': 1,
      '5': 14,
      '6': '.candela.types.UserScope',
      '10': 'userScope'
    },
  ],
};

/// Descriptor for `SearchSpansRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchSpansRequestDescriptor = $convert.base64Decode(
    'ChJTZWFyY2hTcGFuc1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElkEjcKCn'
    'RpbWVfcmFuZ2UYAiABKAsyGC5jYW5kZWxhLnR5cGVzLlRpbWVSYW5nZVIJdGltZVJhbmdlEisK'
    'BGtpbmQYCiABKA4yFy5jYW5kZWxhLnR5cGVzLlNwYW5LaW5kUgRraW5kEhQKBW1vZGVsGAsgAS'
    'gJUgVtb2RlbBIjCg1uYW1lX2NvbnRhaW5zGAwgASgJUgxuYW1lQ29udGFpbnMSGwoJdGVuYW50'
    'X2lkGA0gASgJUgh0ZW5hbnRJZBIVCgZqb2JfaWQYDiABKAlSBWpvYklkEh8KC3RyYWNlX2dyb3'
    'VwGA8gASgJUgp0cmFjZUdyb3VwEkAKCnBhZ2luYXRpb24YFCABKAsyIC5jYW5kZWxhLnR5cGVz'
    'LlBhZ2luYXRpb25SZXF1ZXN0UgpwYWdpbmF0aW9uEjcKCnVzZXJfc2NvcGUYFSABKA4yGC5jYW'
    '5kZWxhLnR5cGVzLlVzZXJTY29wZVIJdXNlclNjb3Bl');

@$core.Deprecated('Use searchSpansResponseDescriptor instead')
const SearchSpansResponse$json = {
  '1': 'SearchSpansResponse',
  '2': [
    {
      '1': 'spans',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.types.Span',
      '10': 'spans'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.candela.types.PaginationResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `SearchSpansResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchSpansResponseDescriptor = $convert.base64Decode(
    'ChNTZWFyY2hTcGFuc1Jlc3BvbnNlEikKBXNwYW5zGAEgAygLMhMuY2FuZGVsYS50eXBlcy5TcG'
    'FuUgVzcGFucxJBCgpwYWdpbmF0aW9uGAIgASgLMiEuY2FuZGVsYS50eXBlcy5QYWdpbmF0aW9u'
    'UmVzcG9uc2VSCnBhZ2luYXRpb24=');

const $core.Map<$core.String, $core.dynamic> TraceServiceBase$json = {
  '1': 'TraceService',
  '2': [
    {
      '1': 'GetTrace',
      '2': '.candela.v1.GetTraceRequest',
      '3': '.candela.v1.GetTraceResponse'
    },
    {
      '1': 'ListTraces',
      '2': '.candela.v1.ListTracesRequest',
      '3': '.candela.v1.ListTracesResponse'
    },
    {
      '1': 'SearchSpans',
      '2': '.candela.v1.SearchSpansRequest',
      '3': '.candela.v1.SearchSpansResponse'
    },
  ],
};

@$core.Deprecated('Use traceServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    TraceServiceBase$messageJson = {
  '.candela.v1.GetTraceRequest': GetTraceRequest$json,
  '.candela.v1.GetTraceResponse': GetTraceResponse$json,
  '.candela.types.Trace': $9.Trace$json,
  '.google.protobuf.Timestamp': $2.Timestamp$json,
  '.google.protobuf.Duration': $0.Duration$json,
  '.candela.types.Span': $9.Span$json,
  '.candela.types.GenAIAttributes': $9.GenAIAttributes$json,
  '.candela.types.ToolAttributes': $9.ToolAttributes$json,
  '.candela.types.Attribute': $4.Attribute$json,
  '.candela.types.Span.LabelsEntry': $9.Span_LabelsEntry$json,
  '.candela.types.SpanEvent': $9.SpanEvent$json,
  '.candela.v1.ListTracesRequest': ListTracesRequest$json,
  '.candela.types.TimeRange': $4.TimeRange$json,
  '.candela.types.PaginationRequest': $4.PaginationRequest$json,
  '.candela.v1.ListTracesResponse': ListTracesResponse$json,
  '.candela.types.TraceSummary': $9.TraceSummary$json,
  '.candela.types.PaginationResponse': $4.PaginationResponse$json,
  '.candela.v1.SearchSpansRequest': SearchSpansRequest$json,
  '.candela.v1.SearchSpansResponse': SearchSpansResponse$json,
};

/// Descriptor for `TraceService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List traceServiceDescriptor = $convert.base64Decode(
    'CgxUcmFjZVNlcnZpY2USRQoIR2V0VHJhY2USGy5jYW5kZWxhLnYxLkdldFRyYWNlUmVxdWVzdB'
    'ocLmNhbmRlbGEudjEuR2V0VHJhY2VSZXNwb25zZRJLCgpMaXN0VHJhY2VzEh0uY2FuZGVsYS52'
    'MS5MaXN0VHJhY2VzUmVxdWVzdBoeLmNhbmRlbGEudjEuTGlzdFRyYWNlc1Jlc3BvbnNlEk4KC1'
    'NlYXJjaFNwYW5zEh4uY2FuZGVsYS52MS5TZWFyY2hTcGFuc1JlcXVlc3QaHy5jYW5kZWxhLnYx'
    'LlNlYXJjaFNwYW5zUmVzcG9uc2U=');
