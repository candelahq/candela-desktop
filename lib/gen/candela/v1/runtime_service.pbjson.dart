//
//  Generated code. Do not modify.
//  source: candela/v1/runtime_service.proto
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

@$core.Deprecated('Use runtimeStateDescriptor instead')
const RuntimeState$json = {
  '1': 'RuntimeState',
  '2': [
    {'1': 'RUNTIME_STATE_UNSPECIFIED', '2': 0},
    {'1': 'RUNTIME_STATE_STOPPED', '2': 1},
    {'1': 'RUNTIME_STATE_STARTING', '2': 2},
    {'1': 'RUNTIME_STATE_RUNNING', '2': 3},
    {'1': 'RUNTIME_STATE_ERROR', '2': 4},
  ],
};

/// Descriptor for `RuntimeState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List runtimeStateDescriptor = $convert.base64Decode(
    'CgxSdW50aW1lU3RhdGUSHQoZUlVOVElNRV9TVEFURV9VTlNQRUNJRklFRBAAEhkKFVJVTlRJTU'
    'VfU1RBVEVfU1RPUFBFRBABEhoKFlJVTlRJTUVfU1RBVEVfU1RBUlRJTkcQAhIZChVSVU5USU1F'
    'X1NUQVRFX1JVTk5JTkcQAxIXChNSVU5USU1FX1NUQVRFX0VSUk9SEAQ=');

@$core.Deprecated('Use modelLoadStateDescriptor instead')
const ModelLoadState$json = {
  '1': 'ModelLoadState',
  '2': [
    {'1': 'MODEL_LOAD_STATE_UNSPECIFIED', '2': 0},
    {'1': 'MODEL_LOAD_STATE_LOADED', '2': 1},
    {'1': 'MODEL_LOAD_STATE_STARTING', '2': 2},
  ],
};

/// Descriptor for `ModelLoadState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List modelLoadStateDescriptor = $convert.base64Decode(
    'Cg5Nb2RlbExvYWRTdGF0ZRIgChxNT0RFTF9MT0FEX1NUQVRFX1VOU1BFQ0lGSUVEEAASGwoXTU'
    '9ERUxfTE9BRF9TVEFURV9MT0FERUQQARIdChlNT0RFTF9MT0FEX1NUQVRFX1NUQVJUSU5HEAI=');

@$core.Deprecated('Use runtimeStatusDescriptor instead')
const RuntimeStatus$json = {
  '1': 'RuntimeStatus',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.candela.v1.RuntimeState',
      '10': 'state'
    },
    {'1': 'backend', '3': 2, '4': 1, '5': 9, '10': 'backend'},
    {'1': 'endpoint', '3': 3, '4': 1, '5': 9, '10': 'endpoint'},
    {'1': 'uptime_seconds', '3': 4, '4': 1, '5': 1, '10': 'uptimeSeconds'},
    {'1': 'error', '3': 5, '4': 1, '5': 9, '10': 'error'},
    {
      '1': 'checked_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'checkedAt'
    },
  ],
};

/// Descriptor for `RuntimeStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runtimeStatusDescriptor = $convert.base64Decode(
    'Cg1SdW50aW1lU3RhdHVzEi4KBXN0YXRlGAEgASgOMhguY2FuZGVsYS52MS5SdW50aW1lU3RhdG'
    'VSBXN0YXRlEhgKB2JhY2tlbmQYAiABKAlSB2JhY2tlbmQSGgoIZW5kcG9pbnQYAyABKAlSCGVu'
    'ZHBvaW50EiUKDnVwdGltZV9zZWNvbmRzGAQgASgBUg11cHRpbWVTZWNvbmRzEhQKBWVycm9yGA'
    'UgASgJUgVlcnJvchI5CgpjaGVja2VkX2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVz'
    'dGFtcFIJY2hlY2tlZEF0');

@$core.Deprecated('Use runtimeModelDescriptor instead')
const RuntimeModel$json = {
  '1': 'RuntimeModel',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'size_bytes', '3': 2, '4': 1, '5': 3, '10': 'sizeBytes'},
    {'1': 'family', '3': 3, '4': 1, '5': 9, '10': 'family'},
    {'1': 'parameters', '3': 4, '4': 1, '5': 9, '10': 'parameters'},
    {'1': 'quantization', '3': 5, '4': 1, '5': 9, '10': 'quantization'},
    {'1': 'loaded', '3': 6, '4': 1, '5': 8, '10': 'loaded'},
    {'1': 'available', '3': 7, '4': 1, '5': 8, '10': 'available'},
    {
      '1': 'last_used',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastUsed'
    },
  ],
};

