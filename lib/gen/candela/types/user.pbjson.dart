//
//  Generated code. Do not modify.
//  source: candela/types/user.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userRoleDescriptor instead')
const UserRole$json = {
  '1': 'UserRole',
  '2': [
    {'1': 'USER_ROLE_UNSPECIFIED', '2': 0},
    {'1': 'USER_ROLE_DEVELOPER', '2': 1},
    {'1': 'USER_ROLE_ADMIN', '2': 2},
  ],
};

/// Descriptor for `UserRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userRoleDescriptor = $convert.base64Decode(
    'CghVc2VyUm9sZRIZChVVU0VSX1JPTEVfVU5TUEVDSUZJRUQQABIXChNVU0VSX1JPTEVfREVWRU'
    'xPUEVSEAESEwoPVVNFUl9ST0xFX0FETUlOEAI=');

@$core.Deprecated('Use userStatusDescriptor instead')
const UserStatus$json = {
  '1': 'UserStatus',
  '2': [
    {'1': 'USER_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'USER_STATUS_PROVISIONED', '2': 1},
    {'1': 'USER_STATUS_ACTIVE', '2': 2},
    {'1': 'USER_STATUS_INACTIVE', '2': 3},
  ],
};

/// Descriptor for `UserStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userStatusDescriptor = $convert.base64Decode(
    'CgpVc2VyU3RhdHVzEhsKF1VTRVJfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGwoXVVNFUl9TVEFUVV'
    'NfUFJPVklTSU9ORUQQARIWChJVU0VSX1NUQVRVU19BQ1RJVkUQAhIYChRVU0VSX1NUQVRVU19J'
    'TkFDVElWRRAD');

@$core.Deprecated('Use budgetPeriodDescriptor instead')
const BudgetPeriod$json = {
  '1': 'BudgetPeriod',
  '2': [
    {'1': 'BUDGET_PERIOD_UNSPECIFIED', '2': 0},
    {'1': 'BUDGET_PERIOD_DAILY', '2': 1},
  ],
  '4': [
    {'1': 2, '2': 2},
    {'1': 3, '2': 3},
    {'1': 4, '2': 4},
    {'1': 5, '2': 5},
  ],
  '5': [
    'BUDGET_PERIOD_MONTHLY',
    'BUDGET_PERIOD_WEEKLY',
    'BUDGET_PERIOD_QUARTERLY',
    'BUDGET_PERIOD_CUSTOM'
  ],
};

/// Descriptor for `BudgetPeriod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List budgetPeriodDescriptor = $convert.base64Decode(
    'CgxCdWRnZXRQZXJpb2QSHQoZQlVER0VUX1BFUklPRF9VTlNQRUNJRklFRBAAEhcKE0JVREdFVF'
    '9QRVJJT0RfREFJTFkQASIECAIQAiIECAMQAyIECAQQBCIECAUQBSoVQlVER0VUX1BFUklPRF9N'
    'T05USExZKhRCVURHRVRfUEVSSU9EX1dFRUtMWSoXQlVER0VUX1BFUklPRF9RVUFSVEVSTFkqFE'
    'JVREdFVF9QRVJJT0RfQ1VTVE9N');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'role',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.candela.types.UserRole',
      '10': 'role'
    },
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.candela.types.UserStatus',
      '10': 'status'
    },
    {
      '1': 'created_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'last_seen_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastSeenAt'
    },
    {'1': 'rate_limit', '3': 8, '4': 1, '5': 5, '10': 'rateLimit'},
    {
      '1': 'last_active_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastActiveAt'
    },
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgJUgJpZBIUCgVlbWFpbBgCIAEoCVIFZW1haWwSIQoMZGlzcGxheV'
    '9uYW1lGAMgASgJUgtkaXNwbGF5TmFtZRIrCgRyb2xlGAQgASgOMhcuY2FuZGVsYS50eXBlcy5V'
    'c2VyUm9sZVIEcm9sZRIxCgZzdGF0dXMYBSABKA4yGS5jYW5kZWxhLnR5cGVzLlVzZXJTdGF0dX'
    'NSBnN0YXR1cxI5CgpjcmVhdGVkX2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFIJY3JlYXRlZEF0EjwKDGxhc3Rfc2Vlbl9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW'
    '1lc3RhbXBSCmxhc3RTZWVuQXQSHQoKcmF0ZV9saW1pdBgIIAEoBVIJcmF0ZUxpbWl0EkAKDmxh'
    'c3RfYWN0aXZlX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMbGFzdEFjdG'
    'l2ZUF0');

