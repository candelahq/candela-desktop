//
//  Generated code. Do not modify.
//  source: candela/v1/user_service.proto
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
import '../types/common.pbjson.dart' as $4;
import '../types/user.pbjson.dart' as $7;

@$core.Deprecated('Use createUserRequestDescriptor instead')
const CreateUserRequest$json = {
  '1': 'CreateUserRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'email'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'role',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.candela.types.UserRole',
      '10': 'role'
    },
    {
      '1': 'daily_budget_usd',
      '3': 5,
      '4': 1,
      '5': 1,
      '8': {},
      '10': 'dailyBudgetUsd'
    },
  ],
  '9': [
    {'1': 4, '2': 5},
  ],
  '10': ['monthly_budget_usd'],
};

/// Descriptor for `CreateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createUserRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVVc2VyUmVxdWVzdBIdCgVlbWFpbBgBIAEoCUIHukgEcgJgAVIFZW1haWwSIQoMZG'
    'lzcGxheV9uYW1lGAIgASgJUgtkaXNwbGF5TmFtZRIrCgRyb2xlGAMgASgOMhcuY2FuZGVsYS50'
    'eXBlcy5Vc2VyUm9sZVIEcm9sZRI4ChBkYWlseV9idWRnZXRfdXNkGAUgASgBQg66SAsSCSkAAA'
    'AAAAAAAFIOZGFpbHlCdWRnZXRVc2RKBAgEEAVSEm1vbnRobHlfYnVkZ2V0X3VzZA==');

@$core.Deprecated('Use createUserResponseDescriptor instead')
const CreateUserResponse$json = {
  '1': 'CreateUserResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.User',
      '10': 'user'
    },
    {
      '1': 'budget',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.candela.types.UserBudget',
      '10': 'budget'
    },
  ],
};

/// Descriptor for `CreateUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createUserResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVVc2VyUmVzcG9uc2USJwoEdXNlchgBIAEoCzITLmNhbmRlbGEudHlwZXMuVXNlcl'
    'IEdXNlchIxCgZidWRnZXQYAiABKAsyGS5jYW5kZWxhLnR5cGVzLlVzZXJCdWRnZXRSBmJ1ZGdl'
    'dA==');

@$core.Deprecated('Use listUsersRequestDescriptor instead')
const ListUsersRequest$json = {
  '1': 'ListUsersRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.PaginationRequest',
      '10': 'pagination'
    },
    {
      '1': 'status_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.candela.types.UserStatus',
      '10': 'statusFilter'
    },
  ],
};

/// Descriptor for `ListUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUsersRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0VXNlcnNSZXF1ZXN0EkAKCnBhZ2luYXRpb24YASABKAsyIC5jYW5kZWxhLnR5cGVzLl'
    'BhZ2luYXRpb25SZXF1ZXN0UgpwYWdpbmF0aW9uEj4KDXN0YXR1c19maWx0ZXIYAiABKA4yGS5j'
    'YW5kZWxhLnR5cGVzLlVzZXJTdGF0dXNSDHN0YXR1c0ZpbHRlcg==');

@$core.Deprecated('Use listUsersResponseDescriptor instead')
const ListUsersResponse$json = {
  '1': 'ListUsersResponse',
  '2': [
    {
      '1': 'users',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.types.User',
      '10': 'users'
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

/// Descriptor for `ListUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUsersResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0VXNlcnNSZXNwb25zZRIpCgV1c2VycxgBIAMoCzITLmNhbmRlbGEudHlwZXMuVXNlcl'
    'IFdXNlcnMSQQoKcGFnaW5hdGlvbhgCIAEoCzIhLmNhbmRlbGEudHlwZXMuUGFnaW5hdGlvblJl'
    'c3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use getUserRequestDescriptor instead')
const GetUserRequest$json = {
  '1': 'GetUserRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `GetUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserRequestDescriptor = $convert
    .base64Decode('Cg5HZXRVc2VyUmVxdWVzdBIXCgJpZBgBIAEoCUIHukgEcgIQAVICaWQ=');

@$core.Deprecated('Use getUserResponseDescriptor instead')
const GetUserResponse$json = {
  '1': 'GetUserResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.User',
      '10': 'user'
    },
    {
      '1': 'budget',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.candela.types.UserBudget',
      '10': 'budget'
    },
    {
      '1': 'active_grants',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.candela.types.BudgetGrant',
      '10': 'activeGrants'
    },
  ],
};

/// Descriptor for `GetUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRVc2VyUmVzcG9uc2USJwoEdXNlchgBIAEoCzITLmNhbmRlbGEudHlwZXMuVXNlclIEdX'
    'NlchIxCgZidWRnZXQYAiABKAsyGS5jYW5kZWxhLnR5cGVzLlVzZXJCdWRnZXRSBmJ1ZGdldBI/'
    'Cg1hY3RpdmVfZ3JhbnRzGAMgAygLMhouY2FuZGVsYS50eXBlcy5CdWRnZXRHcmFudFIMYWN0aX'
    'ZlR3JhbnRz');

