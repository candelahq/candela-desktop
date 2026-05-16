//
//  Generated code. Do not modify.
//  source: candela/v1/dashboard_service.proto
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
import '../types/user.pbjson.dart' as $7;

@$core.Deprecated('Use getUsageSummaryRequestDescriptor instead')
const GetUsageSummaryRequest$json = {
  '1': 'GetUsageSummaryRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {
      '1': 'time_range',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.candela.types.TimeRange',
      '10': 'timeRange'
    },
    {'1': 'environment', '3': 3, '4': 1, '5': 9, '10': 'environment'},
  ],
};

/// Descriptor for `GetUsageSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUsageSummaryRequestDescriptor = $convert.base64Decode(
    'ChZHZXRVc2FnZVN1bW1hcnlSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZB'
    'I3Cgp0aW1lX3JhbmdlGAIgASgLMhguY2FuZGVsYS50eXBlcy5UaW1lUmFuZ2VSCXRpbWVSYW5n'
    'ZRIgCgtlbnZpcm9ubWVudBgDIAEoCVILZW52aXJvbm1lbnQ=');

@$core.Deprecated('Use getUsageSummaryResponseDescriptor instead')
const GetUsageSummaryResponse$json = {
  '1': 'GetUsageSummaryResponse',
  '2': [
    {'1': 'total_traces', '3': 1, '4': 1, '5': 3, '10': 'totalTraces'},
    {'1': 'total_spans', '3': 2, '4': 1, '5': 3, '10': 'totalSpans'},
    {'1': 'total_llm_calls', '3': 3, '4': 1, '5': 3, '10': 'totalLlmCalls'},
    {
      '1': 'total_input_tokens',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'totalInputTokens'
    },
    {
      '1': 'total_output_tokens',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'totalOutputTokens'
    },
    {'1': 'total_cost_usd', '3': 6, '4': 1, '5': 1, '10': 'totalCostUsd'},
    {'1': 'avg_latency_ms', '3': 7, '4': 1, '5': 1, '10': 'avgLatencyMs'},
    {'1': 'error_rate', '3': 8, '4': 1, '5': 1, '10': 'errorRate'},
    {
      '1': 'traces_over_time',
      '3': 20,
      '4': 3,
      '5': 11,
      '6': '.candela.v1.TimeSeriesPoint',
      '10': 'tracesOverTime'
    },
    {
      '1': 'cost_over_time',
      '3': 21,
      '4': 3,
      '5': 11,
      '6': '.candela.v1.TimeSeriesPoint',
      '10': 'costOverTime'
    },
    {
      '1': 'tokens_over_time',
      '3': 22,
      '4': 3,
      '5': 11,
      '6': '.candela.v1.TimeSeriesPoint',
      '10': 'tokensOverTime'
    },
  ],
};

/// Descriptor for `GetUsageSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUsageSummaryResponseDescriptor = $convert.base64Decode(
    'ChdHZXRVc2FnZVN1bW1hcnlSZXNwb25zZRIhCgx0b3RhbF90cmFjZXMYASABKANSC3RvdGFsVH'
    'JhY2VzEh8KC3RvdGFsX3NwYW5zGAIgASgDUgp0b3RhbFNwYW5zEiYKD3RvdGFsX2xsbV9jYWxs'
    'cxgDIAEoA1INdG90YWxMbG1DYWxscxIsChJ0b3RhbF9pbnB1dF90b2tlbnMYBCABKANSEHRvdG'
    'FsSW5wdXRUb2tlbnMSLgoTdG90YWxfb3V0cHV0X3Rva2VucxgFIAEoA1IRdG90YWxPdXRwdXRU'
    'b2tlbnMSJAoOdG90YWxfY29zdF91c2QYBiABKAFSDHRvdGFsQ29zdFVzZBIkCg5hdmdfbGF0ZW'
    '5jeV9tcxgHIAEoAVIMYXZnTGF0ZW5jeU1zEh0KCmVycm9yX3JhdGUYCCABKAFSCWVycm9yUmF0'
    'ZRJFChB0cmFjZXNfb3Zlcl90aW1lGBQgAygLMhsuY2FuZGVsYS52MS5UaW1lU2VyaWVzUG9pbn'
    'RSDnRyYWNlc092ZXJUaW1lEkEKDmNvc3Rfb3Zlcl90aW1lGBUgAygLMhsuY2FuZGVsYS52MS5U'
    'aW1lU2VyaWVzUG9pbnRSDGNvc3RPdmVyVGltZRJFChB0b2tlbnNfb3Zlcl90aW1lGBYgAygLMh'
    'suY2FuZGVsYS52MS5UaW1lU2VyaWVzUG9pbnRSDnRva2Vuc092ZXJUaW1l');

