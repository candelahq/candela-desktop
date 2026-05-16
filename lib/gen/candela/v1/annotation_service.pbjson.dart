//
//  Generated code. Do not modify.
//  source: candela/v1/annotation_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../google/protobuf/timestamp.pbjson.dart' as $2;
import '../types/annotation.pbjson.dart' as $5;

@$core.Deprecated('Use setOutcomeRequestDescriptor instead')
const SetOutcomeRequest$json = {
  '1': 'SetOutcomeRequest',
  '2': [
    {'1': 'trace_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'traceId'},
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
    {'1': 'score', '3': 3, '4': 1, '5': 1, '8': {}, '10': 'score'},
    {'1': 'comment', '3': 4, '4': 1, '5': 9, '10': 'comment'},
  ],
};

/// Descriptor for `SetOutcomeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setOutcomeRequestDescriptor = $convert.base64Decode(
    'ChFTZXRPdXRjb21lUmVxdWVzdBIiCgh0cmFjZV9pZBgBIAEoCUIHukgEcgIQAVIHdHJhY2VJZB'
    'IYCgdzdWNjZXNzGAIgASgIUgdzdWNjZXNzEi0KBXNjb3JlGAMgASgBQhe6SBQSEhkAAAAAAADw'
    'PykAAAAAAAAAAFIFc2NvcmUSGAoHY29tbWVudBgEIAEoCVIHY29tbWVudA==');

@$core.Deprecated('Use setOutcomeResponseDescriptor instead')
const SetOutcomeResponse$json = {
  '1': 'SetOutcomeResponse',
  '2': [
    {
      '1': 'annotation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.Annotation',
      '10': 'annotation'
    },
  ],
};

/// Descriptor for `SetOutcomeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setOutcomeResponseDescriptor = $convert.base64Decode(
    'ChJTZXRPdXRjb21lUmVzcG9uc2USOQoKYW5ub3RhdGlvbhgBIAEoCzIZLmNhbmRlbGEudHlwZX'
    'MuQW5ub3RhdGlvblIKYW5ub3RhdGlvbg==');

@$core.Deprecated('Use addLabelRequestDescriptor instead')
const AddLabelRequest$json = {
  '1': 'AddLabelRequest',
  '2': [
    {'1': 'trace_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'traceId'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'label'},
    {'1': 'reviewer', '3': 3, '4': 1, '5': 9, '10': 'reviewer'},
    {'1': 'comment', '3': 4, '4': 1, '5': 9, '10': 'comment'},
  ],
};

/// Descriptor for `AddLabelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addLabelRequestDescriptor = $convert.base64Decode(
    'Cg9BZGRMYWJlbFJlcXVlc3QSIgoIdHJhY2VfaWQYASABKAlCB7pIBHICEAFSB3RyYWNlSWQSHQ'
    'oFbGFiZWwYAiABKAlCB7pIBHICEAFSBWxhYmVsEhoKCHJldmlld2VyGAMgASgJUghyZXZpZXdl'
    'chIYCgdjb21tZW50GAQgASgJUgdjb21tZW50');

@$core.Deprecated('Use addLabelResponseDescriptor instead')
const AddLabelResponse$json = {
  '1': 'AddLabelResponse',
  '2': [
    {
      '1': 'annotation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.Annotation',
      '10': 'annotation'
    },
  ],
};

/// Descriptor for `AddLabelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addLabelResponseDescriptor = $convert.base64Decode(
    'ChBBZGRMYWJlbFJlc3BvbnNlEjkKCmFubm90YXRpb24YASABKAsyGS5jYW5kZWxhLnR5cGVzLk'
    'Fubm90YXRpb25SCmFubm90YXRpb24=');

@$core.Deprecated('Use logMetricRequestDescriptor instead')
const LogMetricRequest$json = {
  '1': 'LogMetricRequest',
  '2': [
    {'1': 'trace_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'traceId'},
    {'1': 'metric_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'metricName'},
    {'1': 'metric_value', '3': 3, '4': 1, '5': 1, '10': 'metricValue'},
    {'1': 'comment', '3': 4, '4': 1, '5': 9, '10': 'comment'},
  ],
};

/// Descriptor for `LogMetricRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logMetricRequestDescriptor = $convert.base64Decode(
    'ChBMb2dNZXRyaWNSZXF1ZXN0EiIKCHRyYWNlX2lkGAEgASgJQge6SARyAhABUgd0cmFjZUlkEi'
    'gKC21ldHJpY19uYW1lGAIgASgJQge6SARyAhABUgptZXRyaWNOYW1lEiEKDG1ldHJpY192YWx1'
    'ZRgDIAEoAVILbWV0cmljVmFsdWUSGAoHY29tbWVudBgEIAEoCVIHY29tbWVudA==');

@$core.Deprecated('Use logMetricResponseDescriptor instead')
const LogMetricResponse$json = {
  '1': 'LogMetricResponse',
  '2': [
    {
      '1': 'annotation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.Annotation',
      '10': 'annotation'
    },
  ],
};

/// Descriptor for `LogMetricResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logMetricResponseDescriptor = $convert.base64Decode(
    'ChFMb2dNZXRyaWNSZXNwb25zZRI5Cgphbm5vdGF0aW9uGAEgASgLMhkuY2FuZGVsYS50eXBlcy'
    '5Bbm5vdGF0aW9uUgphbm5vdGF0aW9u');