@$core.Deprecated('Use updateUserRequestDescriptor instead')
const UpdateUserRequest$json = {
  '1': 'UpdateUserRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'role',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.candela.types.UserRole',
      '10': 'role'
    },
    {
      '1': 'update_mask',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldMask',
      '10': 'updateMask'
    },
  ],
};

/// Descriptor for `UpdateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVVc2VyUmVxdWVzdBIXCgJpZBgBIAEoCUIHukgEcgIQAVICaWQSIQoMZGlzcGxheV'
    '9uYW1lGAIgASgJUgtkaXNwbGF5TmFtZRIrCgRyb2xlGAMgASgOMhcuY2FuZGVsYS50eXBlcy5V'
    'c2VyUm9sZVIEcm9sZRI7Cgt1cGRhdGVfbWFzaxgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5GaW'
    'VsZE1hc2tSCnVwZGF0ZU1hc2s=');

@$core.Deprecated('Use updateUserResponseDescriptor instead')
const UpdateUserResponse$json = {
  '1': 'UpdateUserResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.User',
      '10': 'user'
    },
  ],
};

/// Descriptor for `UpdateUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVVc2VyUmVzcG9uc2USJwoEdXNlchgBIAEoCzITLmNhbmRlbGEudHlwZXMuVXNlcl'
    'IEdXNlcg==');

@$core.Deprecated('Use deactivateUserRequestDescriptor instead')
const DeactivateUserRequest$json = {
  '1': 'DeactivateUserRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `DeactivateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deactivateUserRequestDescriptor =
    $convert.base64Decode(
        'ChVEZWFjdGl2YXRlVXNlclJlcXVlc3QSFwoCaWQYASABKAlCB7pIBHICEAFSAmlk');

@$core.Deprecated('Use deactivateUserResponseDescriptor instead')
const DeactivateUserResponse$json = {
  '1': 'DeactivateUserResponse',
};

/// Descriptor for `DeactivateUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deactivateUserResponseDescriptor =
    $convert.base64Decode('ChZEZWFjdGl2YXRlVXNlclJlc3BvbnNl');

@$core.Deprecated('Use reactivateUserRequestDescriptor instead')
const ReactivateUserRequest$json = {
  '1': 'ReactivateUserRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `ReactivateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reactivateUserRequestDescriptor =
    $convert.base64Decode(
        'ChVSZWFjdGl2YXRlVXNlclJlcXVlc3QSFwoCaWQYASABKAlCB7pIBHICEAFSAmlk');

@$core.Deprecated('Use reactivateUserResponseDescriptor instead')
const ReactivateUserResponse$json = {
  '1': 'ReactivateUserResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.User',
      '10': 'user'
    },
  ],
};

/// Descriptor for `ReactivateUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reactivateUserResponseDescriptor =
    $convert.base64Decode(
        'ChZSZWFjdGl2YXRlVXNlclJlc3BvbnNlEicKBHVzZXIYASABKAsyEy5jYW5kZWxhLnR5cGVzLl'
        'VzZXJSBHVzZXI=');

@$core.Deprecated('Use deleteUserRequestDescriptor instead')
const DeleteUserRequest$json = {
  '1': 'DeleteUserRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {
      '1': 'confirm_email',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'confirmEmail'
    },
  ],
};