@$core.Deprecated('Use timeSeriesPointDescriptor instead')
const TimeSeriesPoint$json = {
  '1': 'TimeSeriesPoint',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 1, '5': 9, '10': 'timestamp'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
};

/// Descriptor for `TimeSeriesPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeSeriesPointDescriptor = $convert.base64Decode(
    'Cg9UaW1lU2VyaWVzUG9pbnQSHAoJdGltZXN0YW1wGAEgASgJUgl0aW1lc3RhbXASFAoFdmFsdW'
    'UYAiABKAFSBXZhbHVl');

@$core.Deprecated('Use getModelBreakdownRequestDescriptor instead')
const GetModelBreakdownRequest$json = {
  '1': 'GetModelBreakdownRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {
      '1': 'time_range',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.candela.types.TimeRange',
      '10': 'timeRange'
    },
  ],
};

/// Descriptor for `GetModelBreakdownRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getModelBreakdownRequestDescriptor = $convert.base64Decode(
    'ChhHZXRNb2RlbEJyZWFrZG93blJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdE'
    'lkEjcKCnRpbWVfcmFuZ2UYAiABKAsyGC5jYW5kZWxhLnR5cGVzLlRpbWVSYW5nZVIJdGltZVJh'
    'bmdl');

@$core.Deprecated('Use getModelBreakdownResponseDescriptor instead')
const GetModelBreakdownResponse$json = {
  '1': 'GetModelBreakdownResponse',
  '2': [
    {
      '1': 'models',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.v1.ModelUsage',
      '10': 'models'
    },
  ],
};

/// Descriptor for `GetModelBreakdownResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getModelBreakdownResponseDescriptor =
    $convert.base64Decode(
        'ChlHZXRNb2RlbEJyZWFrZG93blJlc3BvbnNlEi4KBm1vZGVscxgBIAMoCzIWLmNhbmRlbGEudj'
        'EuTW9kZWxVc2FnZVIGbW9kZWxz');

@$core.Deprecated('Use modelUsageDescriptor instead')
const ModelUsage$json = {
  '1': 'ModelUsage',
  '2': [
    {'1': 'model', '3': 1, '4': 1, '5': 9, '10': 'model'},
    {'1': 'provider', '3': 2, '4': 1, '5': 9, '10': 'provider'},
    {'1': 'call_count', '3': 3, '4': 1, '5': 3, '10': 'callCount'},
    {'1': 'input_tokens', '3': 4, '4': 1, '5': 3, '10': 'inputTokens'},
    {'1': 'output_tokens', '3': 5, '4': 1, '5': 3, '10': 'outputTokens'},
    {'1': 'cost_usd', '3': 6, '4': 1, '5': 1, '10': 'costUsd'},
    {'1': 'avg_latency_ms', '3': 7, '4': 1, '5': 1, '10': 'avgLatencyMs'},
  ],
};

/// Descriptor for `ModelUsage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modelUsageDescriptor = $convert.base64Decode(
    'CgpNb2RlbFVzYWdlEhQKBW1vZGVsGAEgASgJUgVtb2RlbBIaCghwcm92aWRlchgCIAEoCVIIcH'
    'JvdmlkZXISHQoKY2FsbF9jb3VudBgDIAEoA1IJY2FsbENvdW50EiEKDGlucHV0X3Rva2VucxgE'
    'IAEoA1ILaW5wdXRUb2tlbnMSIwoNb3V0cHV0X3Rva2VucxgFIAEoA1IMb3V0cHV0VG9rZW5zEh'
    'kKCGNvc3RfdXNkGAYgASgBUgdjb3N0VXNkEiQKDmF2Z19sYXRlbmN5X21zGAcgASgBUgxhdmdM'
    'YXRlbmN5TXM=');