@$core.Deprecated('Use listAnnotationsRequestDescriptor instead')
const ListAnnotationsRequest$json = {
  '1': 'ListAnnotationsRequest',
  '2': [
    {'1': 'trace_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'traceId'},
    {
      '1': 'type_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.candela.types.AnnotationType',
      '10': 'typeFilter'
    },
  ],
};

/// Descriptor for `ListAnnotationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAnnotationsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0QW5ub3RhdGlvbnNSZXF1ZXN0EiIKCHRyYWNlX2lkGAEgASgJQge6SARyAhABUgd0cm'
    'FjZUlkEj4KC3R5cGVfZmlsdGVyGAIgASgOMh0uY2FuZGVsYS50eXBlcy5Bbm5vdGF0aW9uVHlw'
    'ZVIKdHlwZUZpbHRlcg==');

@$core.Deprecated('Use listAnnotationsResponseDescriptor instead')
const ListAnnotationsResponse$json = {
  '1': 'ListAnnotationsResponse',
  '2': [
    {
      '1': 'annotations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.types.Annotation',
      '10': 'annotations'
    },
  ],
};

/// Descriptor for `ListAnnotationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAnnotationsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0QW5ub3RhdGlvbnNSZXNwb25zZRI7Cgthbm5vdGF0aW9ucxgBIAMoCzIZLmNhbmRlbG'
        'EudHlwZXMuQW5ub3RhdGlvblILYW5ub3RhdGlvbnM=');

const $core.Map<$core.String, $core.dynamic> AnnotationServiceBase$json = {
  '1': 'AnnotationService',
  '2': [
    {
      '1': 'SetOutcome',
      '2': '.candela.v1.SetOutcomeRequest',
      '3': '.candela.v1.SetOutcomeResponse'
    },
    {
      '1': 'AddLabel',
      '2': '.candela.v1.AddLabelRequest',
      '3': '.candela.v1.AddLabelResponse'
    },
    {
      '1': 'LogMetric',
      '2': '.candela.v1.LogMetricRequest',
      '3': '.candela.v1.LogMetricResponse'
    },
    {
      '1': 'ListAnnotations',
      '2': '.candela.v1.ListAnnotationsRequest',
      '3': '.candela.v1.ListAnnotationsResponse'
    },
  ],
};

@$core.Deprecated('Use annotationServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AnnotationServiceBase$messageJson = {
  '.candela.v1.SetOutcomeRequest': SetOutcomeRequest$json,
  '.candela.v1.SetOutcomeResponse': SetOutcomeResponse$json,
  '.candela.types.Annotation': $5.Annotation$json,
  '.google.protobuf.Timestamp': $2.Timestamp$json,
  '.candela.v1.AddLabelRequest': AddLabelRequest$json,
  '.candela.v1.AddLabelResponse': AddLabelResponse$json,
  '.candela.v1.LogMetricRequest': LogMetricRequest$json,
  '.candela.v1.LogMetricResponse': LogMetricResponse$json,
  '.candela.v1.ListAnnotationsRequest': ListAnnotationsRequest$json,
  '.candela.v1.ListAnnotationsResponse': ListAnnotationsResponse$json,
};

/// Descriptor for `AnnotationService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List annotationServiceDescriptor = $convert.base64Decode(
    'ChFBbm5vdGF0aW9uU2VydmljZRJLCgpTZXRPdXRjb21lEh0uY2FuZGVsYS52MS5TZXRPdXRjb2'
    '1lUmVxdWVzdBoeLmNhbmRlbGEudjEuU2V0T3V0Y29tZVJlc3BvbnNlEkUKCEFkZExhYmVsEhsu'
    'Y2FuZGVsYS52MS5BZGRMYWJlbFJlcXVlc3QaHC5jYW5kZWxhLnYxLkFkZExhYmVsUmVzcG9uc2'
    'USSAoJTG9nTWV0cmljEhwuY2FuZGVsYS52MS5Mb2dNZXRyaWNSZXF1ZXN0Gh0uY2FuZGVsYS52'
    'MS5Mb2dNZXRyaWNSZXNwb25zZRJaCg9MaXN0QW5ub3RhdGlvbnMSIi5jYW5kZWxhLnYxLkxpc3'
    'RBbm5vdGF0aW9uc1JlcXVlc3QaIy5jYW5kZWxhLnYxLkxpc3RBbm5vdGF0aW9uc1Jlc3BvbnNl');