/// Descriptor for `RuntimeModel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runtimeModelDescriptor = $convert.base64Decode(
    'CgxSdW50aW1lTW9kZWwSDgoCaWQYASABKAlSAmlkEh0KCnNpemVfYnl0ZXMYAiABKANSCXNpem'
    'VCeXRlcxIWCgZmYW1pbHkYAyABKAlSBmZhbWlseRIeCgpwYXJhbWV0ZXJzGAQgASgJUgpwYXJh'
    'bWV0ZXJzEiIKDHF1YW50aXphdGlvbhgFIAEoCVIMcXVhbnRpemF0aW9uEhYKBmxvYWRlZBgGIA'
    'EoCFIGbG9hZGVkEhwKCWF2YWlsYWJsZRgHIAEoCFIJYXZhaWxhYmxlEjcKCWxhc3RfdXNlZBgI'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGxhc3RVc2Vk');

@$core.Deprecated('Use backendInfoDescriptor instead')
const BackendInfo$json = {
  '1': 'BackendInfo',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'installed', '3': 2, '4': 1, '5': 8, '10': 'installed'},
    {'1': 'binary_path', '3': 3, '4': 1, '5': 9, '10': 'binaryPath'},
    {'1': 'install_hint', '3': 4, '4': 1, '5': 9, '10': 'installHint'},
  ],
};

/// Descriptor for `BackendInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backendInfoDescriptor = $convert.base64Decode(
    'CgtCYWNrZW5kSW5mbxISCgRuYW1lGAEgASgJUgRuYW1lEhwKCWluc3RhbGxlZBgCIAEoCFIJaW'
    '5zdGFsbGVkEh8KC2JpbmFyeV9wYXRoGAMgASgJUgpiaW5hcnlQYXRoEiEKDGluc3RhbGxfaGlu'
    'dBgEIAEoCVILaW5zdGFsbEhpbnQ=');

@$core.Deprecated('Use startRuntimeRequestDescriptor instead')
const StartRuntimeRequest$json = {
  '1': 'StartRuntimeRequest',
  '2': [
    {'1': 'backend', '3': 1, '4': 1, '5': 9, '10': 'backend'},
  ],
};

/// Descriptor for `StartRuntimeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRuntimeRequestDescriptor =
    $convert.base64Decode(
        'ChNTdGFydFJ1bnRpbWVSZXF1ZXN0EhgKB2JhY2tlbmQYASABKAlSB2JhY2tlbmQ=');

@$core.Deprecated('Use startRuntimeResponseDescriptor instead')
const StartRuntimeResponse$json = {
  '1': 'StartRuntimeResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.v1.RuntimeStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `StartRuntimeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRuntimeResponseDescriptor = $convert.base64Decode(
    'ChRTdGFydFJ1bnRpbWVSZXNwb25zZRIxCgZzdGF0dXMYASABKAsyGS5jYW5kZWxhLnYxLlJ1bn'
    'RpbWVTdGF0dXNSBnN0YXR1cw==');

@$core.Deprecated('Use stopRuntimeRequestDescriptor instead')
const StopRuntimeRequest$json = {
  '1': 'StopRuntimeRequest',
};

/// Descriptor for `StopRuntimeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopRuntimeRequestDescriptor =
    $convert.base64Decode('ChJTdG9wUnVudGltZVJlcXVlc3Q=');

@$core.Deprecated('Use stopRuntimeResponseDescriptor instead')
const StopRuntimeResponse$json = {
  '1': 'StopRuntimeResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.v1.RuntimeStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `StopRuntimeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopRuntimeResponseDescriptor = $convert.base64Decode(
    'ChNTdG9wUnVudGltZVJlc3BvbnNlEjEKBnN0YXR1cxgBIAEoCzIZLmNhbmRlbGEudjEuUnVudG'
    'ltZVN0YXR1c1IGc3RhdHVz');

@$core.Deprecated('Use getHealthRequestDescriptor instead')
const GetHealthRequest$json = {
  '1': 'GetHealthRequest',
};

/// Descriptor for `GetHealthRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHealthRequestDescriptor =
    $convert.base64Decode('ChBHZXRIZWFsdGhSZXF1ZXN0');