@$core.Deprecated('Use getLatencyPercentilesRequestDescriptor instead')
const GetLatencyPercentilesRequest$json = {
  '1': 'GetLatencyPercentilesRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {
      '1': 'time_range',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.candela.types.TimeRange',
      '10': 'timeRange'
    },
    {'1': 'model', '3': 3, '4': 1, '5': 9, '10': 'model'},
  ],
};

/// Descriptor for `GetLatencyPercentilesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLatencyPercentilesRequestDescriptor =
    $convert.base64Decode(
        'ChxHZXRMYXRlbmN5UGVyY2VudGlsZXNSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2'
        'plY3RJZBI3Cgp0aW1lX3JhbmdlGAIgASgLMhguY2FuZGVsYS50eXBlcy5UaW1lUmFuZ2VSCXRp'
        'bWVSYW5nZRIUCgVtb2RlbBgDIAEoCVIFbW9kZWw=');

@$core.Deprecated('Use getLatencyPercentilesResponseDescriptor instead')
const GetLatencyPercentilesResponse$json = {
  '1': 'GetLatencyPercentilesResponse',
  '2': [
    {'1': 'p50_ms', '3': 1, '4': 1, '5': 1, '10': 'p50Ms'},
    {'1': 'p90_ms', '3': 2, '4': 1, '5': 1, '10': 'p90Ms'},
    {'1': 'p95_ms', '3': 3, '4': 1, '5': 1, '10': 'p95Ms'},
    {'1': 'p99_ms', '3': 4, '4': 1, '5': 1, '10': 'p99Ms'},
    {
      '1': 'latency_over_time',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.candela.v1.TimeSeriesPoint',
      '10': 'latencyOverTime'
    },
  ],
};

/// Descriptor for `GetLatencyPercentilesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLatencyPercentilesResponseDescriptor = $convert.base64Decode(
    'Ch1HZXRMYXRlbmN5UGVyY2VudGlsZXNSZXNwb25zZRIVCgZwNTBfbXMYASABKAFSBXA1ME1zEh'
    'UKBnA5MF9tcxgCIAEoAVIFcDkwTXMSFQoGcDk1X21zGAMgASgBUgVwOTVNcxIVCgZwOTlfbXMY'
    'BCABKAFSBXA5OU1zEkcKEWxhdGVuY3lfb3Zlcl90aW1lGAogAygLMhsuY2FuZGVsYS52MS5UaW'
    '1lU2VyaWVzUG9pbnRSD2xhdGVuY3lPdmVyVGltZQ==');

@$core.Deprecated('Use getMyUsageRequestDescriptor instead')
const GetMyUsageRequest$json = {
  '1': 'GetMyUsageRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {
      '1': 'time_range',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.candela.types.TimeRange',
      '10': 'timeRange'
    },
  ],
};

/// Descriptor for `GetMyUsageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyUsageRequestDescriptor = $convert.base64Decode(
    'ChFHZXRNeVVzYWdlUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SWQSNwoKdG'
    'ltZV9yYW5nZRgCIAEoCzIYLmNhbmRlbGEudHlwZXMuVGltZVJhbmdlUgl0aW1lUmFuZ2U=');

@$core.Deprecated('Use getMyUsageResponseDescriptor instead')
const GetMyUsageResponse$json = {
  '1': 'GetMyUsageResponse',
  '2': [
    {'1': 'total_calls', '3': 1, '4': 1, '5': 3, '10': 'totalCalls'},
    {
      '1': 'total_input_tokens',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'totalInputTokens'
    },
    {
      '1': 'total_output_tokens',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'totalOutputTokens'
    },
    {'1': 'total_cost_usd', '3': 4, '4': 1, '5': 1, '10': 'totalCostUsd'},
    {'1': 'avg_latency_ms', '3': 5, '4': 1, '5': 1, '10': 'avgLatencyMs'},
    {
      '1': 'models',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.candela.v1.ModelUsage',
      '10': 'models'
    },
    {
      '1': 'budget',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.candela.types.UserBudget',
      '10': 'budget'
    },
    {
      '1': 'total_remaining_usd',
      '3': 21,
      '4': 1,
      '5': 1,
      '10': 'totalRemainingUsd'
    },
    {
      '1': 'active_grants',
      '3': 22,
      '4': 3,
      '5': 11,
      '6': '.candela.types.BudgetGrant',
      '10': 'activeGrants'
    },
  ],
};

