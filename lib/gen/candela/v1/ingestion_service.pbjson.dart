//
//  Generated code. Do not modify.
//  source: candela/v1/ingestion_service.proto
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

@$core.Deprecated('Use ingestSpansRequestDescriptor instead')
const IngestSpansRequest$json = {
  '1': 'IngestSpansRequest',
  '2': [
    {
      '1': 'spans',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.types.Span',
      '8': {},
      '10': 'spans'
    },
  ],
};

/// Descriptor for `IngestSpansRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ingestSpansRequestDescriptor = $convert.base64Decode(
    'ChJJbmdlc3RTcGFuc1JlcXVlc3QSNAoFc3BhbnMYASADKAsyEy5jYW5kZWxhLnR5cGVzLlNwYW'
    '5CCbpIBpIBAxDoB1IFc3BhbnM=');

@$core.Deprecated('Use ingestSpansResponseDescriptor instead')
const IngestSpansResponse$json = {
  '1': 'IngestSpansResponse',
  '2': [
    {'1': 'accepted_count', '3': 1, '4': 1, '5': 5, '10': 'acceptedCount'},
    {'1': 'rejected_count', '3': 2, '4': 1, '5': 5, '10': 'rejectedCount'},
    {'1': 'errors', '3': 3, '4': 3, '5': 9, '10': 'errors'},
  ],
};

/// Descriptor for `IngestSpansResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ingestSpansResponseDescriptor = $convert.base64Decode(
    'ChNJbmdlc3RTcGFuc1Jlc3BvbnNlEiUKDmFjY2VwdGVkX2NvdW50GAEgASgFUg1hY2NlcHRlZE'
    'NvdW50EiUKDnJlamVjdGVkX2NvdW50GAIgASgFUg1yZWplY3RlZENvdW50EhYKBmVycm9ycxgD'
    'IAMoCVIGZXJyb3Jz');

const $core.Map<$core.String, $core.dynamic> IngestionServiceBase$json = {
  '1': 'IngestionService',
  '2': [
    {
      '1': 'IngestSpans',
      '2': '.candela.v1.IngestSpansRequest',
      '3': '.candela.v1.IngestSpansResponse'
    },
  ],
};

@$core.Deprecated('Use ingestionServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    IngestionServiceBase$messageJson = {
  '.candela.v1.IngestSpansRequest': IngestSpansRequest$json,
  '.candela.types.Span': $9.Span$json,
  '.google.protobuf.Timestamp': $2.Timestamp$json,
  '.google.protobuf.Duration': $0.Duration$json,
  '.candela.types.GenAIAttributes': $9.GenAIAttributes$json,
  '.candela.types.ToolAttributes': $9.ToolAttributes$json,
  '.candela.types.Attribute': $4.Attribute$json,
  '.candela.types.Span.LabelsEntry': $9.Span_LabelsEntry$json,
  '.candela.types.SpanEvent': $9.SpanEvent$json,
  '.candela.v1.IngestSpansResponse': IngestSpansResponse$json,
};

/// Descriptor for `IngestionService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List ingestionServiceDescriptor = $convert.base64Decode(
    'ChBJbmdlc3Rpb25TZXJ2aWNlEk4KC0luZ2VzdFNwYW5zEh4uY2FuZGVsYS52MS5Jbmdlc3RTcG'
    'Fuc1JlcXVlc3QaHy5jYW5kZWxhLnYxLkluZ2VzdFNwYW5zUmVzcG9uc2U=');
