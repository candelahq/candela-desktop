//
//  Generated code. Do not modify.
//  source: candela/types/annotation.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use annotationTypeDescriptor instead')
const AnnotationType$json = {
  '1': 'AnnotationType',
  '2': [
    {'1': 'ANNOTATION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'ANNOTATION_TYPE_OUTCOME', '2': 1},
    {'1': 'ANNOTATION_TYPE_LABEL', '2': 2},
    {'1': 'ANNOTATION_TYPE_METRIC', '2': 3},
  ],
};

/// Descriptor for `AnnotationType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List annotationTypeDescriptor = $convert.base64Decode(
    'Cg5Bbm5vdGF0aW9uVHlwZRIfChtBTk5PVEFUSU9OX1RZUEVfVU5TUEVDSUZJRUQQABIbChdBTk'
    '5PVEFUSU9OX1RZUEVfT1VUQ09NRRABEhkKFUFOTk9UQVRJT05fVFlQRV9MQUJFTBACEhoKFkFO'
    'Tk9UQVRJT05fVFlQRV9NRVRSSUMQAw==');

@$core.Deprecated('Use annotationDescriptor instead')
const Annotation$json = {
  '1': 'Annotation',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'trace_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'traceId'},
    {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.candela.types.AnnotationType',
      '8': {},
      '10': 'type'
    },
    {'1': 'success', '3': 10, '4': 1, '5': 8, '10': 'success'},
    {'1': 'score', '3': 11, '4': 1, '5': 1, '8': {}, '10': 'score'},
    {'1': 'label', '3': 20, '4': 1, '5': 9, '10': 'label'},
    {'1': 'reviewer', '3': 21, '4': 1, '5': 9, '10': 'reviewer'},
    {'1': 'metric_name', '3': 30, '4': 1, '5': 9, '10': 'metricName'},
    {'1': 'metric_value', '3': 31, '4': 1, '5': 1, '10': 'metricValue'},
    {'1': 'comment', '3': 40, '4': 1, '5': 9, '10': 'comment'},
    {
      '1': 'created_at',
      '3': 50,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '8': {},
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `Annotation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List annotationDescriptor = $convert.base64Decode(
    'CgpBbm5vdGF0aW9uEhcKAmlkGAEgASgJQge6SARyAhABUgJpZBIiCgh0cmFjZV9pZBgCIAEoCU'
    'IHukgEcgIQAVIHdHJhY2VJZBI9CgR0eXBlGAMgASgOMh0uY2FuZGVsYS50eXBlcy5Bbm5vdGF0'
    'aW9uVHlwZUIKukgHggEEEAEgAFIEdHlwZRIYCgdzdWNjZXNzGAogASgIUgdzdWNjZXNzEi0KBX'
    'Njb3JlGAsgASgBQhe6SBQSEhkAAAAAAADwPykAAAAAAAAAAFIFc2NvcmUSFAoFbGFiZWwYFCAB'
    'KAlSBWxhYmVsEhoKCHJldmlld2VyGBUgASgJUghyZXZpZXdlchIfCgttZXRyaWNfbmFtZRgeIA'
    'EoCVIKbWV0cmljTmFtZRIhCgxtZXRyaWNfdmFsdWUYHyABKAFSC21ldHJpY1ZhbHVlEhgKB2Nv'
    'bW1lbnQYKCABKAlSB2NvbW1lbnQSQQoKY3JlYXRlZF9hdBgyIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBCBrpIA8gBAVIJY3JlYXRlZEF0');