@$core.Deprecated('Use getHealthResponseDescriptor instead')
const GetHealthResponse$json = {
  '1': 'GetHealthResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.v1.RuntimeStatus',
      '10': 'status'
    },
    {
      '1': 'models',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.candela.v1.RuntimeModel',
      '10': 'models'
    },
  ],
};

/// Descriptor for `GetHealthResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHealthResponseDescriptor = $convert.base64Decode(
    'ChFHZXRIZWFsdGhSZXNwb25zZRIxCgZzdGF0dXMYASABKAsyGS5jYW5kZWxhLnYxLlJ1bnRpbW'
    'VTdGF0dXNSBnN0YXR1cxIwCgZtb2RlbHMYAiADKAsyGC5jYW5kZWxhLnYxLlJ1bnRpbWVNb2Rl'
    'bFIGbW9kZWxz');

@$core.Deprecated('Use loadModelRequestDescriptor instead')
const LoadModelRequest$json = {
  '1': 'LoadModelRequest',
  '2': [
    {'1': 'model', '3': 1, '4': 1, '5': 9, '10': 'model'},
  ],
};

/// Descriptor for `LoadModelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadModelRequestDescriptor = $convert
    .base64Decode('ChBMb2FkTW9kZWxSZXF1ZXN0EhQKBW1vZGVsGAEgASgJUgVtb2RlbA==');

@$core.Deprecated('Use loadModelResponseDescriptor instead')
const LoadModelResponse$json = {
  '1': 'LoadModelResponse',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.candela.v1.ModelLoadState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `LoadModelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadModelResponseDescriptor = $convert.base64Decode(
    'ChFMb2FkTW9kZWxSZXNwb25zZRIwCgVzdGF0ZRgBIAEoDjIaLmNhbmRlbGEudjEuTW9kZWxMb2'
    'FkU3RhdGVSBXN0YXRl');

@$core.Deprecated('Use unloadModelRequestDescriptor instead')
const UnloadModelRequest$json = {
  '1': 'UnloadModelRequest',
  '2': [
    {'1': 'model', '3': 1, '4': 1, '5': 9, '10': 'model'},
  ],
};

/// Descriptor for `UnloadModelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unloadModelRequestDescriptor = $convert
    .base64Decode('ChJVbmxvYWRNb2RlbFJlcXVlc3QSFAoFbW9kZWwYASABKAlSBW1vZGVs');

@$core.Deprecated('Use unloadModelResponseDescriptor instead')
const UnloadModelResponse$json = {
  '1': 'UnloadModelResponse',
};

/// Descriptor for `UnloadModelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unloadModelResponseDescriptor =
    $convert.base64Decode('ChNVbmxvYWRNb2RlbFJlc3BvbnNl');

@$core.Deprecated('Use listModelsRequestDescriptor instead')
const ListModelsRequest$json = {
  '1': 'ListModelsRequest',
};

/// Descriptor for `ListModelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listModelsRequestDescriptor =
    $convert.base64Decode('ChFMaXN0TW9kZWxzUmVxdWVzdA==');

@$core.Deprecated('Use listModelsResponseDescriptor instead')
const ListModelsResponse$json = {
  '1': 'ListModelsResponse',
  '2': [
    {
      '1': 'models',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.v1.RuntimeModel',
      '10': 'models'
    },
  ],
};

/// Descriptor for `ListModelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listModelsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0TW9kZWxzUmVzcG9uc2USMAoGbW9kZWxzGAEgAygLMhguY2FuZGVsYS52MS5SdW50aW'
    '1lTW9kZWxSBm1vZGVscw==');

@$core.Deprecated('Use pullModelRequestDescriptor instead')
const PullModelRequest$json = {
  '1': 'PullModelRequest',
  '2': [
    {'1': 'model', '3': 1, '4': 1, '5': 9, '10': 'model'},
  ],
};

/// Descriptor for `PullModelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pullModelRequestDescriptor = $convert
    .base64Decode('ChBQdWxsTW9kZWxSZXF1ZXN0EhQKBW1vZGVsGAEgASgJUgVtb2RlbA==');

@$core.Deprecated('Use pullModelResponseDescriptor instead')
const PullModelResponse$json = {
  '1': 'PullModelResponse',
};

