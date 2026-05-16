//
//  Generated code. Do not modify.
//  source: candela/types/bq_span.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use bqSpanRowDescriptor instead')
const BqSpanRow$json = {
  '1': 'BqSpanRow',
  '2': [
    {'1': 'span_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'spanId'},
    {'1': 'trace_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'traceId'},
    {'1': 'parent_span_id', '3': 3, '4': 1, '5': 9, '10': 'parentSpanId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'kind', '3': 5, '4': 1, '5': 5, '8': {}, '10': 'kind'},
    {'1': 'status', '3': 6, '4': 1, '5': 5, '8': {}, '10': 'status'},
    {'1': 'status_message', '3': 7, '4': 1, '5': 9, '10': 'statusMessage'},
    {
      '1': 'start_time',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '8': {},
      '10': 'startTime'
    },
    {
      '1': 'end_time',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '8': {},
      '10': 'endTime'
    },
    {'1': 'duration_ns', '3': 12, '4': 1, '5': 3, '8': {}, '10': 'durationNs'},
    {'1': 'project_id', '3': 20, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'environment', '3': 21, '4': 1, '5': 9, '10': 'environment'},
    {'1': 'service_name', '3': 22, '4': 1, '5': 9, '10': 'serviceName'},
    {'1': 'user_id', '3': 23, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'session_id', '3': 24, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'tenant_id', '3': 25, '4': 1, '5': 9, '10': 'tenantId'},
    {'1': 'job_id', '3': 26, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'trace_group', '3': 27, '4': 1, '5': 9, '10': 'traceGroup'},
    {'1': 'gen_ai_model', '3': 30, '4': 1, '5': 9, '10': 'genAiModel'},
    {'1': 'gen_ai_provider', '3': 31, '4': 1, '5': 9, '10': 'genAiProvider'},
    {
      '1': 'gen_ai_input_tokens',
      '3': 32,
      '4': 1,
      '5': 3,
      '10': 'genAiInputTokens'
    },
    {
      '1': 'gen_ai_output_tokens',
      '3': 33,
      '4': 1,
      '5': 3,
      '10': 'genAiOutputTokens'
    },
    {
      '1': 'gen_ai_total_tokens',
      '3': 34,
      '4': 1,
      '5': 3,
      '10': 'genAiTotalTokens'
    },
    {'1': 'gen_ai_cost_usd', '3': 35, '4': 1, '5': 1, '10': 'genAiCostUsd'},
    {
      '1': 'gen_ai_temperature',
      '3': 36,
      '4': 1,
      '5': 1,
      '10': 'genAiTemperature'
    },
    {'1': 'gen_ai_max_tokens', '3': 37, '4': 1, '5': 3, '10': 'genAiMaxTokens'},
    {
      '1': 'gen_ai_input_content',
      '3': 38,
      '4': 1,
      '5': 9,
      '10': 'genAiInputContent'
    },
    {
      '1': 'gen_ai_output_content',
      '3': 39,
      '4': 1,
      '5': 9,
      '10': 'genAiOutputContent'
    },
    {
      '1': 'attributes',
      '3': 40,
      '4': 3,
      '5': 11,
      '6': '.candela.types.BqAttribute',
      '10': 'attributes'
    },
    {
      '1': 'labels',
      '3': 41,
      '4': 3,
      '5': 11,
      '6': '.candela.types.BqAttribute',
      '10': 'labels'
    },
  ],
  '7': {},
};

/// Descriptor for `BqSpanRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bqSpanRowDescriptor = $convert.base64Decode(
    'CglCcVNwYW5Sb3cSHgoHc3Bhbl9pZBgBIAEoCUIF6j8CCAFSBnNwYW5JZBIgCgh0cmFjZV9pZB'
    'gCIAEoCUIF6j8CCAFSB3RyYWNlSWQSJAoOcGFyZW50X3NwYW5faWQYAyABKAlSDHBhcmVudFNw'
    'YW5JZBIZCgRuYW1lGAQgASgJQgXqPwIIAVIEbmFtZRIZCgRraW5kGAUgASgFQgXqPwIIAVIEa2'
    'luZBIdCgZzdGF0dXMYBiABKAVCBeo/AggBUgZzdGF0dXMSJQoOc3RhdHVzX21lc3NhZ2UYByAB'
    'KAlSDXN0YXR1c01lc3NhZ2USQAoKc3RhcnRfdGltZRgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBCBeo/AggBUglzdGFydFRpbWUSPAoIZW5kX3RpbWUYCyABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wQgXqPwIIAVIHZW5kVGltZRImCgtkdXJhdGlvbl9ucxgMIAEoA0'
    'IF6j8CCAFSCmR1cmF0aW9uTnMSHQoKcHJvamVjdF9pZBgUIAEoCVIJcHJvamVjdElkEiAKC2Vu'
    'dmlyb25tZW50GBUgASgJUgtlbnZpcm9ubWVudBIhCgxzZXJ2aWNlX25hbWUYFiABKAlSC3Nlcn'
    'ZpY2VOYW1lEhcKB3VzZXJfaWQYFyABKAlSBnVzZXJJZBIdCgpzZXNzaW9uX2lkGBggASgJUglz'
    'ZXNzaW9uSWQSGwoJdGVuYW50X2lkGBkgASgJUgh0ZW5hbnRJZBIVCgZqb2JfaWQYGiABKAlSBW'
    'pvYklkEh8KC3RyYWNlX2dyb3VwGBsgASgJUgp0cmFjZUdyb3VwEiAKDGdlbl9haV9tb2RlbBge'
    'IAEoCVIKZ2VuQWlNb2RlbBImCg9nZW5fYWlfcHJvdmlkZXIYHyABKAlSDWdlbkFpUHJvdmlkZX'
    'ISLQoTZ2VuX2FpX2lucHV0X3Rva2VucxggIAEoA1IQZ2VuQWlJbnB1dFRva2VucxIvChRnZW5f'
    'YWlfb3V0cHV0X3Rva2VucxghIAEoA1IRZ2VuQWlPdXRwdXRUb2tlbnMSLQoTZ2VuX2FpX3RvdG'
    'FsX3Rva2VucxgiIAEoA1IQZ2VuQWlUb3RhbFRva2VucxIlCg9nZW5fYWlfY29zdF91c2QYIyAB'
    'KAFSDGdlbkFpQ29zdFVzZBIsChJnZW5fYWlfdGVtcGVyYXR1cmUYJCABKAFSEGdlbkFpVGVtcG'
    'VyYXR1cmUSKQoRZ2VuX2FpX21heF90b2tlbnMYJSABKANSDmdlbkFpTWF4VG9rZW5zEi8KFGdl'
    'bl9haV9pbnB1dF9jb250ZW50GCYgASgJUhFnZW5BaUlucHV0Q29udGVudBIxChVnZW5fYWlfb3'
    'V0cHV0X2NvbnRlbnQYJyABKAlSEmdlbkFpT3V0cHV0Q29udGVudBI6CgphdHRyaWJ1dGVzGCgg'
    'AygLMhouY2FuZGVsYS50eXBlcy5CcUF0dHJpYnV0ZVIKYXR0cmlidXRlcxIyCgZsYWJlbHMYKS'
    'ADKAsyGi5jYW5kZWxhLnR5cGVzLkJxQXR0cmlidXRlUgZsYWJlbHM6Cuo/BwoFc3BhbnM=');

@$core.Deprecated('Use bqAttributeDescriptor instead')
const BqAttribute$json = {
  '1': 'BqAttribute',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'value'},
  ],
};

/// Descriptor for `BqAttribute`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bqAttributeDescriptor = $convert.base64Decode(
    'CgtCcUF0dHJpYnV0ZRIXCgNrZXkYASABKAlCBeo/AggBUgNrZXkSGwoFdmFsdWUYAiABKAlCBe'
    'o/AggBUgV2YWx1ZQ==');
