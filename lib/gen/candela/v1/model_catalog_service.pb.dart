//
//  Generated code. Do not modify.
//  source: candela/v1/model_catalog_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/field_mask.pb.dart' as $1;
import '../types/model_catalog.pb.dart' as $11;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ListModelCatalogRequest extends $pb.GeneratedMessage {
  factory ListModelCatalogRequest({
    $core.bool? includeDisabled,
  }) {
    final $result = create();
    if (includeDisabled != null) {
      $result.includeDisabled = includeDisabled;
    }
    return $result;
  }
  ListModelCatalogRequest._() : super();
  factory ListModelCatalogRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListModelCatalogRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListModelCatalogRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'includeDisabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListModelCatalogRequest clone() =>
      ListModelCatalogRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListModelCatalogRequest copyWith(
          void Function(ListModelCatalogRequest) updates) =>
      super.copyWith((message) => updates(message as ListModelCatalogRequest))
          as ListModelCatalogRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListModelCatalogRequest create() => ListModelCatalogRequest._();
  ListModelCatalogRequest createEmptyInstance() => create();
  static $pb.PbList<ListModelCatalogRequest> createRepeated() =>
      $pb.PbList<ListModelCatalogRequest>();
  @$core.pragma('dart2js:noInline')
  static ListModelCatalogRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListModelCatalogRequest>(create);
  static ListModelCatalogRequest? _defaultInstance;

  /// If true, include disabled models in the response.
  /// Silently ignored for non-admin callers (security: no information leakage).
  @$pb.TagNumber(1)
  $core.bool get includeDisabled => $_getBF(0);
  @$pb.TagNumber(1)
  set includeDisabled($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasIncludeDisabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncludeDisabled() => $_clearField(1);
}

class ListModelCatalogResponse extends $pb.GeneratedMessage {
  factory ListModelCatalogResponse({
    $core.Iterable<$11.ModelCatalogEntry>? models,
    $core.String? source,
    $core.String? version,
    $core.bool? adminEditable,
  }) {
    final $result = create();
    if (models != null) {
      $result.models.addAll(models);
    }
    if (source != null) {
      $result.source = source;
    }
    if (version != null) {
      $result.version = version;
    }
    if (adminEditable != null) {
      $result.adminEditable = adminEditable;
    }
    return $result;
  }
  ListModelCatalogResponse._() : super();
  factory ListModelCatalogResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListModelCatalogResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListModelCatalogResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<$11.ModelCatalogEntry>(
        1, _omitFieldNames ? '' : 'models', $pb.PbFieldType.PM,
        subBuilder: $11.ModelCatalogEntry.create)
    ..aOS(2, _omitFieldNames ? '' : 'source')
    ..aOS(3, _omitFieldNames ? '' : 'version')
    ..aOB(4, _omitFieldNames ? '' : 'adminEditable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListModelCatalogResponse clone() =>
      ListModelCatalogResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListModelCatalogResponse copyWith(
          void Function(ListModelCatalogResponse) updates) =>
      super.copyWith((message) => updates(message as ListModelCatalogResponse))
          as ListModelCatalogResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListModelCatalogResponse create() => ListModelCatalogResponse._();
  ListModelCatalogResponse createEmptyInstance() => create();
  static $pb.PbList<ListModelCatalogResponse> createRepeated() =>
      $pb.PbList<ListModelCatalogResponse>();
  @$core.pragma('dart2js:noInline')
  static ListModelCatalogResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListModelCatalogResponse>(create);
  static ListModelCatalogResponse? _defaultInstance;

  /// All matching catalog entries.
  @$pb.TagNumber(1)
  $pb.PbList<$11.ModelCatalogEntry> get models => $_getList(0);

  /// Backend source identifier: "config", "firestore", "postgres", etc.
  @$pb.TagNumber(2)
  $core.String get source => $_getSZ(1);
  @$pb.TagNumber(2)
  set source($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => $_clearField(2);

  /// Version hash or timestamp. Clients can cache locally and skip re-rendering
  /// if the version has not changed since their last fetch.
  @$pb.TagNumber(3)
  $core.String get version => $_getSZ(2);
  @$pb.TagNumber(3)
  set version($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);

  /// True when the catalog backend supports writes (UpdateModelCatalogEntry).
  @$pb.TagNumber(4)
  $core.bool get adminEditable => $_getBF(3);
  @$pb.TagNumber(4)
  set adminEditable($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasAdminEditable() => $_has(3);
  @$pb.TagNumber(4)
  void clearAdminEditable() => $_clearField(4);
}

class UpdateModelCatalogEntryRequest extends $pb.GeneratedMessage {
  factory UpdateModelCatalogEntryRequest({
    $11.ModelCatalogEntry? entry,
    $1.FieldMask? updateMask,
  }) {
    final $result = create();
    if (entry != null) {
      $result.entry = entry;
    }
    if (updateMask != null) {
      $result.updateMask = updateMask;
    }
    return $result;
  }
  UpdateModelCatalogEntryRequest._() : super();
  factory UpdateModelCatalogEntryRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UpdateModelCatalogEntryRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateModelCatalogEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$11.ModelCatalogEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: $11.ModelCatalogEntry.create)
    ..aOM<$1.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $1.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateModelCatalogEntryRequest clone() =>
      UpdateModelCatalogEntryRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateModelCatalogEntryRequest copyWith(
          void Function(UpdateModelCatalogEntryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateModelCatalogEntryRequest))
          as UpdateModelCatalogEntryRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateModelCatalogEntryRequest create() =>
      UpdateModelCatalogEntryRequest._();
  UpdateModelCatalogEntryRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateModelCatalogEntryRequest> createRepeated() =>
      $pb.PbList<UpdateModelCatalogEntryRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateModelCatalogEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateModelCatalogEntryRequest>(create);
  static UpdateModelCatalogEntryRequest? _defaultInstance;

  /// The catalog entry with updated fields.
  @$pb.TagNumber(1)
  $11.ModelCatalogEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry($11.ModelCatalogEntry v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  $11.ModelCatalogEntry ensureEntry() => $_ensure(0);

  /// Fields to update. If empty, all fields are updated.
  /// Example: paths: ["enabled"] to toggle visibility without touching pricing.
  @$pb.TagNumber(2)
  $1.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($1.FieldMask v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.FieldMask ensureUpdateMask() => $_ensure(1);
}

class UpdateModelCatalogEntryResponse extends $pb.GeneratedMessage {
  factory UpdateModelCatalogEntryResponse({
    $11.ModelCatalogEntry? entry,
  }) {
    final $result = create();
    if (entry != null) {
      $result.entry = entry;
    }
    return $result;
  }
  UpdateModelCatalogEntryResponse._() : super();
  factory UpdateModelCatalogEntryResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UpdateModelCatalogEntryResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateModelCatalogEntryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$11.ModelCatalogEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: $11.ModelCatalogEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateModelCatalogEntryResponse clone() =>
      UpdateModelCatalogEntryResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateModelCatalogEntryResponse copyWith(
          void Function(UpdateModelCatalogEntryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateModelCatalogEntryResponse))
          as UpdateModelCatalogEntryResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateModelCatalogEntryResponse create() =>
      UpdateModelCatalogEntryResponse._();
  UpdateModelCatalogEntryResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateModelCatalogEntryResponse> createRepeated() =>
      $pb.PbList<UpdateModelCatalogEntryResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateModelCatalogEntryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateModelCatalogEntryResponse>(
          create);
  static UpdateModelCatalogEntryResponse? _defaultInstance;

  /// The updated catalog entry as stored.
  @$pb.TagNumber(1)
  $11.ModelCatalogEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry($11.ModelCatalogEntry v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  $11.ModelCatalogEntry ensureEntry() => $_ensure(0);
}

class DeleteModelCatalogEntryRequest extends $pb.GeneratedMessage {
  factory DeleteModelCatalogEntryRequest({
    $core.String? provider,
    $core.String? modelId,
  }) {
    final $result = create();
    if (provider != null) {
      $result.provider = provider;
    }
    if (modelId != null) {
      $result.modelId = modelId;
    }
    return $result;
  }
  DeleteModelCatalogEntryRequest._() : super();
  factory DeleteModelCatalogEntryRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeleteModelCatalogEntryRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteModelCatalogEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'provider')
    ..aOS(2, _omitFieldNames ? '' : 'modelId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteModelCatalogEntryRequest clone() =>
      DeleteModelCatalogEntryRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteModelCatalogEntryRequest copyWith(
          void Function(DeleteModelCatalogEntryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteModelCatalogEntryRequest))
          as DeleteModelCatalogEntryRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteModelCatalogEntryRequest create() =>
      DeleteModelCatalogEntryRequest._();
  DeleteModelCatalogEntryRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteModelCatalogEntryRequest> createRepeated() =>
      $pb.PbList<DeleteModelCatalogEntryRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteModelCatalogEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteModelCatalogEntryRequest>(create);
  static DeleteModelCatalogEntryRequest? _defaultInstance;

  /// Provider of the model to delete.
  @$pb.TagNumber(1)
  $core.String get provider => $_getSZ(0);
  @$pb.TagNumber(1)
  set provider($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvider() => $_clearField(1);

  /// Model ID to delete.
  @$pb.TagNumber(2)
  $core.String get modelId => $_getSZ(1);
  @$pb.TagNumber(2)
  set modelId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasModelId() => $_has(1);
  @$pb.TagNumber(2)
  void clearModelId() => $_clearField(2);
}

class DeleteModelCatalogEntryResponse extends $pb.GeneratedMessage {
  factory DeleteModelCatalogEntryResponse() => create();
  DeleteModelCatalogEntryResponse._() : super();
  factory DeleteModelCatalogEntryResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeleteModelCatalogEntryResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteModelCatalogEntryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteModelCatalogEntryResponse clone() =>
      DeleteModelCatalogEntryResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteModelCatalogEntryResponse copyWith(
          void Function(DeleteModelCatalogEntryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteModelCatalogEntryResponse))
          as DeleteModelCatalogEntryResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteModelCatalogEntryResponse create() =>
      DeleteModelCatalogEntryResponse._();
  DeleteModelCatalogEntryResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteModelCatalogEntryResponse> createRepeated() =>
      $pb.PbList<DeleteModelCatalogEntryResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteModelCatalogEntryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteModelCatalogEntryResponse>(
          create);
  static DeleteModelCatalogEntryResponse? _defaultInstance;
}

/// ModelCatalogService provides read and admin-write access to the model catalog.
/// ListModelCatalog is available to all authenticated users.
/// UpdateModelCatalogEntry is admin-only and requires a database-backed catalog.
class ModelCatalogServiceApi {
  $pb.RpcClient _client;
  ModelCatalogServiceApi(this._client);

  /// ListModelCatalog returns all models in the catalog.
  /// Non-admin callers always receive enabled-only models regardless of include_disabled.
  $async.Future<ListModelCatalogResponse> listModelCatalog(
          $pb.ClientContext? ctx, ListModelCatalogRequest request) =>
      _client.invoke<ListModelCatalogResponse>(ctx, 'ModelCatalogService',
          'ListModelCatalog', request, ListModelCatalogResponse());

  /// UpdateModelCatalogEntry updates a single model entry.
  /// Admin-only. Returns Unimplemented when the catalog backend is read-only (e.g., config file).
  $async.Future<UpdateModelCatalogEntryResponse> updateModelCatalogEntry(
          $pb.ClientContext? ctx, UpdateModelCatalogEntryRequest request) =>
      _client.invoke<UpdateModelCatalogEntryResponse>(
          ctx,
          'ModelCatalogService',
          'UpdateModelCatalogEntry',
          request,
          UpdateModelCatalogEntryResponse());

  /// DeleteModelCatalogEntry removes a model entry from the catalog.
  /// Admin-only. Returns Unimplemented when the catalog backend is read-only.
  /// Semantics: hard delete from the store. To soft-delete, use UpdateModelCatalogEntry
  /// with update_mask: ["enabled"] and enabled: false.
  $async.Future<DeleteModelCatalogEntryResponse> deleteModelCatalogEntry(
          $pb.ClientContext? ctx, DeleteModelCatalogEntryRequest request) =>
      _client.invoke<DeleteModelCatalogEntryResponse>(
          ctx,
          'ModelCatalogService',
          'DeleteModelCatalogEntry',
          request,
          DeleteModelCatalogEntryResponse());
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
