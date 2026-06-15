//
//  Generated code. Do not modify.
//  source: candela/v1/model_catalog_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../google/protobuf/field_mask.pbjson.dart' as $1;
import '../../google/protobuf/timestamp.pbjson.dart' as $2;
import '../types/model_catalog.pbjson.dart' as $11;

@$core.Deprecated('Use listModelCatalogRequestDescriptor instead')
const ListModelCatalogRequest$json = {
  '1': 'ListModelCatalogRequest',
  '2': [
    {'1': 'include_disabled', '3': 1, '4': 1, '5': 8, '10': 'includeDisabled'},
  ],
};

/// Descriptor for `ListModelCatalogRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listModelCatalogRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0TW9kZWxDYXRhbG9nUmVxdWVzdBIpChBpbmNsdWRlX2Rpc2FibGVkGAEgASgIUg9pbm'
        'NsdWRlRGlzYWJsZWQ=');

@$core.Deprecated('Use listModelCatalogResponseDescriptor instead')
const ListModelCatalogResponse$json = {
  '1': 'ListModelCatalogResponse',
  '2': [
    {
      '1': 'models',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.types.ModelCatalogEntry',
      '10': 'models'
    },
    {'1': 'source', '3': 2, '4': 1, '5': 9, '10': 'source'},
    {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
    {'1': 'admin_editable', '3': 4, '4': 1, '5': 8, '10': 'adminEditable'},
  ],
};

/// Descriptor for `ListModelCatalogResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listModelCatalogResponseDescriptor = $convert.base64Decode(
    'ChhMaXN0TW9kZWxDYXRhbG9nUmVzcG9uc2USOAoGbW9kZWxzGAEgAygLMiAuY2FuZGVsYS50eX'
    'Blcy5Nb2RlbENhdGFsb2dFbnRyeVIGbW9kZWxzEhYKBnNvdXJjZRgCIAEoCVIGc291cmNlEhgK'
    'B3ZlcnNpb24YAyABKAlSB3ZlcnNpb24SJQoOYWRtaW5fZWRpdGFibGUYBCABKAhSDWFkbWluRW'
    'RpdGFibGU=');

@$core.Deprecated('Use updateModelCatalogEntryRequestDescriptor instead')
const UpdateModelCatalogEntryRequest$json = {
  '1': 'UpdateModelCatalogEntryRequest',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.ModelCatalogEntry',
      '10': 'entry'
    },
    {
      '1': 'update_mask',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldMask',
      '10': 'updateMask'
    },
  ],
};

/// Descriptor for `UpdateModelCatalogEntryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateModelCatalogEntryRequestDescriptor =
    $convert.base64Decode(
        'Ch5VcGRhdGVNb2RlbENhdGFsb2dFbnRyeVJlcXVlc3QSNgoFZW50cnkYASABKAsyIC5jYW5kZW'
        'xhLnR5cGVzLk1vZGVsQ2F0YWxvZ0VudHJ5UgVlbnRyeRI7Cgt1cGRhdGVfbWFzaxgCIAEoCzIa'
        'Lmdvb2dsZS5wcm90b2J1Zi5GaWVsZE1hc2tSCnVwZGF0ZU1hc2s=');

