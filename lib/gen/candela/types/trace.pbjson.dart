//
//  Generated code. Do not modify.
//  source: candela/types/trace.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use spanKindDescriptor instead')
const SpanKind$json = {
  '1': 'SpanKind',
  '2': [
    {'1': 'SPAN_KIND_UNSPECIFIED', '2': 0},
    {'1': 'SPAN_KIND_LLM', '2': 1},
    {'1': 'SPAN_KIND_AGENT', '2': 2},
    {'1': 'SPAN_KIND_TOOL', '2': 3},
    {'1': 'SPAN_KIND_RETRIEVAL', '2': 4},
    {'1': 'SPAN_KIND_EMBEDDING', '2': 5},
    {'1': 'SPAN_KIND_CHAIN', '2': 6},
    {'1': 'SPAN_KIND_GENERAL', '2': 7},
  ],
};

/// Descriptor for `SpanKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List spanKindDescriptor = $convert.base64Decode(
    'CghTcGFuS2luZBIZChVTUEFOX0tJTkRfVU5TUEVDSUZJRUQQABIRCg1TUEFOX0tJTkRfTExNEA'
    'ESEwoPU1BBTl9LSU5EX0FHRU5UEAISEgoOU1BBTl9LSU5EX1RPT0wQAxIXChNTUEFOX0tJTkRf'
    'UkVUUklFVkFMEAQSFwoTU1BBTl9LSU5EX0VNQkVERElORxAFEhMKD1NQQU5fS0lORF9DSEFJTh'
    'AGEhUKEVNQQU5fS0lORF9HRU5FUkFMEAc=');

@$core.Deprecated('Use spanStatusDescriptor instead')
const SpanStatus$json = {
  '1': 'SpanStatus',
  '2': [
    {'1': 'SPAN_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SPAN_STATUS_OK', '2': 1},
    {'1': 'SPAN_STATUS_ERROR', '2': 2},
  ],
};

/// Descriptor for `SpanStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List spanStatusDescriptor = $convert.base64Decode(
    'CgpTcGFuU3RhdHVzEhsKF1NQQU5fU1RBVFVTX1VOU1BFQ0lGSUVEEAASEgoOU1BBTl9TVEFUVV'
    'NfT0sQARIVChFTUEFOX1NUQVRVU19FUlJPUhAC');

@$core.Deprecated('Use genAIAttributesDescriptor instead')
const GenAIAttributes$json = {
  '1': 'GenAIAttributes',
  '2': [
    {'1': 'model', '3': 1, '4': 1, '5': 9, '10': 'model'},
    {'1': 'provider', '3': 2, '4': 1, '5': 9, '10': 'provider'},
    {'1': 'input_tokens', '3': 10, '4': 1, '5': 3, '10': 'inputTokens'},
    {'1': 'output_tokens', '3': 11, '4': 1, '5': 3, '10': 'outputTokens'},
    {'1': 'total_tokens', '3': 12, '4': 1, '5': 3, '10': 'totalTokens'},
    {'1': 'cost_usd', '3': 20, '4': 1, '5': 1, '10': 'costUsd'},
    {'1': 'temperature', '3': 30, '4': 1, '5': 1, '10': 'temperature'},
    {'1': 'max_tokens', '3': 31, '4': 1, '5': 3, '10': 'maxTokens'},
    {'1': 'top_p', '3': 32, '4': 1, '5': 1, '10': 'topP'},
    {
      '1': 'input_content',
      '3': 40,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'inputContent'
    },
    {
      '1': 'output_content',
      '3': 41,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'outputContent'
    },
    {
      '1': 'input_content_ref',
      '3': 42,
      '4': 1,
      '5': 9,
      '10': 'inputContentRef'
    },
    {
      '1': 'output_content_ref',
      '3': 43,
      '4': 1,
      '5': 9,
      '10': 'outputContentRef'
    },
  ],
};