/// Descriptor for `DeleteUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteUserRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVVc2VyUmVxdWVzdBIXCgJpZBgBIAEoCUIHukgEcgIQAVICaWQSLAoNY29uZmlybV'
    '9lbWFpbBgCIAEoCUIHukgEcgJgAVIMY29uZmlybUVtYWls');

@$core.Deprecated('Use deleteUserResponseDescriptor instead')
const DeleteUserResponse$json = {
  '1': 'DeleteUserResponse',
};

/// Descriptor for `DeleteUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteUserResponseDescriptor =
    $convert.base64Decode('ChJEZWxldGVVc2VyUmVzcG9uc2U=');

@$core.Deprecated('Use setBudgetRequestDescriptor instead')
const SetBudgetRequest$json = {
  '1': 'SetBudgetRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'limit_usd', '3': 2, '4': 1, '5': 1, '8': {}, '10': 'limitUsd'},
    {
      '1': 'period_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.candela.types.BudgetPeriod',
      '10': 'periodType'
    },
  ],
};

/// Descriptor for `SetBudgetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setBudgetRequestDescriptor = $convert.base64Decode(
    'ChBTZXRCdWRnZXRSZXF1ZXN0EiAKB3VzZXJfaWQYASABKAlCB7pIBHICEAFSBnVzZXJJZBIrCg'
    'lsaW1pdF91c2QYAiABKAFCDrpICxIJIQAAAAAAAAAAUghsaW1pdFVzZBI8CgtwZXJpb2RfdHlw'
    'ZRgDIAEoDjIbLmNhbmRlbGEudHlwZXMuQnVkZ2V0UGVyaW9kUgpwZXJpb2RUeXBl');

@$core.Deprecated('Use setBudgetResponseDescriptor instead')
const SetBudgetResponse$json = {
  '1': 'SetBudgetResponse',
  '2': [
    {
      '1': 'budget',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.UserBudget',
      '10': 'budget'
    },
  ],
};

/// Descriptor for `SetBudgetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setBudgetResponseDescriptor = $convert.base64Decode(
    'ChFTZXRCdWRnZXRSZXNwb25zZRIxCgZidWRnZXQYASABKAsyGS5jYW5kZWxhLnR5cGVzLlVzZX'
    'JCdWRnZXRSBmJ1ZGdldA==');

@$core.Deprecated('Use getBudgetRequestDescriptor instead')
const GetBudgetRequest$json = {
  '1': 'GetBudgetRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
  ],
};

/// Descriptor for `GetBudgetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBudgetRequestDescriptor = $convert.base64Decode(
    'ChBHZXRCdWRnZXRSZXF1ZXN0EiAKB3VzZXJfaWQYASABKAlCB7pIBHICEAFSBnVzZXJJZA==');

@$core.Deprecated('Use getBudgetResponseDescriptor instead')
const GetBudgetResponse$json = {
  '1': 'GetBudgetResponse',
  '2': [
    {
      '1': 'budget',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.UserBudget',
      '10': 'budget'
    },
  ],
};

/// Descriptor for `GetBudgetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBudgetResponseDescriptor = $convert.base64Decode(
    'ChFHZXRCdWRnZXRSZXNwb25zZRIxCgZidWRnZXQYASABKAsyGS5jYW5kZWxhLnR5cGVzLlVzZX'
    'JCdWRnZXRSBmJ1ZGdldA==');

@$core.Deprecated('Use resetSpendRequestDescriptor instead')
const ResetSpendRequest$json = {
  '1': 'ResetSpendRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
  ],
};

/// Descriptor for `ResetSpendRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetSpendRequestDescriptor = $convert.base64Decode(
    'ChFSZXNldFNwZW5kUmVxdWVzdBIgCgd1c2VyX2lkGAEgASgJQge6SARyAhABUgZ1c2VySWQ=');

@$core.Deprecated('Use resetSpendResponseDescriptor instead')
const ResetSpendResponse$json = {
  '1': 'ResetSpendResponse',
  '2': [
    {
      '1': 'budget',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.UserBudget',
      '10': 'budget'
    },
  ],
};