/// Descriptor for `PullModelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pullModelResponseDescriptor =
    $convert.base64Decode('ChFQdWxsTW9kZWxSZXNwb25zZQ==');

@$core.Deprecated('Use listBackendsRequestDescriptor instead')
const ListBackendsRequest$json = {
  '1': 'ListBackendsRequest',
};

/// Descriptor for `ListBackendsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBackendsRequestDescriptor =
    $convert.base64Decode('ChNMaXN0QmFja2VuZHNSZXF1ZXN0');

@$core.Deprecated('Use listBackendsResponseDescriptor instead')
const ListBackendsResponse$json = {
  '1': 'ListBackendsResponse',
  '2': [
    {
      '1': 'backends',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.v1.BackendInfo',
      '10': 'backends'
    },
    {'1': 'active', '3': 2, '4': 1, '5': 9, '10': 'active'},
  ],
};

/// Descriptor for `ListBackendsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBackendsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0QmFja2VuZHNSZXNwb25zZRIzCghiYWNrZW5kcxgBIAMoCzIXLmNhbmRlbGEudjEuQm'
    'Fja2VuZEluZm9SCGJhY2tlbmRzEhYKBmFjdGl2ZRgCIAEoCVIGYWN0aXZl');

@$core.Deprecated('Use resetStateRequestDescriptor instead')
const ResetStateRequest$json = {
  '1': 'ResetStateRequest',
};

/// Descriptor for `ResetStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetStateRequestDescriptor =
    $convert.base64Decode('ChFSZXNldFN0YXRlUmVxdWVzdA==');

@$core.Deprecated('Use resetStateResponseDescriptor instead')
const ResetStateResponse$json = {
  '1': 'ResetStateResponse',
};

/// Descriptor for `ResetStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetStateResponseDescriptor =
    $convert.base64Decode('ChJSZXNldFN0YXRlUmVzcG9uc2U=');

@$core.Deprecated('Use cancelPullRequestDescriptor instead')
const CancelPullRequest$json = {
  '1': 'CancelPullRequest',
  '2': [
    {'1': 'model', '3': 1, '4': 1, '5': 9, '10': 'model'},
  ],
};

/// Descriptor for `CancelPullRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelPullRequestDescriptor = $convert
    .base64Decode('ChFDYW5jZWxQdWxsUmVxdWVzdBIUCgVtb2RlbBgBIAEoCVIFbW9kZWw=');

@$core.Deprecated('Use cancelPullResponseDescriptor instead')
const CancelPullResponse$json = {
  '1': 'CancelPullResponse',
};

/// Descriptor for `CancelPullResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelPullResponseDescriptor =
    $convert.base64Decode('ChJDYW5jZWxQdWxsUmVzcG9uc2U=');

@$core.Deprecated('Use deleteModelRequestDescriptor instead')
const DeleteModelRequest$json = {
  '1': 'DeleteModelRequest',
  '2': [
    {'1': 'model', '3': 1, '4': 1, '5': 9, '10': 'model'},
  ],
};

/// Descriptor for `DeleteModelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteModelRequestDescriptor = $convert
    .base64Decode('ChJEZWxldGVNb2RlbFJlcXVlc3QSFAoFbW9kZWwYASABKAlSBW1vZGVs');

@$core.Deprecated('Use deleteModelResponseDescriptor instead')
const DeleteModelResponse$json = {
  '1': 'DeleteModelResponse',
};

/// Descriptor for `DeleteModelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteModelResponseDescriptor =
    $convert.base64Decode('ChNEZWxldGVNb2RlbFJlc3BvbnNl');

@$core.Deprecated('Use catalogModelDescriptor instead')
const CatalogModel$json = {
  '1': 'CatalogModel',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'size_hint', '3': 4, '4': 1, '5': 9, '10': 'sizeHint'},
    {'1': 'pinned', '3': 5, '4': 1, '5': 8, '10': 'pinned'},
  ],
};

/// Descriptor for `CatalogModel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List catalogModelDescriptor = $convert.base64Decode(
    'CgxDYXRhbG9nTW9kZWwSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSIAoLZG'
    'VzY3JpcHRpb24YAyABKAlSC2Rlc2NyaXB0aW9uEhsKCXNpemVfaGludBgEIAEoCVIIc2l6ZUhp'
    'bnQSFgoGcGlubmVkGAUgASgIUgZwaW5uZWQ=');