/// Descriptor for `GenAIAttributes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genAIAttributesDescriptor = $convert.base64Decode(
    'Cg9HZW5BSUF0dHJpYnV0ZXMSFAoFbW9kZWwYASABKAlSBW1vZGVsEhoKCHByb3ZpZGVyGAIgAS'
    'gJUghwcm92aWRlchIhCgxpbnB1dF90b2tlbnMYCiABKANSC2lucHV0VG9rZW5zEiMKDW91dHB1'
    'dF90b2tlbnMYCyABKANSDG91dHB1dFRva2VucxIhCgx0b3RhbF90b2tlbnMYDCABKANSC3RvdG'
    'FsVG9rZW5zEhkKCGNvc3RfdXNkGBQgASgBUgdjb3N0VXNkEiAKC3RlbXBlcmF0dXJlGB4gASgB'
    'Ugt0ZW1wZXJhdHVyZRIdCgptYXhfdG9rZW5zGB8gASgDUgltYXhUb2tlbnMSEwoFdG9wX3AYIC'
    'ABKAFSBHRvcFASLgoNaW5wdXRfY29udGVudBgoIAEoCUIJukgGcgQYgIBAUgxpbnB1dENvbnRl'
    'bnQSMAoOb3V0cHV0X2NvbnRlbnQYKSABKAlCCbpIBnIEGICAQFINb3V0cHV0Q29udGVudBIqCh'
    'FpbnB1dF9jb250ZW50X3JlZhgqIAEoCVIPaW5wdXRDb250ZW50UmVmEiwKEm91dHB1dF9jb250'
    'ZW50X3JlZhgrIAEoCVIQb3V0cHV0Q29udGVudFJlZg==');

@$core.Deprecated('Use toolAttributesDescriptor instead')
const ToolAttributes$json = {
  '1': 'ToolAttributes',
  '2': [
    {'1': 'tool_name', '3': 1, '4': 1, '5': 9, '10': 'toolName'},
    {'1': 'tool_input', '3': 2, '4': 1, '5': 9, '10': 'toolInput'},
    {'1': 'tool_output', '3': 3, '4': 1, '5': 9, '10': 'toolOutput'},
  ],
};

/// Descriptor for `ToolAttributes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolAttributesDescriptor = $convert.base64Decode(
    'Cg5Ub29sQXR0cmlidXRlcxIbCgl0b29sX25hbWUYASABKAlSCHRvb2xOYW1lEh0KCnRvb2xfaW'
    '5wdXQYAiABKAlSCXRvb2xJbnB1dBIfCgt0b29sX291dHB1dBgDIAEoCVIKdG9vbE91dHB1dA==');

@$core.Deprecated('Use spanDescriptor instead')
const Span$json = {
  '1': 'Span',
  '2': [
    {'1': 'span_id', '3': 1, '4': 1, '5': 9, '10': 'spanId'},
    {'1': 'trace_id', '3': 2, '4': 1, '5': 9, '10': 'traceId'},
    {'1': 'parent_span_id', '3': 3, '4': 1, '5': 9, '10': 'parentSpanId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.candela.types.SpanKind',
      '10': 'kind'
    },
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.candela.types.SpanStatus',
      '10': 'status'
    },
    {'1': 'status_message', '3': 7, '4': 1, '5': 9, '10': 'statusMessage'},
    {
      '1': 'start_time',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startTime'
    },
    {
      '1': 'end_time',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endTime'
    },
    {
      '1': 'duration',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Duration',
      '10': 'duration'
    },
    {
      '1': 'gen_ai',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.candela.types.GenAIAttributes',
      '10': 'genAi'
    },
    {
      '1': 'tool',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.candela.types.ToolAttributes',
      '10': 'tool'
    },
    {
      '1': 'attributes',
      '3': 30,
      '4': 3,
      '5': 11,
      '6': '.candela.types.Attribute',
      '10': 'attributes'
    },
    {'1': 'project_id', '3': 40, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'environment', '3': 41, '4': 1, '5': 9, '10': 'environment'},
    {'1': 'service_name', '3': 42, '4': 1, '5': 9, '10': 'serviceName'},
    {'1': 'user_id', '3': 43, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'session_id', '3': 44, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'tenant_id', '3': 45, '4': 1, '5': 9, '10': 'tenantId'},
    {'1': 'job_id', '3': 46, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'trace_group', '3': 47, '4': 1, '5': 9, '10': 'traceGroup'},
    {
      '1': 'labels',
      '3': 48,
      '4': 3,
      '5': 11,
      '6': '.candela.types.Span.LabelsEntry',
      '10': 'labels'
    },
    {
      '1': 'events',
      '3': 50,
      '4': 3,
      '5': 11,
      '6': '.candela.types.SpanEvent',
      '10': 'events'
    },
  ],
  '3': [Span_LabelsEntry$json],
};