/// Descriptor for `ResetSpendResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetSpendResponseDescriptor = $convert.base64Decode(
    'ChJSZXNldFNwZW5kUmVzcG9uc2USMQoGYnVkZ2V0GAEgASgLMhkuY2FuZGVsYS50eXBlcy5Vc2'
    'VyQnVkZ2V0UgZidWRnZXQ=');

@$core.Deprecated('Use createGrantRequestDescriptor instead')
const CreateGrantRequest$json = {
  '1': 'CreateGrantRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'amount_usd', '3': 2, '4': 1, '5': 1, '8': {}, '10': 'amountUsd'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'reason'},
    {
      '1': 'starts_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'expires_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
  ],
  '7': {},
};

/// Descriptor for `CreateGrantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createGrantRequestDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVHcmFudFJlcXVlc3QSIAoHdXNlcl9pZBgBIAEoCUIHukgEcgIQAVIGdXNlcklkEi'
    '0KCmFtb3VudF91c2QYAiABKAFCDrpICxIJIQAAAAAAAAAAUglhbW91bnRVc2QSHwoGcmVhc29u'
    'GAMgASgJQge6SARyAhABUgZyZWFzb24SNwoJc3RhcnRzX2F0GAQgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIIc3RhcnRzQXQSOQoKZXhwaXJlc19hdBgFIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSCWV4cGlyZXNBdDqaAbpIlgEakwEKGmdyYW50LmV4cGlyZXNfYW'
    'Z0ZXJfc3RhcnRzEiJleHBpcmVzX2F0IG11c3QgYmUgYWZ0ZXIgc3RhcnRzX2F0GlEhaGFzKHRo'
    'aXMuc3RhcnRzX2F0KSB8fCAhaGFzKHRoaXMuZXhwaXJlc19hdCkgfHwgdGhpcy5leHBpcmVzX2'
    'F0ID4gdGhpcy5zdGFydHNfYXQ=');

@$core.Deprecated('Use createGrantResponseDescriptor instead')
const CreateGrantResponse$json = {
  '1': 'CreateGrantResponse',
  '2': [
    {
      '1': 'grant',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.BudgetGrant',
      '10': 'grant'
    },
  ],
};

/// Descriptor for `CreateGrantResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createGrantResponseDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVHcmFudFJlc3BvbnNlEjAKBWdyYW50GAEgASgLMhouY2FuZGVsYS50eXBlcy5CdW'
    'RnZXRHcmFudFIFZ3JhbnQ=');

@$core.Deprecated('Use listGrantsRequestDescriptor instead')
const ListGrantsRequest$json = {
  '1': 'ListGrantsRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'active_only', '3': 2, '4': 1, '5': 8, '10': 'activeOnly'},
  ],
};

/// Descriptor for `ListGrantsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listGrantsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0R3JhbnRzUmVxdWVzdBIgCgd1c2VyX2lkGAEgASgJQge6SARyAhABUgZ1c2VySWQSHw'
    'oLYWN0aXZlX29ubHkYAiABKAhSCmFjdGl2ZU9ubHk=');

@$core.Deprecated('Use listGrantsResponseDescriptor instead')
const ListGrantsResponse$json = {
  '1': 'ListGrantsResponse',
  '2': [
    {
      '1': 'grants',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.types.BudgetGrant',
      '10': 'grants'
    },
  ],
};

/// Descriptor for `ListGrantsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listGrantsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0R3JhbnRzUmVzcG9uc2USMgoGZ3JhbnRzGAEgAygLMhouY2FuZGVsYS50eXBlcy5CdW'
    'RnZXRHcmFudFIGZ3JhbnRz');

@$core.Deprecated('Use revokeGrantRequestDescriptor instead')
const RevokeGrantRequest$json = {
  '1': 'RevokeGrantRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'grant_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'grantId'},
  ],
};

/// Descriptor for `RevokeGrantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeGrantRequestDescriptor = $convert.base64Decode(
    'ChJSZXZva2VHcmFudFJlcXVlc3QSIAoHdXNlcl9pZBgBIAEoCUIHukgEcgIQAVIGdXNlcklkEi'
    'IKCGdyYW50X2lkGAIgASgJQge6SARyAhABUgdncmFudElk');

@$core.Deprecated('Use revokeGrantResponseDescriptor instead')
const RevokeGrantResponse$json = {
  '1': 'RevokeGrantResponse',
};