/// Descriptor for `GetMyUsageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyUsageResponseDescriptor = $convert.base64Decode(
    'ChJHZXRNeVVzYWdlUmVzcG9uc2USHwoLdG90YWxfY2FsbHMYASABKANSCnRvdGFsQ2FsbHMSLA'
    'oSdG90YWxfaW5wdXRfdG9rZW5zGAIgASgDUhB0b3RhbElucHV0VG9rZW5zEi4KE3RvdGFsX291'
    'dHB1dF90b2tlbnMYAyABKANSEXRvdGFsT3V0cHV0VG9rZW5zEiQKDnRvdGFsX2Nvc3RfdXNkGA'
    'QgASgBUgx0b3RhbENvc3RVc2QSJAoOYXZnX2xhdGVuY3lfbXMYBSABKAFSDGF2Z0xhdGVuY3lN'
    'cxIuCgZtb2RlbHMYCiADKAsyFi5jYW5kZWxhLnYxLk1vZGVsVXNhZ2VSBm1vZGVscxIxCgZidW'
    'RnZXQYFCABKAsyGS5jYW5kZWxhLnR5cGVzLlVzZXJCdWRnZXRSBmJ1ZGdldBIuChN0b3RhbF9y'
    'ZW1haW5pbmdfdXNkGBUgASgBUhF0b3RhbFJlbWFpbmluZ1VzZBI/Cg1hY3RpdmVfZ3JhbnRzGB'
    'YgAygLMhouY2FuZGVsYS50eXBlcy5CdWRnZXRHcmFudFIMYWN0aXZlR3JhbnRz');

@$core.Deprecated('Use getTeamLeaderboardRequestDescriptor instead')
const GetTeamLeaderboardRequest$json = {
  '1': 'GetTeamLeaderboardRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {
      '1': 'time_range',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.candela.types.TimeRange',
      '10': 'timeRange'
    },
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetTeamLeaderboardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTeamLeaderboardRequestDescriptor = $convert.base64Decode(
    'ChlHZXRUZWFtTGVhZGVyYm9hcmRSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3'
    'RJZBI3Cgp0aW1lX3JhbmdlGAIgASgLMhguY2FuZGVsYS50eXBlcy5UaW1lUmFuZ2VSCXRpbWVS'
    'YW5nZRIUCgVsaW1pdBgDIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use getTeamLeaderboardResponseDescriptor instead')
const GetTeamLeaderboardResponse$json = {
  '1': 'GetTeamLeaderboardResponse',
  '2': [
    {
      '1': 'users',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.v1.UserUsage',
      '10': 'users'
    },
  ],
};

/// Descriptor for `GetTeamLeaderboardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTeamLeaderboardResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRUZWFtTGVhZGVyYm9hcmRSZXNwb25zZRIrCgV1c2VycxgBIAMoCzIVLmNhbmRlbGEudj'
        'EuVXNlclVzYWdlUgV1c2Vycw==');

@$core.Deprecated('Use userUsageDescriptor instead')
const UserUsage$json = {
  '1': 'UserUsage',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'call_count', '3': 4, '4': 1, '5': 3, '10': 'callCount'},
    {'1': 'total_tokens', '3': 5, '4': 1, '5': 3, '10': 'totalTokens'},
    {'1': 'cost_usd', '3': 6, '4': 1, '5': 1, '10': 'costUsd'},
    {'1': 'avg_latency_ms', '3': 7, '4': 1, '5': 1, '10': 'avgLatencyMs'},
    {'1': 'top_model', '3': 8, '4': 1, '5': 9, '10': 'topModel'},
  ],
};

/// Descriptor for `UserUsage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userUsageDescriptor = $convert.base64Decode(
    'CglVc2VyVXNhZ2USFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhQKBWVtYWlsGAIgASgJUgVlbW'
    'FpbBIhCgxkaXNwbGF5X25hbWUYAyABKAlSC2Rpc3BsYXlOYW1lEh0KCmNhbGxfY291bnQYBCAB'
    'KANSCWNhbGxDb3VudBIhCgx0b3RhbF90b2tlbnMYBSABKANSC3RvdGFsVG9rZW5zEhkKCGNvc3'
    'RfdXNkGAYgASgBUgdjb3N0VXNkEiQKDmF2Z19sYXRlbmN5X21zGAcgASgBUgxhdmdMYXRlbmN5'
    'TXMSGwoJdG9wX21vZGVsGAggASgJUgh0b3BNb2RlbA==');