@$core.Deprecated('Use spanDescriptor instead')
const Span_LabelsEntry$json = {
  '1': 'LabelsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Span`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spanDescriptor = $convert.base64Decode(
    'CgRTcGFuEhcKB3NwYW5faWQYASABKAlSBnNwYW5JZBIZCgh0cmFjZV9pZBgCIAEoCVIHdHJhY2'
    'VJZBIkCg5wYXJlbnRfc3Bhbl9pZBgDIAEoCVIMcGFyZW50U3BhbklkEhIKBG5hbWUYBCABKAlS'
    'BG5hbWUSKwoEa2luZBgFIAEoDjIXLmNhbmRlbGEudHlwZXMuU3BhbktpbmRSBGtpbmQSMQoGc3'
    'RhdHVzGAYgASgOMhkuY2FuZGVsYS50eXBlcy5TcGFuU3RhdHVzUgZzdGF0dXMSJQoOc3RhdHVz'
    'X21lc3NhZ2UYByABKAlSDXN0YXR1c01lc3NhZ2USOQoKc3RhcnRfdGltZRgKIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0VGltZRI1CghlbmRfdGltZRgLIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB2VuZFRpbWUSNQoIZHVyYXRpb24YDCABKAsyGS5nb2'
    '9nbGUucHJvdG9idWYuRHVyYXRpb25SCGR1cmF0aW9uEjUKBmdlbl9haRgUIAEoCzIeLmNhbmRl'
    'bGEudHlwZXMuR2VuQUlBdHRyaWJ1dGVzUgVnZW5BaRIxCgR0b29sGBUgASgLMh0uY2FuZGVsYS'
    '50eXBlcy5Ub29sQXR0cmlidXRlc1IEdG9vbBI4CgphdHRyaWJ1dGVzGB4gAygLMhguY2FuZGVs'
    'YS50eXBlcy5BdHRyaWJ1dGVSCmF0dHJpYnV0ZXMSHQoKcHJvamVjdF9pZBgoIAEoCVIJcHJvam'
    'VjdElkEiAKC2Vudmlyb25tZW50GCkgASgJUgtlbnZpcm9ubWVudBIhCgxzZXJ2aWNlX25hbWUY'
    'KiABKAlSC3NlcnZpY2VOYW1lEhcKB3VzZXJfaWQYKyABKAlSBnVzZXJJZBIdCgpzZXNzaW9uX2'
    'lkGCwgASgJUglzZXNzaW9uSWQSGwoJdGVuYW50X2lkGC0gASgJUgh0ZW5hbnRJZBIVCgZqb2Jf'
    'aWQYLiABKAlSBWpvYklkEh8KC3RyYWNlX2dyb3VwGC8gASgJUgp0cmFjZUdyb3VwEjcKBmxhYm'
    'VscxgwIAMoCzIfLmNhbmRlbGEudHlwZXMuU3Bhbi5MYWJlbHNFbnRyeVIGbGFiZWxzEjAKBmV2'
    'ZW50cxgyIAMoCzIYLmNhbmRlbGEudHlwZXMuU3BhbkV2ZW50UgZldmVudHMaOQoLTGFiZWxzRW'
    '50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use spanEventDescriptor instead')
