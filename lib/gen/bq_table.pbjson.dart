//
//  Generated code. Do not modify.
//  source: bq_table.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use bigQueryMessageOptionsDescriptor instead')
const BigQueryMessageOptions$json = {
  '1': 'BigQueryMessageOptions',
  '2': [
    {'1': 'table_name', '3': 1, '4': 1, '5': 9, '10': 'tableName'},
    {'1': 'use_json_names', '3': 2, '4': 1, '5': 8, '10': 'useJsonNames'},
    {'1': 'extra_fields', '3': 3, '4': 3, '5': 9, '10': 'extraFields'},
    {
      '1': 'output_field_order',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.gen_bq_schema.BigQueryMessageOptions.FieldOrder',
      '10': 'outputFieldOrder'
    },
  ],
  '4': [BigQueryMessageOptions_FieldOrder$json],
};

@$core.Deprecated('Use bigQueryMessageOptionsDescriptor instead')
const BigQueryMessageOptions_FieldOrder$json = {
  '1': 'FieldOrder',
  '2': [
    {'1': 'FIELD_ORDER_UNSPECIFIED', '2': 0},
    {'1': 'FIELD_ORDER_BY_NUMBER', '2': 1},
  ],
};

/// Descriptor for `BigQueryMessageOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bigQueryMessageOptionsDescriptor = $convert.base64Decode(
    'ChZCaWdRdWVyeU1lc3NhZ2VPcHRpb25zEh0KCnRhYmxlX25hbWUYASABKAlSCXRhYmxlTmFtZR'
    'IkCg51c2VfanNvbl9uYW1lcxgCIAEoCFIMdXNlSnNvbk5hbWVzEiEKDGV4dHJhX2ZpZWxkcxgD'
    'IAMoCVILZXh0cmFGaWVsZHMSXgoSb3V0cHV0X2ZpZWxkX29yZGVyGAQgASgOMjAuZ2VuX2JxX3'
    'NjaGVtYS5CaWdRdWVyeU1lc3NhZ2VPcHRpb25zLkZpZWxkT3JkZXJSEG91dHB1dEZpZWxkT3Jk'
    'ZXIiRAoKRmllbGRPcmRlchIbChdGSUVMRF9PUkRFUl9VTlNQRUNJRklFRBAAEhkKFUZJRUxEX0'
    '9SREVSX0JZX05VTUJFUhAB');