@$core.Deprecated('Use getJobLeaderboardRequestDescriptor instead')
const GetJobLeaderboardRequest$json = {
  '1': 'GetJobLeaderboardRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {
      '1': 'time_range',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.candela.types.TimeRange',
      '10': 'timeRange'
    },
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetJobLeaderboardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getJobLeaderboardRequestDescriptor = $convert.base64Decode(
    'ChhHZXRKb2JMZWFkZXJib2FyZFJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdE'
    'lkEjcKCnRpbWVfcmFuZ2UYAiABKAsyGC5jYW5kZWxhLnR5cGVzLlRpbWVSYW5nZVIJdGltZVJh'
    'bmdlEhQKBWxpbWl0GAMgASgFUgVsaW1pdA==');

@$core.Deprecated('Use getJobLeaderboardResponseDescriptor instead')
const GetJobLeaderboardResponse$json = {
  '1': 'GetJobLeaderboardResponse',
  '2': [
    {
      '1': 'jobs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.candela.v1.JobUsage',
      '10': 'jobs'
    },
  ],
};

/// Descriptor for `GetJobLeaderboardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getJobLeaderboardResponseDescriptor =
    $convert.base64Decode(
        'ChlHZXRKb2JMZWFkZXJib2FyZFJlc3BvbnNlEigKBGpvYnMYASADKAsyFC5jYW5kZWxhLnYxLk'
        'pvYlVzYWdlUgRqb2Jz');

@$core.Deprecated('Use jobUsageDescriptor instead')
const JobUsage$json = {
  '1': 'JobUsage',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'call_count', '3': 2, '4': 1, '5': 3, '10': 'callCount'},
    {'1': 'total_tokens', '3': 3, '4': 1, '5': 3, '10': 'totalTokens'},
    {'1': 'cost_usd', '3': 4, '4': 1, '5': 1, '10': 'costUsd'},
    {'1': 'avg_latency_ms', '3': 5, '4': 1, '5': 1, '10': 'avgLatencyMs'},
    {'1': 'top_model', '3': 6, '4': 1, '5': 9, '10': 'topModel'},
  ],
};

/// Descriptor for `JobUsage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobUsageDescriptor = $convert.base64Decode(
    'CghKb2JVc2FnZRIVCgZqb2JfaWQYASABKAlSBWpvYklkEh0KCmNhbGxfY291bnQYAiABKANSCW'
    'NhbGxDb3VudBIhCgx0b3RhbF90b2tlbnMYAyABKANSC3RvdGFsVG9rZW5zEhkKCGNvc3RfdXNk'
    'GAQgASgBUgdjb3N0VXNkEiQKDmF2Z19sYXRlbmN5X21zGAUgASgBUgxhdmdMYXRlbmN5TXMSGw'
    'oJdG9wX21vZGVsGAYgASgJUgh0b3BNb2RlbA==');

const $core.Map<$core.String, $core.dynamic> DashboardServiceBase$json = {
  '1': 'DashboardService',
  '2': [
    {
      '1': 'GetUsageSummary',
      '2': '.candela.v1.GetUsageSummaryRequest',
      '3': '.candela.v1.GetUsageSummaryResponse'
    },
    {
      '1': 'GetModelBreakdown',
      '2': '.candela.v1.GetModelBreakdownRequest',
      '3': '.candela.v1.GetModelBreakdownResponse'
    },
    {
      '1': 'GetLatencyPercentiles',
      '2': '.candela.v1.GetLatencyPercentilesRequest',
      '3': '.candela.v1.GetLatencyPercentilesResponse'
    },
    {
      '1': 'GetMyUsage',
      '2': '.candela.v1.GetMyUsageRequest',
      '3': '.candela.v1.GetMyUsageResponse'
    },
    {
      '1': 'GetTeamLeaderboard',
      '2': '.candela.v1.GetTeamLeaderboardRequest',
      '3': '.candela.v1.GetTeamLeaderboardResponse'
    },
    {
      '1': 'GetJobLeaderboard',
      '2': '.candela.v1.GetJobLeaderboardRequest',
      '3': '.candela.v1.GetJobLeaderboardResponse'
    },
  ],
};