const SpanEvent$json = {
  '1': 'SpanEvent',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'timestamp',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {
      '1': 'attributes',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.candela.types.Attribute',
      '10': 'attributes'
    },
  ],
};

/// Descriptor for `SpanEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spanEventDescriptor = $convert.base64Decode(
    'CglTcGFuRXZlbnQSEgoEbmFtZRgBIAEoCVIEbmFtZRI4Cgl0aW1lc3RhbXAYAiABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgl0aW1lc3RhbXASOAoKYXR0cmlidXRlcxgDIAMoCzIY'
    'LmNhbmRlbGEudHlwZXMuQXR0cmlidXRlUgphdHRyaWJ1dGVz');

@$core.Deprecated('Use traceDescriptor instead')
const Trace$json = {
  '1': 'Trace',
  '2': [
    {'1': 'trace_id', '3': 1, '4': 1, '5': 9, '10': 'traceId'},
    {
      '1': 'start_time',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startTime'
    },
    {
      '1': 'end_time',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endTime'
    },
    {
      '1': 'duration',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Duration',
      '10': 'duration'
    },
    {'1': 'project_id', '3': 5, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'environment', '3': 6, '4': 1, '5': 9, '10': 'environment'},
    {'1': 'span_count', '3': 7, '4': 1, '5': 5, '10': 'spanCount'},
    {'1': 'total_tokens', '3': 8, '4': 1, '5': 3, '10': 'totalTokens'},
    {'1': 'total_cost_usd', '3': 9, '4': 1, '5': 1, '10': 'totalCostUsd'},
    {'1': 'root_span_name', '3': 10, '4': 1, '5': 9, '10': 'rootSpanName'},
    {'1': 'user_id', '3': 11, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'session_id', '3': 12, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'tenant_id', '3': 13, '4': 1, '5': 9, '10': 'tenantId'},
    {'1': 'job_id', '3': 14, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'trace_group', '3': 15, '4': 1, '5': 9, '10': 'traceGroup'},
    {
      '1': 'spans',
      '3': 20,
      '4': 3,
      '5': 11,
      '6': '.candela.types.Span',
      '10': 'spans'
    },
  ],
};

/// Descriptor for `Trace`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traceDescriptor = $convert.base64Decode(
    'CgVUcmFjZRIZCgh0cmFjZV9pZBgBIAEoCVIHdHJhY2VJZBI5CgpzdGFydF90aW1lGAIgASgLMh'
    'ouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRUaW1lEjUKCGVuZF90aW1lGAMgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHZW5kVGltZRI1CghkdXJhdGlvbhgEIAEoCz'
    'IZLmdvb2dsZS5wcm90b2J1Zi5EdXJhdGlvblIIZHVyYXRpb24SHQoKcHJvamVjdF9pZBgFIAEo'
    'CVIJcHJvamVjdElkEiAKC2Vudmlyb25tZW50GAYgASgJUgtlbnZpcm9ubWVudBIdCgpzcGFuX2'
    'NvdW50GAcgASgFUglzcGFuQ291bnQSIQoMdG90YWxfdG9rZW5zGAggASgDUgt0b3RhbFRva2Vu'
    'cxIkCg50b3RhbF9jb3N0X3VzZBgJIAEoAVIMdG90YWxDb3N0VXNkEiQKDnJvb3Rfc3Bhbl9uYW'
    '1lGAogASgJUgxyb290U3Bhbk5hbWUSFwoHdXNlcl9pZBgLIAEoCVIGdXNlcklkEh0KCnNlc3Np'
    'b25faWQYDCABKAlSCXNlc3Npb25JZBIbCgl0ZW5hbnRfaWQYDSABKAlSCHRlbmFudElkEhUKBm'
    'pvYl9pZBgOIAEoCVIFam9iSWQSHwoLdHJhY2VfZ3JvdXAYDyABKAlSCnRyYWNlR3JvdXASKQoF'
    'c3BhbnMYFCADKAsyEy5jYW5kZWxhLnR5cGVzLlNwYW5SBXNwYW5z');

