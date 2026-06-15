//
//  Generated code. Do not modify.
//  source: candela/types/model_catalog.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use modelCatalogEntryDescriptor instead')
const ModelCatalogEntry$json = {
  '1': 'ModelCatalogEntry',
  '2': [
    {'1': 'model_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'modelId'},
    {'1': 'provider', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'provider'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'displayName'},
    {
      '1': 'input_per_million',
      '3': 4,
      '4': 1,
      '5': 1,
      '8': {},
      '10': 'inputPerMillion'
    },
    {
      '1': 'output_per_million',
      '3': 5,
      '4': 1,
      '5': 1,
      '8': {},
      '10': 'outputPerMillion'
    },
    {'1': 'enabled', '3': 6, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'category', '3': 7, '4': 1, '5': 9, '10': 'category'},
    {'1': 'context_window', '3': 8, '4': 1, '5': 3, '10': 'contextWindow'},
    {
      '1': 'input_per_million_high',
      '3': 9,
      '4': 1,
      '5': 1,
      '8': {},
      '10': 'inputPerMillionHigh'
    },
    {
      '1': 'output_per_million_high',
      '3': 10,
      '4': 1,
      '5': 1,
      '8': {},
      '10': 'outputPerMillionHigh'
    },
    {
      '1': 'tier_threshold_tokens',
      '3': 11,
      '4': 1,
      '5': 3,
      '10': 'tierThresholdTokens'
    },
    {'1': 'aliases', '3': 12, '4': 3, '5': 9, '10': 'aliases'},
    {'1': 'allowed_tenants', '3': 13, '4': 3, '5': 9, '10': 'allowedTenants'},
    {
      '1': 'discount_percent',
      '3': 14,
      '4': 1,
      '5': 1,
      '8': {},
      '10': 'discountPercent'
    },
    {
      '1': 'updated_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `ModelCatalogEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modelCatalogEntryDescriptor = $convert.base64Decode(
    'ChFNb2RlbENhdGFsb2dFbnRyeRIlCghtb2RlbF9pZBgBIAEoCUIKukgHcgUQARiAAVIHbW9kZW'
    'xJZBIlCghwcm92aWRlchgCIAEoCUIJukgGcgQQARhAUghwcm92aWRlchIrCgxkaXNwbGF5X25h'
    'bWUYAyABKAlCCLpIBXIDGIACUgtkaXNwbGF5TmFtZRI6ChFpbnB1dF9wZXJfbWlsbGlvbhgEIA'
    'EoAUIOukgLEgkpAAAAAAAAAABSD2lucHV0UGVyTWlsbGlvbhI8ChJvdXRwdXRfcGVyX21pbGxp'
    'b24YBSABKAFCDrpICxIJKQAAAAAAAAAAUhBvdXRwdXRQZXJNaWxsaW9uEhgKB2VuYWJsZWQYBi'
    'ABKAhSB2VuYWJsZWQSGgoIY2F0ZWdvcnkYByABKAlSCGNhdGVnb3J5EiUKDmNvbnRleHRfd2lu'
    'ZG93GAggASgDUg1jb250ZXh0V2luZG93EkMKFmlucHV0X3Blcl9taWxsaW9uX2hpZ2gYCSABKA'
    'FCDrpICxIJKQAAAAAAAAAAUhNpbnB1dFBlck1pbGxpb25IaWdoEkUKF291dHB1dF9wZXJfbWls'
    'bGlvbl9oaWdoGAogASgBQg66SAsSCSkAAAAAAAAAAFIUb3V0cHV0UGVyTWlsbGlvbkhpZ2gSMg'
    'oVdGllcl90aHJlc2hvbGRfdG9rZW5zGAsgASgDUhN0aWVyVGhyZXNob2xkVG9rZW5zEhgKB2Fs'
    'aWFzZXMYDCADKAlSB2FsaWFzZXMSJwoPYWxsb3dlZF90ZW5hbnRzGA0gAygJUg5hbGxvd2VkVG'
    'VuYW50cxJCChBkaXNjb3VudF9wZXJjZW50GA4gASgBQhe6SBQSEhkAAAAAAADwPykAAAAAAAAA'
    'AFIPZGlzY291bnRQZXJjZW50EjkKCnVwZGF0ZWRfYXQYDyABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');