/// Descriptor for `RevokeGrantResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeGrantResponseDescriptor =
    $convert.base64Decode('ChNSZXZva2VHcmFudFJlc3BvbnNl');

@$core.Deprecated('Use listAuditLogRequestDescriptor instead')
const ListAuditLogRequest$json = {
  '1': 'ListAuditLogRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '8': {}, '10': 'limit'},
  ],
};

/// Descriptor for `ListAuditLogRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAuditLogRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0QXVkaXRMb2dSZXF1ZXN0EiAKB3VzZXJfaWQYASABKAlCB7pIBHICEAFSBnVzZXJJZB'
    'IgCgVsaW1pdBgCIAEoBUIKukgHGgUY9AMoAFIFbGltaXQ=');

@$core.Deprecated('Use listAuditLogResponseDescriptor instead')
const ListAuditLogResponse$json = {
  '1': 'ListAuditLogResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.types.AuditEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `ListAuditLogResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAuditLogResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0QXVkaXRMb2dSZXNwb25zZRIzCgdlbnRyaWVzGAEgAygLMhkuY2FuZGVsYS50eXBlcy'
    '5BdWRpdEVudHJ5UgdlbnRyaWVz');

@$core.Deprecated('Use getCurrentUserRequestDescriptor instead')
const GetCurrentUserRequest$json = {
  '1': 'GetCurrentUserRequest',
};

/// Descriptor for `GetCurrentUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentUserRequestDescriptor =
    $convert.base64Decode('ChVHZXRDdXJyZW50VXNlclJlcXVlc3Q=');

@$core.Deprecated('Use getCurrentUserResponseDescriptor instead')
const GetCurrentUserResponse$json = {
  '1': 'GetCurrentUserResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.User',
      '10': 'user'
    },
    {
      '1': 'budget',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.candela.types.UserBudget',
      '10': 'budget'
    },
    {
      '1': 'active_grants',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.candela.types.BudgetGrant',
      '10': 'activeGrants'
    },
    {
      '1': 'total_remaining_usd',
      '3': 4,
      '4': 1,
      '5': 1,
      '10': 'totalRemainingUsd'
    },
  ],
};

/// Descriptor for `GetCurrentUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentUserResponseDescriptor = $convert.base64Decode(
    'ChZHZXRDdXJyZW50VXNlclJlc3BvbnNlEicKBHVzZXIYASABKAsyEy5jYW5kZWxhLnR5cGVzLl'
    'VzZXJSBHVzZXISMQoGYnVkZ2V0GAIgASgLMhkuY2FuZGVsYS50eXBlcy5Vc2VyQnVkZ2V0UgZi'
    'dWRnZXQSPwoNYWN0aXZlX2dyYW50cxgDIAMoCzIaLmNhbmRlbGEudHlwZXMuQnVkZ2V0R3Jhbn'
    'RSDGFjdGl2ZUdyYW50cxIuChN0b3RhbF9yZW1haW5pbmdfdXNkGAQgASgBUhF0b3RhbFJlbWFp'
    'bmluZ1VzZA==');

@$core.Deprecated('Use getMyBudgetRequestDescriptor instead')
const GetMyBudgetRequest$json = {
  '1': 'GetMyBudgetRequest',
};

/// Descriptor for `GetMyBudgetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyBudgetRequestDescriptor =
    $convert.base64Decode('ChJHZXRNeUJ1ZGdldFJlcXVlc3Q=');

@$core.Deprecated('Use getMyBudgetResponseDescriptor instead')
const GetMyBudgetResponse$json = {
  '1': 'GetMyBudgetResponse',
  '2': [
    {
      '1': 'budget',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.candela.types.UserBudget',
      '10': 'budget'
    },
    {
      '1': 'active_grants',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.candela.types.BudgetGrant',
      '10': 'activeGrants'
    },
    {
      '1': 'total_remaining_usd',
      '3': 3,
      '4': 1,
      '5': 1,
      '10': 'totalRemainingUsd'
    },
    {
      '1': 'budget_remaining_usd',
      '3': 4,
      '4': 1,
      '5': 1,
      '10': 'budgetRemainingUsd'
    },
    {
      '1': 'grants_remaining_usd',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'grantsRemainingUsd'
    },
    {
      '1': 'tokens_used_today',
      '3': 10,
      '4': 1,
      '5': 3,
      '10': 'tokensUsedToday'
    },
    {'1': 'period_key', '3': 20, '4': 1, '5': 9, '10': 'periodKey'},
    {'1': 'period_resets_at', '3': 21, '4': 1, '5': 9, '10': 'periodResetsAt'},
  ],
};