@$core.Deprecated('Use traceSummaryDescriptor instead')
const TraceSummary$json = {
  '1': 'TraceSummary',
  '2': [
    {'1': 'trace_id', '3': 1, '4': 1, '5': 9, '10': 'traceId'},
    {
      '1': 'start_time',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startTime'
    },
    {
      '1': 'duration',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Duration',
      '10': 'duration'
    },
    {'1': 'root_span_name', '3': 4, '4': 1, '5': 9, '10': 'rootSpanName'},
    {'1': 'project_id', '3': 5, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'environment', '3': 6, '4': 1, '5': 9, '10': 'environment'},
    {'1': 'span_count', '3': 10, '4': 1, '5': 5, '10': 'spanCount'},
    {'1': 'llm_call_count', '3': 11, '4': 1, '5': 5, '10': 'llmCallCount'},
    {'1': 'total_tokens', '3': 12, '4': 1, '5': 3, '10': 'totalTokens'},
    {'1': 'total_cost_usd', '3': 13, '4': 1, '5': 1, '10': 'totalCostUsd'},
    {
      '1': 'status',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.candela.types.SpanStatus',
      '10': 'status'
    },
    {'1': 'primary_model', '3': 15, '4': 1, '5': 9, '10': 'primaryModel'},
    {'1': 'primary_provider', '3': 16, '4': 1, '5': 9, '10': 'primaryProvider'},
    {'1': 'user_id', '3': 17, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'session_id', '3': 18, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'tenant_id', '3': 19, '4': 1, '5': 9, '10': 'tenantId'},
    {'1': 'job_id', '3': 20, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'trace_group', '3': 21, '4': 1, '5': 9, '10': 'traceGroup'},
  ],
};

/// Descriptor for `TraceSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traceSummaryDescriptor = $convert.base64Decode(
    'CgxUcmFjZVN1bW1hcnkSGQoIdHJhY2VfaWQYASABKAlSB3RyYWNlSWQSOQoKc3RhcnRfdGltZR'
    'gCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0VGltZRI1CghkdXJhdGlv'
    'bhgDIAEoCzIZLmdvb2dsZS5wcm90b2J1Zi5EdXJhdGlvblIIZHVyYXRpb24SJAoOcm9vdF9zcG'
    'FuX25hbWUYBCABKAlSDHJvb3RTcGFuTmFtZRIdCgpwcm9qZWN0X2lkGAUgASgJUglwcm9qZWN0'
    'SWQSIAoLZW52aXJvbm1lbnQYBiABKAlSC2Vudmlyb25tZW50Eh0KCnNwYW5fY291bnQYCiABKA'
    'VSCXNwYW5Db3VudBIkCg5sbG1fY2FsbF9jb3VudBgLIAEoBVIMbGxtQ2FsbENvdW50EiEKDHRv'
    'dGFsX3Rva2VucxgMIAEoA1ILdG90YWxUb2tlbnMSJAoOdG90YWxfY29zdF91c2QYDSABKAFSDH'
    'RvdGFsQ29zdFVzZBIxCgZzdGF0dXMYDiABKA4yGS5jYW5kZWxhLnR5cGVzLlNwYW5TdGF0dXNS'
    'BnN0YXR1cxIjCg1wcmltYXJ5X21vZGVsGA8gASgJUgxwcmltYXJ5TW9kZWwSKQoQcHJpbWFyeV'
    '9wcm92aWRlchgQIAEoCVIPcHJpbWFyeVByb3ZpZGVyEhcKB3VzZXJfaWQYESABKAlSBnVzZXJJ'
    'ZBIdCgpzZXNzaW9uX2lkGBIgASgJUglzZXNzaW9uSWQSGwoJdGVuYW50X2lkGBMgASgJUgh0ZW'
    '5hbnRJZBIVCgZqb2JfaWQYFCABKAlSBWpvYklkEh8KC3RyYWNlX2dyb3VwGBUgASgJUgp0cmFj'
    'ZUdyb3Vw');