@$core.Deprecated('Use dashboardServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DashboardServiceBase$messageJson = {
  '.candela.v1.GetUsageSummaryRequest': GetUsageSummaryRequest$json,
  '.candela.types.TimeRange': $4.TimeRange$json,
  '.google.protobuf.Timestamp': $2.Timestamp$json,
  '.candela.v1.GetUsageSummaryResponse': GetUsageSummaryResponse$json,
  '.candela.v1.TimeSeriesPoint': TimeSeriesPoint$json,
  '.candela.v1.GetModelBreakdownRequest': GetModelBreakdownRequest$json,
  '.candela.v1.GetModelBreakdownResponse': GetModelBreakdownResponse$json,
  '.candela.v1.ModelUsage': ModelUsage$json,
  '.candela.v1.GetLatencyPercentilesRequest': GetLatencyPercentilesRequest$json,
  '.candela.v1.GetLatencyPercentilesResponse':
      GetLatencyPercentilesResponse$json,
  '.candela.v1.GetMyUsageRequest': GetMyUsageRequest$json,
  '.candela.v1.GetMyUsageResponse': GetMyUsageResponse$json,
  '.candela.types.UserBudget': $7.UserBudget$json,
  '.candela.types.BudgetGrant': $7.BudgetGrant$json,
  '.candela.v1.GetTeamLeaderboardRequest': GetTeamLeaderboardRequest$json,
  '.candela.v1.GetTeamLeaderboardResponse': GetTeamLeaderboardResponse$json,
  '.candela.v1.UserUsage': UserUsage$json,
  '.candela.v1.GetJobLeaderboardRequest': GetJobLeaderboardRequest$json,
  '.candela.v1.GetJobLeaderboardResponse': GetJobLeaderboardResponse$json,
  '.candela.v1.JobUsage': JobUsage$json,
};

/// Descriptor for `DashboardService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List dashboardServiceDescriptor = $convert.base64Decode(
    'ChBEYXNoYm9hcmRTZXJ2aWNlEloKD0dldFVzYWdlU3VtbWFyeRIiLmNhbmRlbGEudjEuR2V0VX'
    'NhZ2VTdW1tYXJ5UmVxdWVzdBojLmNhbmRlbGEudjEuR2V0VXNhZ2VTdW1tYXJ5UmVzcG9uc2US'
    'YAoRR2V0TW9kZWxCcmVha2Rvd24SJC5jYW5kZWxhLnYxLkdldE1vZGVsQnJlYWtkb3duUmVxdW'
    'VzdBolLmNhbmRlbGEudjEuR2V0TW9kZWxCcmVha2Rvd25SZXNwb25zZRJsChVHZXRMYXRlbmN5'
    'UGVyY2VudGlsZXMSKC5jYW5kZWxhLnYxLkdldExhdGVuY3lQZXJjZW50aWxlc1JlcXVlc3QaKS'
    '5jYW5kZWxhLnYxLkdldExhdGVuY3lQZXJjZW50aWxlc1Jlc3BvbnNlEksKCkdldE15VXNhZ2US'
    'HS5jYW5kZWxhLnYxLkdldE15VXNhZ2VSZXF1ZXN0Gh4uY2FuZGVsYS52MS5HZXRNeVVzYWdlUm'
    'VzcG9uc2USYwoSR2V0VGVhbUxlYWRlcmJvYXJkEiUuY2FuZGVsYS52MS5HZXRUZWFtTGVhZGVy'
    'Ym9hcmRSZXF1ZXN0GiYuY2FuZGVsYS52MS5HZXRUZWFtTGVhZGVyYm9hcmRSZXNwb25zZRJgCh'
    'FHZXRKb2JMZWFkZXJib2FyZBIkLmNhbmRlbGEudjEuR2V0Sm9iTGVhZGVyYm9hcmRSZXF1ZXN0'
    'GiUuY2FuZGVsYS52MS5HZXRKb2JMZWFkZXJib2FyZFJlc3BvbnNl');