/// Descriptor for `GetMyBudgetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyBudgetResponseDescriptor = $convert.base64Decode(
    'ChNHZXRNeUJ1ZGdldFJlc3BvbnNlEjEKBmJ1ZGdldBgBIAEoCzIZLmNhbmRlbGEudHlwZXMuVX'
    'NlckJ1ZGdldFIGYnVkZ2V0Ej8KDWFjdGl2ZV9ncmFudHMYAiADKAsyGi5jYW5kZWxhLnR5cGVz'
    'LkJ1ZGdldEdyYW50UgxhY3RpdmVHcmFudHMSLgoTdG90YWxfcmVtYWluaW5nX3VzZBgDIAEoAV'
    'IRdG90YWxSZW1haW5pbmdVc2QSMAoUYnVkZ2V0X3JlbWFpbmluZ191c2QYBCABKAFSEmJ1ZGdl'
    'dFJlbWFpbmluZ1VzZBIwChRncmFudHNfcmVtYWluaW5nX3VzZBgFIAEoAVISZ3JhbnRzUmVtYW'
    'luaW5nVXNkEioKEXRva2Vuc191c2VkX3RvZGF5GAogASgDUg90b2tlbnNVc2VkVG9kYXkSHQoK'
    'cGVyaW9kX2tleRgUIAEoCVIJcGVyaW9kS2V5EigKEHBlcmlvZF9yZXNldHNfYXQYFSABKAlSDn'
    'BlcmlvZFJlc2V0c0F0');

const $core.Map<$core.String, $core.dynamic> UserServiceBase$json = {
  '1': 'UserService',
  '2': [
    {
      '1': 'CreateUser',
      '2': '.candela.v1.CreateUserRequest',
      '3': '.candela.v1.CreateUserResponse'
    },
    {
      '1': 'ListUsers',
      '2': '.candela.v1.ListUsersRequest',
      '3': '.candela.v1.ListUsersResponse'
    },
    {
      '1': 'GetUser',
      '2': '.candela.v1.GetUserRequest',
      '3': '.candela.v1.GetUserResponse'
    },
    {
      '1': 'UpdateUser',
      '2': '.candela.v1.UpdateUserRequest',
      '3': '.candela.v1.UpdateUserResponse'
    },
    {
      '1': 'DeactivateUser',
      '2': '.candela.v1.DeactivateUserRequest',
      '3': '.candela.v1.DeactivateUserResponse'
    },
    {
      '1': 'ReactivateUser',
      '2': '.candela.v1.ReactivateUserRequest',
      '3': '.candela.v1.ReactivateUserResponse'
    },
    {
      '1': 'DeleteUser',
      '2': '.candela.v1.DeleteUserRequest',
      '3': '.candela.v1.DeleteUserResponse'
    },
    {
      '1': 'SetBudget',
      '2': '.candela.v1.SetBudgetRequest',
      '3': '.candela.v1.SetBudgetResponse'
    },
    {
      '1': 'GetBudget',
      '2': '.candela.v1.GetBudgetRequest',
      '3': '.candela.v1.GetBudgetResponse'
    },
    {
      '1': 'ResetSpend',
      '2': '.candela.v1.ResetSpendRequest',
      '3': '.candela.v1.ResetSpendResponse'
    },
    {
      '1': 'CreateGrant',
      '2': '.candela.v1.CreateGrantRequest',
      '3': '.candela.v1.CreateGrantResponse'
    },
    {
      '1': 'ListGrants',
      '2': '.candela.v1.ListGrantsRequest',
      '3': '.candela.v1.ListGrantsResponse'
    },
    {
      '1': 'RevokeGrant',
      '2': '.candela.v1.RevokeGrantRequest',
      '3': '.candela.v1.RevokeGrantResponse'
    },
    {
      '1': 'ListAuditLog',
      '2': '.candela.v1.ListAuditLogRequest',
      '3': '.candela.v1.ListAuditLogResponse'
    },
    {
      '1': 'GetCurrentUser',
      '2': '.candela.v1.GetCurrentUserRequest',
      '3': '.candela.v1.GetCurrentUserResponse'
    },
    {
      '1': 'GetMyBudget',
      '2': '.candela.v1.GetMyBudgetRequest',
      '3': '.candela.v1.GetMyBudgetResponse'
    },
  ],
};

