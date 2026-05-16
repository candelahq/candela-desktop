//
//  Generated code. Do not modify.
//  source: candela/v1/project_service.proto
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
import '../types/common.pbjson.dart' as $4;
import '../types/project.pbjson.dart' as $11;

@$core.Deprecated('Use createProjectRequestDescriptor instead')
const CreateProjectRequest$json = {
  '1': 'CreateProjectRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'description'},
  ],
};

/// Descriptor for `CreateProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createProjectRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVQcm9qZWN0UmVxdWVzdBIeCgRuYW1lGAEgASgJQgq6SAdyBRABGP8BUgRuYW1lEi'
    'oKC2Rlc2NyaXB0aW9uGAIgASgJQgi6SAVyAxiAIFILZGVzY3JpcHRpb24=');

@$core.Deprecated('Use createProjectResponseDescriptor instead')
const CreateProjectResponse$json = {
  '1': 'CreateProjectResponse',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.Project',
      '10': 'project'
    },
  ],
};

/// Descriptor for `CreateProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createProjectResponseDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVQcm9qZWN0UmVzcG9uc2USMAoHcHJvamVjdBgBIAEoCzIWLmNhbmRlbGEudHlwZX'
    'MuUHJvamVjdFIHcHJvamVjdA==');

@$core.Deprecated('Use getProjectRequestDescriptor instead')
const GetProjectRequest$json = {
  '1': 'GetProjectRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `GetProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProjectRequestDescriptor = $convert.base64Decode(
    'ChFHZXRQcm9qZWN0UmVxdWVzdBIaCgJpZBgBIAEoCUIKukgHcgUQARiAAVICaWQ=');

@$core.Deprecated('Use getProjectResponseDescriptor instead')
const GetProjectResponse$json = {
  '1': 'GetProjectResponse',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.Project',
      '10': 'project'
    },
  ],
};

/// Descriptor for `GetProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProjectResponseDescriptor = $convert.base64Decode(
    'ChJHZXRQcm9qZWN0UmVzcG9uc2USMAoHcHJvamVjdBgBIAEoCzIWLmNhbmRlbGEudHlwZXMuUH'
    'JvamVjdFIHcHJvamVjdA==');

@$core.Deprecated('Use listProjectsRequestDescriptor instead')
const ListProjectsRequest$json = {
  '1': 'ListProjectsRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.PaginationRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListProjectsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UHJvamVjdHNSZXF1ZXN0EkAKCnBhZ2luYXRpb24YASABKAsyIC5jYW5kZWxhLnR5cG'
    'VzLlBhZ2luYXRpb25SZXF1ZXN0UgpwYWdpbmF0aW9u');

@$core.Deprecated('Use listProjectsResponseDescriptor instead')
const ListProjectsResponse$json = {
  '1': 'ListProjectsResponse',
  '2': [
    {
      '1': 'projects',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.types.Project',
      '10': 'projects'
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

/// Descriptor for `ListProjectsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UHJvamVjdHNSZXNwb25zZRIyCghwcm9qZWN0cxgBIAMoCzIWLmNhbmRlbGEudHlwZX'
    'MuUHJvamVjdFIIcHJvamVjdHMSQQoKcGFnaW5hdGlvbhgCIAEoCzIhLmNhbmRlbGEudHlwZXMu'
    'UGFnaW5hdGlvblJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use deleteProjectRequestDescriptor instead')
const DeleteProjectRequest$json = {
  '1': 'DeleteProjectRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `DeleteProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProjectRequestDescriptor =
    $convert.base64Decode(
        'ChREZWxldGVQcm9qZWN0UmVxdWVzdBIaCgJpZBgBIAEoCUIKukgHcgUQARiAAVICaWQ=');

@$core.Deprecated('Use deleteProjectResponseDescriptor instead')
const DeleteProjectResponse$json = {
  '1': 'DeleteProjectResponse',
};

/// Descriptor for `DeleteProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProjectResponseDescriptor =
    $convert.base64Decode('ChVEZWxldGVQcm9qZWN0UmVzcG9uc2U=');

@$core.Deprecated('Use createAPIKeyRequestDescriptor instead')
const CreateAPIKeyRequest$json = {
  '1': 'CreateAPIKeyRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'name'},
  ],
};

/// Descriptor for `CreateAPIKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAPIKeyRequestDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVBUElLZXlSZXF1ZXN0EikKCnByb2plY3RfaWQYASABKAlCCrpIB3IFEAEYgAFSCX'
    'Byb2plY3RJZBIeCgRuYW1lGAIgASgJQgq6SAdyBRABGP8BUgRuYW1l');

@$core.Deprecated('Use createAPIKeyResponseDescriptor instead')
const CreateAPIKeyResponse$json = {
  '1': 'CreateAPIKeyResponse',
  '2': [
    {
      '1': 'api_key',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.APIKey',
      '10': 'apiKey'
    },
    {'1': 'full_key', '3': 2, '4': 1, '5': 9, '10': 'fullKey'},
  ],
};

/// Descriptor for `CreateAPIKeyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAPIKeyResponseDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVBUElLZXlSZXNwb25zZRIuCgdhcGlfa2V5GAEgASgLMhUuY2FuZGVsYS50eXBlcy'
    '5BUElLZXlSBmFwaUtleRIZCghmdWxsX2tleRgCIAEoCVIHZnVsbEtleQ==');