@$core.Deprecated('Use listCatalogRequestDescriptor instead')
const ListCatalogRequest$json = {
  '1': 'ListCatalogRequest',
};

/// Descriptor for `ListCatalogRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCatalogRequestDescriptor =
    $convert.base64Decode('ChJMaXN0Q2F0YWxvZ1JlcXVlc3Q=');

@$core.Deprecated('Use listCatalogResponseDescriptor instead')
const ListCatalogResponse$json = {
  '1': 'ListCatalogResponse',
  '2': [
    {
      '1': 'models',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.v1.CatalogModel',
      '10': 'models'
    },
  ],
};

/// Descriptor for `ListCatalogResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCatalogResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0Q2F0YWxvZ1Jlc3BvbnNlEjAKBm1vZGVscxgBIAMoCzIYLmNhbmRlbGEudjEuQ2F0YW'
    'xvZ01vZGVsUgZtb2RlbHM=');

const $core.Map<$core.String, $core.dynamic> RuntimeServiceBase$json = {
  '1': 'RuntimeService',
  '2': [
    {
      '1': 'StartRuntime',
      '2': '.candela.v1.StartRuntimeRequest',
      '3': '.candela.v1.StartRuntimeResponse'
    },
    {
      '1': 'StopRuntime',
      '2': '.candela.v1.StopRuntimeRequest',
      '3': '.candela.v1.StopRuntimeResponse'
    },
    {
      '1': 'GetHealth',
      '2': '.candela.v1.GetHealthRequest',
      '3': '.candela.v1.GetHealthResponse'
    },
    {
      '1': 'LoadModel',
      '2': '.candela.v1.LoadModelRequest',
      '3': '.candela.v1.LoadModelResponse'
    },
    {
      '1': 'UnloadModel',
      '2': '.candela.v1.UnloadModelRequest',
      '3': '.candela.v1.UnloadModelResponse'
    },
    {
      '1': 'ListModels',
      '2': '.candela.v1.ListModelsRequest',
      '3': '.candela.v1.ListModelsResponse'
    },
    {
      '1': 'PullModel',
      '2': '.candela.v1.PullModelRequest',
      '3': '.candela.v1.PullModelResponse'
    },
    {
      '1': 'CancelPull',
      '2': '.candela.v1.CancelPullRequest',
      '3': '.candela.v1.CancelPullResponse'
    },
    {
      '1': 'DeleteModel',
      '2': '.candela.v1.DeleteModelRequest',
      '3': '.candela.v1.DeleteModelResponse'
    },
    {
      '1': 'ListBackends',
      '2': '.candela.v1.ListBackendsRequest',
      '3': '.candela.v1.ListBackendsResponse'
    },
    {
      '1': 'ResetState',
      '2': '.candela.v1.ResetStateRequest',
      '3': '.candela.v1.ResetStateResponse'
    },
    {
      '1': 'ListCatalog',
      '2': '.candela.v1.ListCatalogRequest',
      '3': '.candela.v1.ListCatalogResponse'
    },
  ],
};

@$core.Deprecated('Use runtimeServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    RuntimeServiceBase$messageJson = {
  '.candela.v1.StartRuntimeRequest': StartRuntimeRequest$json,
  '.candela.v1.StartRuntimeResponse': StartRuntimeResponse$json,
  '.candela.v1.RuntimeStatus': RuntimeStatus$json,
  '.google.protobuf.Timestamp': $2.Timestamp$json,
  '.candela.v1.StopRuntimeRequest': StopRuntimeRequest$json,
  '.candela.v1.StopRuntimeResponse': StopRuntimeResponse$json,
  '.candela.v1.GetHealthRequest': GetHealthRequest$json,
  '.candela.v1.GetHealthResponse': GetHealthResponse$json,
  '.candela.v1.RuntimeModel': RuntimeModel$json,
  '.candela.v1.LoadModelRequest': LoadModelRequest$json,
  '.candela.v1.LoadModelResponse': LoadModelResponse$json,
  '.candela.v1.UnloadModelRequest': UnloadModelRequest$json,
  '.candela.v1.UnloadModelResponse': UnloadModelResponse$json,
  '.candela.v1.ListModelsRequest': ListModelsRequest$json,
  '.candela.v1.ListModelsResponse': ListModelsResponse$json,
  '.candela.v1.PullModelRequest': PullModelRequest$json,
  '.candela.v1.PullModelResponse': PullModelResponse$json,
  '.candela.v1.CancelPullRequest': CancelPullRequest$json,
  '.candela.v1.CancelPullResponse': CancelPullResponse$json,
  '.candela.v1.DeleteModelRequest': DeleteModelRequest$json,
  '.candela.v1.DeleteModelResponse': DeleteModelResponse$json,
  '.candela.v1.ListBackendsRequest': ListBackendsRequest$json,
  '.candela.v1.ListBackendsResponse': ListBackendsResponse$json,
  '.candela.v1.BackendInfo': BackendInfo$json,
  '.candela.v1.ResetStateRequest': ResetStateRequest$json,
  '.candela.v1.ResetStateResponse': ResetStateResponse$json,
  '.candela.v1.ListCatalogRequest': ListCatalogRequest$json,
  '.candela.v1.ListCatalogResponse': ListCatalogResponse$json,
  '.candela.v1.CatalogModel': CatalogModel$json,
};