@$core.Deprecated('Use userServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    UserServiceBase$messageJson = {
  '.candela.v1.CreateUserRequest': CreateUserRequest$json,
  '.candela.v1.CreateUserResponse': CreateUserResponse$json,
  '.candela.types.User': $7.User$json,
  '.google.protobuf.Timestamp': $2.Timestamp$json,
  '.candela.types.UserBudget': $7.UserBudget$json,
  '.candela.v1.ListUsersRequest': ListUsersRequest$json,
  '.candela.types.PaginationRequest': $4.PaginationRequest$json,
  '.candela.v1.ListUsersResponse': ListUsersResponse$json,
  '.candela.types.PaginationResponse': $4.PaginationResponse$json,
  '.candela.v1.GetUserRequest': GetUserRequest$json,
  '.candela.v1.GetUserResponse': GetUserResponse$json,
  '.candela.types.BudgetGrant': $7.BudgetGrant$json,
  '.candela.v1.UpdateUserRequest': UpdateUserRequest$json,
  '.google.protobuf.FieldMask': $1.FieldMask$json,
  '.candela.v1.UpdateUserResponse': UpdateUserResponse$json,
  '.candela.v1.DeactivateUserRequest': DeactivateUserRequest$json,
  '.candela.v1.DeactivateUserResponse': DeactivateUserResponse$json,
  '.candela.v1.ReactivateUserRequest': ReactivateUserRequest$json,
  '.candela.v1.ReactivateUserResponse': ReactivateUserResponse$json,
  '.candela.v1.DeleteUserRequest': DeleteUserRequest$json,
  '.candela.v1.DeleteUserResponse': DeleteUserResponse$json,
  '.candela.v1.SetBudgetRequest': SetBudgetRequest$json,
  '.candela.v1.SetBudgetResponse': SetBudgetResponse$json,
  '.candela.v1.GetBudgetRequest': GetBudgetRequest$json,
  '.candela.v1.GetBudgetResponse': GetBudgetResponse$json,
  '.candela.v1.ResetSpendRequest': ResetSpendRequest$json,
  '.candela.v1.ResetSpendResponse': ResetSpendResponse$json,
  '.candela.v1.CreateGrantRequest': CreateGrantRequest$json,
  '.candela.v1.CreateGrantResponse': CreateGrantResponse$json,
  '.candela.v1.ListGrantsRequest': ListGrantsRequest$json,
  '.candela.v1.ListGrantsResponse': ListGrantsResponse$json,
  '.candela.v1.RevokeGrantRequest': RevokeGrantRequest$json,
  '.candela.v1.RevokeGrantResponse': RevokeGrantResponse$json,
  '.candela.v1.ListAuditLogRequest': ListAuditLogRequest$json,
  '.candela.v1.ListAuditLogResponse': ListAuditLogResponse$json,
  '.candela.types.AuditEntry': $7.AuditEntry$json,
  '.candela.v1.GetCurrentUserRequest': GetCurrentUserRequest$json,
  '.candela.v1.GetCurrentUserResponse': GetCurrentUserResponse$json,
  '.candela.v1.GetMyBudgetRequest': GetMyBudgetRequest$json,
  '.candela.v1.GetMyBudgetResponse': GetMyBudgetResponse$json,
};