@$core.Deprecated('Use userBudgetDescriptor instead')
const UserBudget$json = {
  '1': 'UserBudget',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'limit_usd', '3': 2, '4': 1, '5': 1, '10': 'limitUsd'},
    {'1': 'spent_usd', '3': 3, '4': 1, '5': 1, '10': 'spentUsd'},
    {'1': 'tokens_used', '3': 4, '4': 1, '5': 3, '10': 'tokensUsed'},
    {
      '1': 'period_type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.candela.types.BudgetPeriod',
      '10': 'periodType'
    },
    {'1': 'period_key', '3': 6, '4': 1, '5': 9, '10': 'periodKey'},
    {
      '1': 'period_start',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodStart'
    },
    {
      '1': 'period_end',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodEnd'
    },
  ],
};

/// Descriptor for `UserBudget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userBudgetDescriptor = $convert.base64Decode(
    'CgpVc2VyQnVkZ2V0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIbCglsaW1pdF91c2QYAiABKA'
    'FSCGxpbWl0VXNkEhsKCXNwZW50X3VzZBgDIAEoAVIIc3BlbnRVc2QSHwoLdG9rZW5zX3VzZWQY'
    'BCABKANSCnRva2Vuc1VzZWQSPAoLcGVyaW9kX3R5cGUYBSABKA4yGy5jYW5kZWxhLnR5cGVzLk'
    'J1ZGdldFBlcmlvZFIKcGVyaW9kVHlwZRIdCgpwZXJpb2Rfa2V5GAYgASgJUglwZXJpb2RLZXkS'
    'PQoMcGVyaW9kX3N0YXJ0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILcGVyaW'
    '9kU3RhcnQSOQoKcGVyaW9kX2VuZBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CXBlcmlvZEVuZA==');

@$core.Deprecated('Use budgetGrantDescriptor instead')
const BudgetGrant$json = {
  '1': 'BudgetGrant',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'amount_usd', '3': 3, '4': 1, '5': 1, '10': 'amountUsd'},
    {'1': 'spent_usd', '3': 4, '4': 1, '5': 1, '10': 'spentUsd'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'granted_by', '3': 6, '4': 1, '5': 9, '10': 'grantedBy'},
    {
      '1': 'starts_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'expires_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {
      '1': 'created_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `BudgetGrant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List budgetGrantDescriptor = $convert.base64Decode(
    'CgtCdWRnZXRHcmFudBIOCgJpZBgBIAEoCVICaWQSFwoHdXNlcl9pZBgCIAEoCVIGdXNlcklkEh'
    '0KCmFtb3VudF91c2QYAyABKAFSCWFtb3VudFVzZBIbCglzcGVudF91c2QYBCABKAFSCHNwZW50'
    'VXNkEhYKBnJlYXNvbhgFIAEoCVIGcmVhc29uEh0KCmdyYW50ZWRfYnkYBiABKAlSCWdyYW50ZW'
    'RCeRI3CglzdGFydHNfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghzdGFy'
    'dHNBdBI5CgpleHBpcmVzX2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJZX'
    'hwaXJlc0F0EjkKCmNyZWF0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1w'
    'UgljcmVhdGVkQXQ=');

@$core.Deprecated('Use auditEntryDescriptor instead')
const AuditEntry$json = {
  '1': 'AuditEntry',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'actor_email', '3': 3, '4': 1, '5': 9, '10': 'actorEmail'},
    {'1': 'action', '3': 4, '4': 1, '5': 9, '10': 'action'},
    {'1': 'details', '3': 5, '4': 1, '5': 9, '10': 'details'},
    {
      '1': 'timestamp',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
  ],
};

/// Descriptor for `AuditEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List auditEntryDescriptor = $convert.base64Decode(
    'CgpBdWRpdEVudHJ5Eg4KAmlkGAEgASgJUgJpZBIXCgd1c2VyX2lkGAIgASgJUgZ1c2VySWQSHw'
    'oLYWN0b3JfZW1haWwYAyABKAlSCmFjdG9yRW1haWwSFgoGYWN0aW9uGAQgASgJUgZhY3Rpb24S'
    'GAoHZGV0YWlscxgFIAEoCVIHZGV0YWlscxI4Cgl0aW1lc3RhbXAYBiABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUgl0aW1lc3RhbXA=');

@$core.Deprecated('Use rateWindowDescriptor instead')
const RateWindow$json = {
  '1': 'RateWindow',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'request_count', '3': 2, '4': 1, '5': 5, '10': 'requestCount'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'window_key', '3': 4, '4': 1, '5': 9, '10': 'windowKey'},
    {
      '1': 'expire_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expireAt'
    },
  ],
};

/// Descriptor for `RateWindow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateWindowDescriptor = $convert.base64Decode(
    'CgpSYXRlV2luZG93EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIjCg1yZXF1ZXN0X2NvdW50GA'
    'IgASgFUgxyZXF1ZXN0Q291bnQSFAoFbGltaXQYAyABKAVSBWxpbWl0Eh0KCndpbmRvd19rZXkY'
    'BCABKAlSCXdpbmRvd0tleRI3CglleHBpcmVfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUghleHBpcmVBdA==');
