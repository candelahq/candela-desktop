//
//  Generated code. Do not modify.
//  source: candela/types/model_catalog.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// ModelCatalogEntry represents a single model in the catalog with its
/// pricing, metadata, and visibility state.
class ModelCatalogEntry extends $pb.GeneratedMessage {
  factory ModelCatalogEntry({
    $core.String? modelId,
    $core.String? provider,
    $core.String? displayName,
    $core.double? inputPerMillion,
    $core.double? outputPerMillion,
    $core.bool? enabled,
    $core.String? category,
    $fixnum.Int64? contextWindow,
    $core.double? inputPerMillionHigh,
    $core.double? outputPerMillionHigh,
    $fixnum.Int64? tierThresholdTokens,
    $core.Iterable<$core.String>? aliases,
    $core.Iterable<$core.String>? allowedTenants,
    $core.double? discountPercent,
    $2.Timestamp? updatedAt,
  }) {
    final $result = create();
    if (modelId != null) {
      $result.modelId = modelId;
    }
    if (provider != null) {
      $result.provider = provider;
    }
    if (displayName != null) {
      $result.displayName = displayName;
    }
    if (inputPerMillion != null) {
      $result.inputPerMillion = inputPerMillion;
    }
    if (outputPerMillion != null) {
      $result.outputPerMillion = outputPerMillion;
    }
    if (enabled != null) {
      $result.enabled = enabled;
    }
    if (category != null) {
      $result.category = category;
    }
    if (contextWindow != null) {
      $result.contextWindow = contextWindow;
    }
    if (inputPerMillionHigh != null) {
      $result.inputPerMillionHigh = inputPerMillionHigh;
    }
    if (outputPerMillionHigh != null) {
      $result.outputPerMillionHigh = outputPerMillionHigh;
    }
    if (tierThresholdTokens != null) {
      $result.tierThresholdTokens = tierThresholdTokens;
    }
    if (aliases != null) {
      $result.aliases.addAll(aliases);
    }
    if (allowedTenants != null) {
      $result.allowedTenants.addAll(allowedTenants);
    }
    if (discountPercent != null) {
      $result.discountPercent = discountPercent;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    return $result;
  }
  ModelCatalogEntry._() : super();
  factory ModelCatalogEntry.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ModelCatalogEntry.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModelCatalogEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'modelId')
    ..aOS(2, _omitFieldNames ? '' : 'provider')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'inputPerMillion', $pb.PbFieldType.OD)
    ..a<$core.double>(
        5, _omitFieldNames ? '' : 'outputPerMillion', $pb.PbFieldType.OD)
    ..aOB(6, _omitFieldNames ? '' : 'enabled')
    ..aOS(7, _omitFieldNames ? '' : 'category')
    ..aInt64(8, _omitFieldNames ? '' : 'contextWindow')
    ..a<$core.double>(
        9, _omitFieldNames ? '' : 'inputPerMillionHigh', $pb.PbFieldType.OD)
    ..a<$core.double>(
        10, _omitFieldNames ? '' : 'outputPerMillionHigh', $pb.PbFieldType.OD)
    ..aInt64(11, _omitFieldNames ? '' : 'tierThresholdTokens')
    ..pPS(12, _omitFieldNames ? '' : 'aliases')
    ..pPS(13, _omitFieldNames ? '' : 'allowedTenants')
    ..a<$core.double>(
        14, _omitFieldNames ? '' : 'discountPercent', $pb.PbFieldType.OD)
    ..aOM<$2.Timestamp>(15, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModelCatalogEntry clone() => ModelCatalogEntry()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModelCatalogEntry copyWith(void Function(ModelCatalogEntry) updates) =>
      super.copyWith((message) => updates(message as ModelCatalogEntry))
          as ModelCatalogEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ModelCatalogEntry create() => ModelCatalogEntry._();
  ModelCatalogEntry createEmptyInstance() => create();
  static $pb.PbList<ModelCatalogEntry> createRepeated() =>
      $pb.PbList<ModelCatalogEntry>();
  @$core.pragma('dart2js:noInline')
  static ModelCatalogEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModelCatalogEntry>(create);
  static ModelCatalogEntry? _defaultInstance;

  /// Canonical short form: "gemini-2.5-pro", "claude-sonnet-4", "gpt-4o"
  @$pb.TagNumber(1)
  $core.String get modelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set modelId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasModelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearModelId() => $_clearField(1);

  /// Provider name: "google", "anthropic", "openai", "mistral", etc.
  @$pb.TagNumber(2)
  $core.String get provider => $_getSZ(1);
  @$pb.TagNumber(2)
  set provider($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProvider() => $_has(1);
  @$pb.TagNumber(2)
  void clearProvider() => $_clearField(2);

  /// Human-readable display name for UI rendering.
  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);

  /// Pricing in USD per 1 million tokens.
  @$pb.TagNumber(4)
  $core.double get inputPerMillion => $_getN(3);
  @$pb.TagNumber(4)
  set inputPerMillion($core.double v) {
    $_setDouble(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasInputPerMillion() => $_has(3);
  @$pb.TagNumber(4)
  void clearInputPerMillion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get outputPerMillion => $_getN(4);
  @$pb.TagNumber(5)
  set outputPerMillion($core.double v) {
    $_setDouble(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasOutputPerMillion() => $_has(4);
  @$pb.TagNumber(5)
  void clearOutputPerMillion() => $_clearField(5);

  /// Admin visibility toggle. Only mutable in database-backed catalog modes.
  @$pb.TagNumber(6)
  $core.bool get enabled => $_getBF(5);
  @$pb.TagNumber(6)
  set enabled($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasEnabled() => $_has(5);
  @$pb.TagNumber(6)
  void clearEnabled() => $_clearField(6);

  /// Model category for grouping in UIs.
  /// Examples: "chat", "code", "reasoning", "embedding"
  @$pb.TagNumber(7)
  $core.String get category => $_getSZ(6);
  @$pb.TagNumber(7)
  set category($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasCategory() => $_has(6);
  @$pb.TagNumber(7)
  void clearCategory() => $_clearField(7);

  /// Maximum context window in tokens. 0 means unknown.
  @$pb.TagNumber(8)
  $fixnum.Int64 get contextWindow => $_getI64(7);
  @$pb.TagNumber(8)
  set contextWindow($fixnum.Int64 v) {
    $_setInt64(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasContextWindow() => $_has(7);
  @$pb.TagNumber(8)
  void clearContextWindow() => $_clearField(8);

  /// Tiered pricing for models that charge higher rates above a token threshold
  /// (e.g., Gemini 2.5 Pro charges more above 200K input tokens).
  @$pb.TagNumber(9)
  $core.double get inputPerMillionHigh => $_getN(8);
  @$pb.TagNumber(9)
  set inputPerMillionHigh($core.double v) {
    $_setDouble(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasInputPerMillionHigh() => $_has(8);
  @$pb.TagNumber(9)
  void clearInputPerMillionHigh() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get outputPerMillionHigh => $_getN(9);
  @$pb.TagNumber(10)
  set outputPerMillionHigh($core.double v) {
    $_setDouble(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasOutputPerMillionHigh() => $_has(9);
  @$pb.TagNumber(10)
  void clearOutputPerMillionHigh() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get tierThresholdTokens => $_getI64(10);
  @$pb.TagNumber(11)
  set tierThresholdTokens($fixnum.Int64 v) {
    $_setInt64(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasTierThresholdTokens() => $_has(10);
  @$pb.TagNumber(11)
  void clearTierThresholdTokens() => $_clearField(11);

  /// Known aliases this entry covers (date-suffixed variants, legacy names).
  /// Example: ["claude-sonnet-4-20250514", "claude-3-5-sonnet-v2"]
  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get aliases => $_getList(11);

  /// Reserved for future multi-tenant catalog isolation.
  /// Empty means visible to all tenants. Non-empty restricts to listed tenants only.
  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get allowedTenants => $_getList(12);

  /// Optional model-level discount (0.0-1.0). Applied before global discount.
  /// Example: 0.25 = 25% discount for negotiated enterprise pricing.
  @$pb.TagNumber(14)
  $core.double get discountPercent => $_getN(13);
  @$pb.TagNumber(14)
  set discountPercent($core.double v) {
    $_setDouble(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasDiscountPercent() => $_has(13);
  @$pb.TagNumber(14)
  void clearDiscountPercent() => $_clearField(14);

  /// When this entry was last modified. Set by the server on writes, read-only
  /// for clients. Useful for audit trail and debugging pricing changes.
  @$pb.TagNumber(15)
  $2.Timestamp get updatedAt => $_getN(14);
  @$pb.TagNumber(15)
  set updatedAt($2.Timestamp v) {
    $_setField(15, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasUpdatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearUpdatedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $2.Timestamp ensureUpdatedAt() => $_ensure(14);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
