//
//  Generated code. Do not modify.
//  source: candela/v1/project_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../types/common.pb.dart' as $4;
import '../types/project.pb.dart' as $13;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CreateProjectRequest extends $pb.GeneratedMessage {
  factory CreateProjectRequest({
    $core.String? name,
    $core.String? description,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    return $result;
  }
  CreateProjectRequest._() : super();
  factory CreateProjectRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CreateProjectRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateProjectRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectRequest clone() =>
      CreateProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectRequest copyWith(void Function(CreateProjectRequest) updates) =>
      super.copyWith((message) => updates(message as CreateProjectRequest))
          as CreateProjectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateProjectRequest create() => CreateProjectRequest._();
  CreateProjectRequest createEmptyInstance() => create();
  static $pb.PbList<CreateProjectRequest> createRepeated() =>
      $pb.PbList<CreateProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateProjectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateProjectRequest>(create);
  static CreateProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);
}

class CreateProjectResponse extends $pb.GeneratedMessage {
  factory CreateProjectResponse({
    $13.Project? project,
  }) {
    final $result = create();
    if (project != null) {
      $result.project = project;
    }
    return $result;
  }
  CreateProjectResponse._() : super();
  factory CreateProjectResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CreateProjectResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateProjectResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$13.Project>(1, _omitFieldNames ? '' : 'project',
        subBuilder: $13.Project.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectResponse clone() =>
      CreateProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectResponse copyWith(
          void Function(CreateProjectResponse) updates) =>
      super.copyWith((message) => updates(message as CreateProjectResponse))
          as CreateProjectResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateProjectResponse create() => CreateProjectResponse._();
  CreateProjectResponse createEmptyInstance() => create();
  static $pb.PbList<CreateProjectResponse> createRepeated() =>
      $pb.PbList<CreateProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateProjectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateProjectResponse>(create);
  static CreateProjectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $13.Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project($13.Project v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  $13.Project ensureProject() => $_ensure(0);
}

class GetProjectRequest extends $pb.GeneratedMessage {
  factory GetProjectRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetProjectRequest._() : super();
  factory GetProjectRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetProjectRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProjectRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProjectRequest clone() => GetProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProjectRequest copyWith(void Function(GetProjectRequest) updates) =>
      super.copyWith((message) => updates(message as GetProjectRequest))
          as GetProjectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProjectRequest create() => GetProjectRequest._();
  GetProjectRequest createEmptyInstance() => create();
  static $pb.PbList<GetProjectRequest> createRepeated() =>
      $pb.PbList<GetProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static GetProjectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProjectRequest>(create);
  static GetProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetProjectResponse extends $pb.GeneratedMessage {
  factory GetProjectResponse({
    $13.Project? project,
  }) {
    final $result = create();
    if (project != null) {
      $result.project = project;
    }
    return $result;
  }
  GetProjectResponse._() : super();
  factory GetProjectResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetProjectResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProjectResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$13.Project>(1, _omitFieldNames ? '' : 'project',
        subBuilder: $13.Project.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProjectResponse clone() => GetProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProjectResponse copyWith(void Function(GetProjectResponse) updates) =>
      super.copyWith((message) => updates(message as GetProjectResponse))
          as GetProjectResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProjectResponse create() => GetProjectResponse._();
  GetProjectResponse createEmptyInstance() => create();
  static $pb.PbList<GetProjectResponse> createRepeated() =>
      $pb.PbList<GetProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static GetProjectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProjectResponse>(create);
  static GetProjectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $13.Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project($13.Project v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  $13.Project ensureProject() => $_ensure(0);
}

class ListProjectsRequest extends $pb.GeneratedMessage {
  factory ListProjectsRequest({
    $4.PaginationRequest? pagination,
  }) {
    final $result = create();
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListProjectsRequest._() : super();
  factory ListProjectsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListProjectsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProjectsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$4.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $4.PaginationRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProjectsRequest clone() => ListProjectsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProjectsRequest copyWith(void Function(ListProjectsRequest) updates) =>
      super.copyWith((message) => updates(message as ListProjectsRequest))
          as ListProjectsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProjectsRequest create() => ListProjectsRequest._();
  ListProjectsRequest createEmptyInstance() => create();
  static $pb.PbList<ListProjectsRequest> createRepeated() =>
      $pb.PbList<ListProjectsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListProjectsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProjectsRequest>(create);
  static ListProjectsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $4.PaginationRequest get pagination => $_getN(0);
  @$pb.TagNumber(1)
  set pagination($4.PaginationRequest v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(1)
  void clearPagination() => $_clearField(1);
  @$pb.TagNumber(1)
  $4.PaginationRequest ensurePagination() => $_ensure(0);
}

class ListProjectsResponse extends $pb.GeneratedMessage {
  factory ListProjectsResponse({
    $core.Iterable<$13.Project>? projects,
    $4.PaginationResponse? pagination,
  }) {
    final $result = create();
    if (projects != null) {
      $result.projects.addAll(projects);
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListProjectsResponse._() : super();
  factory ListProjectsResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListProjectsResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProjectsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<$13.Project>(1, _omitFieldNames ? '' : 'projects', $pb.PbFieldType.PM,
        subBuilder: $13.Project.create)
    ..aOM<$4.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $4.PaginationResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProjectsResponse clone() =>
      ListProjectsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProjectsResponse copyWith(void Function(ListProjectsResponse) updates) =>
      super.copyWith((message) => updates(message as ListProjectsResponse))
          as ListProjectsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProjectsResponse create() => ListProjectsResponse._();
  ListProjectsResponse createEmptyInstance() => create();
  static $pb.PbList<ListProjectsResponse> createRepeated() =>
      $pb.PbList<ListProjectsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListProjectsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProjectsResponse>(create);
  static ListProjectsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$13.Project> get projects => $_getList(0);

  @$pb.TagNumber(2)
  $4.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($4.PaginationResponse v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $4.PaginationResponse ensurePagination() => $_ensure(1);
}

class DeleteProjectRequest extends $pb.GeneratedMessage {
  factory DeleteProjectRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteProjectRequest._() : super();
  factory DeleteProjectRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeleteProjectRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteProjectRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProjectRequest clone() =>
      DeleteProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProjectRequest copyWith(void Function(DeleteProjectRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteProjectRequest))
          as DeleteProjectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteProjectRequest create() => DeleteProjectRequest._();
  DeleteProjectRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteProjectRequest> createRepeated() =>
      $pb.PbList<DeleteProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteProjectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteProjectRequest>(create);
  static DeleteProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteProjectResponse extends $pb.GeneratedMessage {
  factory DeleteProjectResponse() => create();
  DeleteProjectResponse._() : super();
  factory DeleteProjectResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeleteProjectResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteProjectResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProjectResponse clone() =>
      DeleteProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProjectResponse copyWith(
          void Function(DeleteProjectResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteProjectResponse))
          as DeleteProjectResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteProjectResponse create() => DeleteProjectResponse._();
  DeleteProjectResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteProjectResponse> createRepeated() =>
      $pb.PbList<DeleteProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteProjectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteProjectResponse>(create);
  static DeleteProjectResponse? _defaultInstance;
}

class CreateAPIKeyRequest extends $pb.GeneratedMessage {
  factory CreateAPIKeyRequest({
    $core.String? projectId,
    $core.String? name,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  CreateAPIKeyRequest._() : super();
  factory CreateAPIKeyRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CreateAPIKeyRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateAPIKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAPIKeyRequest clone() => CreateAPIKeyRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAPIKeyRequest copyWith(void Function(CreateAPIKeyRequest) updates) =>
      super.copyWith((message) => updates(message as CreateAPIKeyRequest))
          as CreateAPIKeyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateAPIKeyRequest create() => CreateAPIKeyRequest._();
  CreateAPIKeyRequest createEmptyInstance() => create();
  static $pb.PbList<CreateAPIKeyRequest> createRepeated() =>
      $pb.PbList<CreateAPIKeyRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateAPIKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateAPIKeyRequest>(create);
  static CreateAPIKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class CreateAPIKeyResponse extends $pb.GeneratedMessage {
  factory CreateAPIKeyResponse({
    $13.APIKey? apiKey,
    $core.String? fullKey,
  }) {
    final $result = create();
    if (apiKey != null) {
      $result.apiKey = apiKey;
    }
    if (fullKey != null) {
      $result.fullKey = fullKey;
    }
    return $result;
  }
  CreateAPIKeyResponse._() : super();
  factory CreateAPIKeyResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CreateAPIKeyResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateAPIKeyResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$13.APIKey>(1, _omitFieldNames ? '' : 'apiKey',
        subBuilder: $13.APIKey.create)
    ..aOS(2, _omitFieldNames ? '' : 'fullKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAPIKeyResponse clone() =>
      CreateAPIKeyResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAPIKeyResponse copyWith(void Function(CreateAPIKeyResponse) updates) =>
      super.copyWith((message) => updates(message as CreateAPIKeyResponse))
          as CreateAPIKeyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateAPIKeyResponse create() => CreateAPIKeyResponse._();
  CreateAPIKeyResponse createEmptyInstance() => create();
  static $pb.PbList<CreateAPIKeyResponse> createRepeated() =>
      $pb.PbList<CreateAPIKeyResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateAPIKeyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateAPIKeyResponse>(create);
  static CreateAPIKeyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $13.APIKey get apiKey => $_getN(0);
  @$pb.TagNumber(1)
  set apiKey($13.APIKey v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasApiKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearApiKey() => $_clearField(1);
  @$pb.TagNumber(1)
  $13.APIKey ensureApiKey() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get fullKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set fullKey($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasFullKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearFullKey() => $_clearField(2);
}

class ListAPIKeysRequest extends $pb.GeneratedMessage {
  factory ListAPIKeysRequest({
    $core.String? projectId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    return $result;
  }
  ListAPIKeysRequest._() : super();
  factory ListAPIKeysRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListAPIKeysRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAPIKeysRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAPIKeysRequest clone() => ListAPIKeysRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAPIKeysRequest copyWith(void Function(ListAPIKeysRequest) updates) =>
      super.copyWith((message) => updates(message as ListAPIKeysRequest))
          as ListAPIKeysRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAPIKeysRequest create() => ListAPIKeysRequest._();
  ListAPIKeysRequest createEmptyInstance() => create();
  static $pb.PbList<ListAPIKeysRequest> createRepeated() =>
      $pb.PbList<ListAPIKeysRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAPIKeysRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAPIKeysRequest>(create);
  static ListAPIKeysRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);
}

class ListAPIKeysResponse extends $pb.GeneratedMessage {
  factory ListAPIKeysResponse({
    $core.Iterable<$13.APIKey>? apiKeys,
  }) {
    final $result = create();
    if (apiKeys != null) {
      $result.apiKeys.addAll(apiKeys);
    }
    return $result;
  }
  ListAPIKeysResponse._() : super();
  factory ListAPIKeysResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListAPIKeysResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAPIKeysResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<$13.APIKey>(1, _omitFieldNames ? '' : 'apiKeys', $pb.PbFieldType.PM,
        subBuilder: $13.APIKey.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAPIKeysResponse clone() => ListAPIKeysResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAPIKeysResponse copyWith(void Function(ListAPIKeysResponse) updates) =>
      super.copyWith((message) => updates(message as ListAPIKeysResponse))
          as ListAPIKeysResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAPIKeysResponse create() => ListAPIKeysResponse._();
  ListAPIKeysResponse createEmptyInstance() => create();
  static $pb.PbList<ListAPIKeysResponse> createRepeated() =>
      $pb.PbList<ListAPIKeysResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAPIKeysResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAPIKeysResponse>(create);
  static ListAPIKeysResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$13.APIKey> get apiKeys => $_getList(0);
}

class RevokeAPIKeyRequest extends $pb.GeneratedMessage {
  factory RevokeAPIKeyRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  RevokeAPIKeyRequest._() : super();
  factory RevokeAPIKeyRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RevokeAPIKeyRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeAPIKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeAPIKeyRequest clone() => RevokeAPIKeyRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeAPIKeyRequest copyWith(void Function(RevokeAPIKeyRequest) updates) =>
      super.copyWith((message) => updates(message as RevokeAPIKeyRequest))
          as RevokeAPIKeyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevokeAPIKeyRequest create() => RevokeAPIKeyRequest._();
  RevokeAPIKeyRequest createEmptyInstance() => create();
  static $pb.PbList<RevokeAPIKeyRequest> createRepeated() =>
      $pb.PbList<RevokeAPIKeyRequest>();
  @$core.pragma('dart2js:noInline')
  static RevokeAPIKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeAPIKeyRequest>(create);
  static RevokeAPIKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class RevokeAPIKeyResponse extends $pb.GeneratedMessage {
  factory RevokeAPIKeyResponse() => create();
  RevokeAPIKeyResponse._() : super();
  factory RevokeAPIKeyResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RevokeAPIKeyResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeAPIKeyResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeAPIKeyResponse clone() =>
      RevokeAPIKeyResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeAPIKeyResponse copyWith(void Function(RevokeAPIKeyResponse) updates) =>
      super.copyWith((message) => updates(message as RevokeAPIKeyResponse))
          as RevokeAPIKeyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevokeAPIKeyResponse create() => RevokeAPIKeyResponse._();
  RevokeAPIKeyResponse createEmptyInstance() => create();
  static $pb.PbList<RevokeAPIKeyResponse> createRepeated() =>
      $pb.PbList<RevokeAPIKeyResponse>();
  @$core.pragma('dart2js:noInline')
  static RevokeAPIKeyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeAPIKeyResponse>(create);
  static RevokeAPIKeyResponse? _defaultInstance;
}

/// ProjectService manages projects and API keys.
/// Exposed via ConnectRPC for the web UI.
class ProjectServiceApi {
  $pb.RpcClient _client;
  ProjectServiceApi(this._client);

  $async.Future<CreateProjectResponse> createProject(
          $pb.ClientContext? ctx, CreateProjectRequest request) =>
      _client.invoke<CreateProjectResponse>(ctx, 'ProjectService',
          'CreateProject', request, CreateProjectResponse());
  $async.Future<GetProjectResponse> getProject(
          $pb.ClientContext? ctx, GetProjectRequest request) =>
      _client.invoke<GetProjectResponse>(
          ctx, 'ProjectService', 'GetProject', request, GetProjectResponse());
  $async.Future<ListProjectsResponse> listProjects(
          $pb.ClientContext? ctx, ListProjectsRequest request) =>
      _client.invoke<ListProjectsResponse>(ctx, 'ProjectService',
          'ListProjects', request, ListProjectsResponse());
  $async.Future<DeleteProjectResponse> deleteProject(
          $pb.ClientContext? ctx, DeleteProjectRequest request) =>
      _client.invoke<DeleteProjectResponse>(ctx, 'ProjectService',
          'DeleteProject', request, DeleteProjectResponse());

  /// API Key management
  $async.Future<CreateAPIKeyResponse> createAPIKey(
          $pb.ClientContext? ctx, CreateAPIKeyRequest request) =>
      _client.invoke<CreateAPIKeyResponse>(ctx, 'ProjectService',
          'CreateAPIKey', request, CreateAPIKeyResponse());
  $async.Future<ListAPIKeysResponse> listAPIKeys(
          $pb.ClientContext? ctx, ListAPIKeysRequest request) =>
      _client.invoke<ListAPIKeysResponse>(
          ctx, 'ProjectService', 'ListAPIKeys', request, ListAPIKeysResponse());
  $async.Future<RevokeAPIKeyResponse> revokeAPIKey(
          $pb.ClientContext? ctx, RevokeAPIKeyRequest request) =>
      _client.invoke<RevokeAPIKeyResponse>(ctx, 'ProjectService',
          'RevokeAPIKey', request, RevokeAPIKeyResponse());
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