/// Descriptor for `RuntimeService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List runtimeServiceDescriptor = $convert.base64Decode(
    'Cg5SdW50aW1lU2VydmljZRJRCgxTdGFydFJ1bnRpbWUSHy5jYW5kZWxhLnYxLlN0YXJ0UnVudG'
    'ltZVJlcXVlc3QaIC5jYW5kZWxhLnYxLlN0YXJ0UnVudGltZVJlc3BvbnNlEk4KC1N0b3BSdW50'
    'aW1lEh4uY2FuZGVsYS52MS5TdG9wUnVudGltZVJlcXVlc3QaHy5jYW5kZWxhLnYxLlN0b3BSdW'
    '50aW1lUmVzcG9uc2USSAoJR2V0SGVhbHRoEhwuY2FuZGVsYS52MS5HZXRIZWFsdGhSZXF1ZXN0'
    'Gh0uY2FuZGVsYS52MS5HZXRIZWFsdGhSZXNwb25zZRJICglMb2FkTW9kZWwSHC5jYW5kZWxhLn'
    'YxLkxvYWRNb2RlbFJlcXVlc3QaHS5jYW5kZWxhLnYxLkxvYWRNb2RlbFJlc3BvbnNlEk4KC1Vu'
    'bG9hZE1vZGVsEh4uY2FuZGVsYS52MS5VbmxvYWRNb2RlbFJlcXVlc3QaHy5jYW5kZWxhLnYxLl'
    'VubG9hZE1vZGVsUmVzcG9uc2USSwoKTGlzdE1vZGVscxIdLmNhbmRlbGEudjEuTGlzdE1vZGVs'
    'c1JlcXVlc3QaHi5jYW5kZWxhLnYxLkxpc3RNb2RlbHNSZXNwb25zZRJICglQdWxsTW9kZWwSHC'
    '5jYW5kZWxhLnYxLlB1bGxNb2RlbFJlcXVlc3QaHS5jYW5kZWxhLnYxLlB1bGxNb2RlbFJlc3Bv'
    'bnNlEksKCkNhbmNlbFB1bGwSHS5jYW5kZWxhLnYxLkNhbmNlbFB1bGxSZXF1ZXN0Gh4uY2FuZG'
    'VsYS52MS5DYW5jZWxQdWxsUmVzcG9uc2USTgoLRGVsZXRlTW9kZWwSHi5jYW5kZWxhLnYxLkRl'
    'bGV0ZU1vZGVsUmVxdWVzdBofLmNhbmRlbGEudjEuRGVsZXRlTW9kZWxSZXNwb25zZRJRCgxMaX'
    'N0QmFja2VuZHMSHy5jYW5kZWxhLnYxLkxpc3RCYWNrZW5kc1JlcXVlc3QaIC5jYW5kZWxhLnYx'
    'Lkxpc3RCYWNrZW5kc1Jlc3BvbnNlEksKClJlc2V0U3RhdGUSHS5jYW5kZWxhLnYxLlJlc2V0U3'
    'RhdGVSZXF1ZXN0Gh4uY2FuZGVsYS52MS5SZXNldFN0YXRlUmVzcG9uc2USTgoLTGlzdENhdGFs'
    'b2cSHi5jYW5kZWxhLnYxLkxpc3RDYXRhbG9nUmVxdWVzdBofLmNhbmRlbGEudjEuTGlzdENhdG'
    'Fsb2dSZXNwb25zZQ==');