/// Descriptor for `UserService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List userServiceDescriptor = $convert.base64Decode(
    'CgtVc2VyU2VydmljZRJLCgpDcmVhdGVVc2VyEh0uY2FuZGVsYS52MS5DcmVhdGVVc2VyUmVxdW'
    'VzdBoeLmNhbmRlbGEudjEuQ3JlYXRlVXNlclJlc3BvbnNlEkgKCUxpc3RVc2VycxIcLmNhbmRl'
    'bGEudjEuTGlzdFVzZXJzUmVxdWVzdBodLmNhbmRlbGEudjEuTGlzdFVzZXJzUmVzcG9uc2USQg'
    'oHR2V0VXNlchIaLmNhbmRlbGEudjEuR2V0VXNlclJlcXVlc3QaGy5jYW5kZWxhLnYxLkdldFVz'
    'ZXJSZXNwb25zZRJLCgpVcGRhdGVVc2VyEh0uY2FuZGVsYS52MS5VcGRhdGVVc2VyUmVxdWVzdB'
    'oeLmNhbmRlbGEudjEuVXBkYXRlVXNlclJlc3BvbnNlElcKDkRlYWN0aXZhdGVVc2VyEiEuY2Fu'
    'ZGVsYS52MS5EZWFjdGl2YXRlVXNlclJlcXVlc3QaIi5jYW5kZWxhLnYxLkRlYWN0aXZhdGVVc2'
    'VyUmVzcG9uc2USVwoOUmVhY3RpdmF0ZVVzZXISIS5jYW5kZWxhLnYxLlJlYWN0aXZhdGVVc2Vy'
    'UmVxdWVzdBoiLmNhbmRlbGEudjEuUmVhY3RpdmF0ZVVzZXJSZXNwb25zZRJLCgpEZWxldGVVc2'
    'VyEh0uY2FuZGVsYS52MS5EZWxldGVVc2VyUmVxdWVzdBoeLmNhbmRlbGEudjEuRGVsZXRlVXNl'
    'clJlc3BvbnNlEkgKCVNldEJ1ZGdldBIcLmNhbmRlbGEudjEuU2V0QnVkZ2V0UmVxdWVzdBodLm'
    'NhbmRlbGEudjEuU2V0QnVkZ2V0UmVzcG9uc2USSAoJR2V0QnVkZ2V0EhwuY2FuZGVsYS52MS5H'
    'ZXRCdWRnZXRSZXF1ZXN0Gh0uY2FuZGVsYS52MS5HZXRCdWRnZXRSZXNwb25zZRJLCgpSZXNldF'
    'NwZW5kEh0uY2FuZGVsYS52MS5SZXNldFNwZW5kUmVxdWVzdBoeLmNhbmRlbGEudjEuUmVzZXRT'
    'cGVuZFJlc3BvbnNlEk4KC0NyZWF0ZUdyYW50Eh4uY2FuZGVsYS52MS5DcmVhdGVHcmFudFJlcX'
    'Vlc3QaHy5jYW5kZWxhLnYxLkNyZWF0ZUdyYW50UmVzcG9uc2USSwoKTGlzdEdyYW50cxIdLmNh'
    'bmRlbGEudjEuTGlzdEdyYW50c1JlcXVlc3QaHi5jYW5kZWxhLnYxLkxpc3RHcmFudHNSZXNwb2'
    '5zZRJOCgtSZXZva2VHcmFudBIeLmNhbmRlbGEudjEuUmV2b2tlR3JhbnRSZXF1ZXN0Gh8uY2Fu'
    'ZGVsYS52MS5SZXZva2VHcmFudFJlc3BvbnNlElEKDExpc3RBdWRpdExvZxIfLmNhbmRlbGEudj'
    'EuTGlzdEF1ZGl0TG9nUmVxdWVzdBogLmNhbmRlbGEudjEuTGlzdEF1ZGl0TG9nUmVzcG9uc2US'
    'VwoOR2V0Q3VycmVudFVzZXISIS5jYW5kZWxhLnYxLkdldEN1cnJlbnRVc2VyUmVxdWVzdBoiLm'
    'NhbmRlbGEudjEuR2V0Q3VycmVudFVzZXJSZXNwb25zZRJOCgtHZXRNeUJ1ZGdldBIeLmNhbmRl'
    'bGEudjEuR2V0TXlCdWRnZXRSZXF1ZXN0Gh8uY2FuZGVsYS52MS5HZXRNeUJ1ZGdldFJlc3Bvbn'
    'Nl');