@$core.Deprecated('Use listAPIKeysRequestDescriptor instead')
const ListAPIKeysRequest$json = {
  '1': 'ListAPIKeysRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'projectId'},
  ],
};

/// Descriptor for `ListAPIKeysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAPIKeysRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0QVBJS2V5c1JlcXVlc3QSKQoKcHJvamVjdF9pZBgBIAEoCUIKukgHcgUQARiAAVIJcH'
    'JvamVjdElk');

@$core.Deprecated('Use listAPIKeysResponseDescriptor instead')
const ListAPIKeysResponse$json = {
  '1': 'ListAPIKeysResponse',
  '2': [
    {
      '1': 'api_keys',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.types.APIKey',
      '10': 'apiKeys'
    },
  ],
};

/// Descriptor for `ListAPIKeysResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAPIKeysResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0QVBJS2V5c1Jlc3BvbnNlEjAKCGFwaV9rZXlzGAEgAygLMhUuY2FuZGVsYS50eXBlcy'
    '5BUElLZXlSB2FwaUtleXM=');

@$core.Deprecated('Use revokeAPIKeyRequestDescriptor instead')
const RevokeAPIKeyRequest$json = {
  '1': 'RevokeAPIKeyRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `RevokeAPIKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeAPIKeyRequestDescriptor =
    $convert.base64Decode(
        'ChNSZXZva2VBUElLZXlSZXF1ZXN0EhoKAmlkGAEgASgJQgq6SAdyBRABGIABUgJpZA==');

@$core.Deprecated('Use revokeAPIKeyResponseDescriptor instead')
const RevokeAPIKeyResponse$json = {
  '1': 'RevokeAPIKeyResponse',
};

/// Descriptor for `RevokeAPIKeyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeAPIKeyResponseDescriptor =
    $convert.base64Decode('ChRSZXZva2VBUElLZXlSZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> ProjectServiceBase$json = {
  '1': 'ProjectService',
  '2': [
    {
      '1': 'CreateProject',
      '2': '.candela.v1.CreateProjectRequest',
      '3': '.candela.v1.CreateProjectResponse'
    },
    {
      '1': 'GetProject',
      '2': '.candela.v1.GetProjectRequest',
      '3': '.candela.v1.GetProjectResponse'
    },
    {
      '1': 'ListProjects',
      '2': '.candela.v1.ListProjectsRequest',
      '3': '.candela.v1.ListProjectsResponse'
    },
    {
      '1': 'DeleteProject',
      '2': '.candela.v1.DeleteProjectRequest',
      '3': '.candela.v1.DeleteProjectResponse'
    },
    {
      '1': 'CreateAPIKey',
      '2': '.candela.v1.CreateAPIKeyRequest',
      '3': '.candela.v1.CreateAPIKeyResponse'
    },
    {
      '1': 'ListAPIKeys',
      '2': '.candela.v1.ListAPIKeysRequest',
      '3': '.candela.v1.ListAPIKeysResponse'
    },
    {
      '1': 'RevokeAPIKey',
      '2': '.candela.v1.RevokeAPIKeyRequest',
      '3': '.candela.v1.RevokeAPIKeyResponse'
    },
  ],
};

@$core.Deprecated('Use projectServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ProjectServiceBase$messageJson = {
  '.candela.v1.CreateProjectRequest': CreateProjectRequest$json,
  '.candela.v1.CreateProjectResponse': CreateProjectResponse$json,
  '.candela.types.Project': $11.Project$json,
  '.google.protobuf.Timestamp': $2.Timestamp$json,
  '.candela.v1.GetProjectRequest': GetProjectRequest$json,
  '.candela.v1.GetProjectResponse': GetProjectResponse$json,
  '.candela.v1.ListProjectsRequest': ListProjectsRequest$json,
  '.candela.types.PaginationRequest': $4.PaginationRequest$json,
  '.candela.v1.ListProjectsResponse': ListProjectsResponse$json,
  '.candela.types.PaginationResponse': $4.PaginationResponse$json,
  '.candela.v1.DeleteProjectRequest': DeleteProjectRequest$json,
  '.candela.v1.DeleteProjectResponse': DeleteProjectResponse$json,
  '.candela.v1.CreateAPIKeyRequest': CreateAPIKeyRequest$json,
  '.candela.v1.CreateAPIKeyResponse': CreateAPIKeyResponse$json,
  '.candela.types.APIKey': $11.APIKey$json,
  '.candela.v1.ListAPIKeysRequest': ListAPIKeysRequest$json,
  '.candela.v1.ListAPIKeysResponse': ListAPIKeysResponse$json,
  '.candela.v1.RevokeAPIKeyRequest': RevokeAPIKeyRequest$json,
  '.candela.v1.RevokeAPIKeyResponse': RevokeAPIKeyResponse$json,
};

/// Descriptor for `ProjectService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List projectServiceDescriptor = $convert.base64Decode(
    'Cg5Qcm9qZWN0U2VydmljZRJUCg1DcmVhdGVQcm9qZWN0EiAuY2FuZGVsYS52MS5DcmVhdGVQcm'
    '9qZWN0UmVxdWVzdBohLmNhbmRlbGEudjEuQ3JlYXRlUHJvamVjdFJlc3BvbnNlEksKCkdldFBy'
    'b2plY3QSHS5jYW5kZWxhLnYxLkdldFByb2plY3RSZXF1ZXN0Gh4uY2FuZGVsYS52MS5HZXRQcm'
    '9qZWN0UmVzcG9uc2USUQoMTGlzdFByb2plY3RzEh8uY2FuZGVsYS52MS5MaXN0UHJvamVjdHNS'
    'ZXF1ZXN0GiAuY2FuZGVsYS52MS5MaXN0UHJvamVjdHNSZXNwb25zZRJUCg1EZWxldGVQcm9qZW'
    'N0EiAuY2FuZGVsYS52MS5EZWxldGVQcm9qZWN0UmVxdWVzdBohLmNhbmRlbGEudjEuRGVsZXRl'
    'UHJvamVjdFJlc3BvbnNlElEKDENyZWF0ZUFQSUtleRIfLmNhbmRlbGEudjEuQ3JlYXRlQVBJS2'
    'V5UmVxdWVzdBogLmNhbmRlbGEudjEuQ3JlYXRlQVBJS2V5UmVzcG9uc2USTgoLTGlzdEFQSUtl'
    'eXMSHi5jYW5kZWxhLnYxLkxpc3RBUElLZXlzUmVxdWVzdBofLmNhbmRlbGEudjEuTGlzdEFQSU'
    'tleXNSZXNwb25zZRJRCgxSZXZva2VBUElLZXkSHy5jYW5kZWxhLnYxLlJldm9rZUFQSUtleVJl'
    'cXVlc3QaIC5jYW5kZWxhLnYxLlJldm9rZUFQSUtleVJlc3BvbnNl');