@$core.Deprecated('Use updateModelCatalogEntryResponseDescriptor instead')
const UpdateModelCatalogEntryResponse$json = {
  '1': 'UpdateModelCatalogEntryResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.ModelCatalogEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `UpdateModelCatalogEntryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateModelCatalogEntryResponseDescriptor =
    $convert.base64Decode(
        'Ch9VcGRhdGVNb2RlbENhdGFsb2dFbnRyeVJlc3BvbnNlEjYKBWVudHJ5GAEgASgLMiAuY2FuZG'
        'VsYS50eXBlcy5Nb2RlbENhdGFsb2dFbnRyeVIFZW50cnk=');

@$core.Deprecated('Use deleteModelCatalogEntryRequestDescriptor instead')
const DeleteModelCatalogEntryRequest$json = {
  '1': 'DeleteModelCatalogEntryRequest',
  '2': [
    {'1': 'provider', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'provider'},
    {'1': 'model_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modelId'},
  ],
};

/// Descriptor for `DeleteModelCatalogEntryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteModelCatalogEntryRequestDescriptor =
    $convert.base64Decode(
        'Ch5EZWxldGVNb2RlbENhdGFsb2dFbnRyeVJlcXVlc3QSIwoIcHJvdmlkZXIYASABKAlCB7pIBH'
        'ICEAFSCHByb3ZpZGVyEiIKCG1vZGVsX2lkGAIgASgJQge6SARyAhABUgdtb2RlbElk');

@$core.Deprecated('Use deleteModelCatalogEntryResponseDescriptor instead')
const DeleteModelCatalogEntryResponse$json = {
  '1': 'DeleteModelCatalogEntryResponse',
};

/// Descriptor for `DeleteModelCatalogEntryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteModelCatalogEntryResponseDescriptor =
    $convert.base64Decode('Ch9EZWxldGVNb2RlbENhdGFsb2dFbnRyeVJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> ModelCatalogServiceBase$json = {
  '1': 'ModelCatalogService',
  '2': [
    {
      '1': 'ListModelCatalog',
      '2': '.candela.v1.ListModelCatalogRequest',
      '3': '.candela.v1.ListModelCatalogResponse'
    },
    {
      '1': 'UpdateModelCatalogEntry',
      '2': '.candela.v1.UpdateModelCatalogEntryRequest',
      '3': '.candela.v1.UpdateModelCatalogEntryResponse'
    },
    {
      '1': 'DeleteModelCatalogEntry',
      '2': '.candela.v1.DeleteModelCatalogEntryRequest',
      '3': '.candela.v1.DeleteModelCatalogEntryResponse'
    },
  ],
};

@$core.Deprecated('Use modelCatalogServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ModelCatalogServiceBase$messageJson = {
  '.candela.v1.ListModelCatalogRequest': ListModelCatalogRequest$json,
  '.candela.v1.ListModelCatalogResponse': ListModelCatalogResponse$json,
  '.candela.types.ModelCatalogEntry': $11.ModelCatalogEntry$json,
  '.google.protobuf.Timestamp': $2.Timestamp$json,
  '.candela.v1.UpdateModelCatalogEntryRequest':
      UpdateModelCatalogEntryRequest$json,
  '.google.protobuf.FieldMask': $1.FieldMask$json,
  '.candela.v1.UpdateModelCatalogEntryResponse':
      UpdateModelCatalogEntryResponse$json,
  '.candela.v1.DeleteModelCatalogEntryRequest':
      DeleteModelCatalogEntryRequest$json,
  '.candela.v1.DeleteModelCatalogEntryResponse':
      DeleteModelCatalogEntryResponse$json,
};

/// Descriptor for `ModelCatalogService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List modelCatalogServiceDescriptor = $convert.base64Decode(
    'ChNNb2RlbENhdGFsb2dTZXJ2aWNlEl0KEExpc3RNb2RlbENhdGFsb2cSIy5jYW5kZWxhLnYxLk'
    'xpc3RNb2RlbENhdGFsb2dSZXF1ZXN0GiQuY2FuZGVsYS52MS5MaXN0TW9kZWxDYXRhbG9nUmVz'
    'cG9uc2UScgoXVXBkYXRlTW9kZWxDYXRhbG9nRW50cnkSKi5jYW5kZWxhLnYxLlVwZGF0ZU1vZG'
    'VsQ2F0YWxvZ0VudHJ5UmVxdWVzdBorLmNhbmRlbGEudjEuVXBkYXRlTW9kZWxDYXRhbG9nRW50'
    'cnlSZXNwb25zZRJyChdEZWxldGVNb2RlbENhdGFsb2dFbnRyeRIqLmNhbmRlbGEudjEuRGVsZX'
    'RlTW9kZWxDYXRhbG9nRW50cnlSZXF1ZXN0GisuY2FuZGVsYS52MS5EZWxldGVNb2RlbENhdGFs'
    'b2dFbnRyeVJlc3BvbnNl');
