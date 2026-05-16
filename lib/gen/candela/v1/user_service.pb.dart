//
//  Generated code. Do not modify.
//  source: candela/v1/user_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/field_mask.pb.dart' as $1;
import '../../google/protobuf/timestamp.pb.dart' as $2;
import '../types/common.pb.dart' as $4;
import '../types/user.pb.dart' as $7;
import '../types/user.pbenum.dart' as $7;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CreateUserRequest extends $pb.GeneratedMessage {
  factory CreateUserRequest({
    $core.String? email,
    $core.String? displayName,
    $7.UserRole? role,
    $core.double? dailyBudgetUsd,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (displayName != null) {
      $result.displayName = displayName;
    }
    if (role != null) {
      $result.role = role;
    }
    if (dailyBudgetUsd != null) {
      $result.dailyBudgetUsd = dailyBudgetUsd;
    }
    return $result;
  }
  CreateUserRequest._() : super();
  factory CreateUserRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CreateUserRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..e<$7.UserRole>(3, _omitFieldNames ? '' : 'role', $pb.PbFieldType.OE,
        defaultOrMaker: $7.UserRole.USER_ROLE_UNSPECIFIED,
        valueOf: $7.UserRole.valueOf,
        enumValues: $7.UserRole.values)
    ..a<$core.double>(
        5, _omitFieldNames ? '' : 'dailyBudgetUsd', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateUserRequest clone() => CreateUserRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateUserRequest copyWith(void Function(CreateUserRequest) updates) =>
      super.copyWith((message) => updates(message as CreateUserRequest))
          as CreateUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateUserRequest create() => CreateUserRequest._();
  CreateUserRequest createEmptyInstance() => create();
  static $pb.PbList<CreateUserRequest> createRepeated() =>
      $pb.PbList<CreateUserRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateUserRequest>(create);
  static CreateUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $7.UserRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role($7.UserRole v) {
    $_setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(5)
  $core.double get dailyBudgetUsd => $_getN(3);
  @$pb.TagNumber(5)
  set dailyBudgetUsd($core.double v) {
    $_setDouble(3, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDailyBudgetUsd() => $_has(3);
  @$pb.TagNumber(5)
  void clearDailyBudgetUsd() => $_clearField(5);
}

class CreateUserResponse extends $pb.GeneratedMessage {
  factory CreateUserResponse({
    $7.User? user,
    $7.UserBudget? budget,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    if (budget != null) {
      $result.budget = budget;
    }
    return $result;
  }
  CreateUserResponse._() : super();
  factory CreateUserResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CreateUserResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$7.User>(1, _omitFieldNames ? '' : 'user', subBuilder: $7.User.create)
    ..aOM<$7.UserBudget>(2, _omitFieldNames ? '' : 'budget',
        subBuilder: $7.UserBudget.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateUserResponse clone() => CreateUserResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateUserResponse copyWith(void Function(CreateUserResponse) updates) =>
      super.copyWith((message) => updates(message as CreateUserResponse))
          as CreateUserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateUserResponse create() => CreateUserResponse._();
  CreateUserResponse createEmptyInstance() => create();
  static $pb.PbList<CreateUserResponse> createRepeated() =>
      $pb.PbList<CreateUserResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateUserResponse>(create);
  static CreateUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $7.User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user($7.User v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  $7.User ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $7.UserBudget get budget => $_getN(1);
  @$pb.TagNumber(2)
  set budget($7.UserBudget v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasBudget() => $_has(1);
  @$pb.TagNumber(2)
  void clearBudget() => $_clearField(2);
  @$pb.TagNumber(2)
  $7.UserBudget ensureBudget() => $_ensure(1);
}

class ListUsersRequest extends $pb.GeneratedMessage {
  factory ListUsersRequest({
    $4.PaginationRequest? pagination,
    $7.UserStatus? statusFilter,
  }) {
    final $result = create();
    if (pagination != null) {
      $result.pagination = pagination;
    }
    if (statusFilter != null) {
      $result.statusFilter = statusFilter;
    }
    return $result;
  }
  ListUsersRequest._() : super();
  factory ListUsersRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListUsersRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUsersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$4.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $4.PaginationRequest.create)
    ..e<$7.UserStatus>(
        2, _omitFieldNames ? '' : 'statusFilter', $pb.PbFieldType.OE,
        defaultOrMaker: $7.UserStatus.USER_STATUS_UNSPECIFIED,
        valueOf: $7.UserStatus.valueOf,
        enumValues: $7.UserStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUsersRequest clone() => ListUsersRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUsersRequest copyWith(void Function(ListUsersRequest) updates) =>
      super.copyWith((message) => updates(message as ListUsersRequest))
          as ListUsersRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUsersRequest create() => ListUsersRequest._();
  ListUsersRequest createEmptyInstance() => create();
  static $pb.PbList<ListUsersRequest> createRepeated() =>
      $pb.PbList<ListUsersRequest>();
  @$core.pragma('dart2js:noInline')
  static ListUsersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUsersRequest>(create);
  static ListUsersRequest? _defaultInstance;

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

  @$pb.TagNumber(2)
  $7.UserStatus get statusFilter => $_getN(1);
  @$pb.TagNumber(2)
  set statusFilter($7.UserStatus v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasStatusFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusFilter() => $_clearField(2);
}

class ListUsersResponse extends $pb.GeneratedMessage {
  factory ListUsersResponse({
    $core.Iterable<$7.User>? users,
    $4.PaginationResponse? pagination,
  }) {
    final $result = create();
    if (users != null) {
      $result.users.addAll(users);
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListUsersResponse._() : super();
  factory ListUsersResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListUsersResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUsersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<$7.User>(1, _omitFieldNames ? '' : 'users', $pb.PbFieldType.PM,
        subBuilder: $7.User.create)
    ..aOM<$4.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $4.PaginationResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUsersResponse clone() => ListUsersResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUsersResponse copyWith(void Function(ListUsersResponse) updates) =>
      super.copyWith((message) => updates(message as ListUsersResponse))
          as ListUsersResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUsersResponse create() => ListUsersResponse._();
  ListUsersResponse createEmptyInstance() => create();
  static $pb.PbList<ListUsersResponse> createRepeated() =>
      $pb.PbList<ListUsersResponse>();
  @$core.pragma('dart2js:noInline')
  static ListUsersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUsersResponse>(create);
  static ListUsersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$7.User> get users => $_getList(0);

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

class GetUserRequest extends $pb.GeneratedMessage {
  factory GetUserRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetUserRequest._() : super();
  factory GetUserRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetUserRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserRequest clone() => GetUserRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserRequest copyWith(void Function(GetUserRequest) updates) =>
      super.copyWith((message) => updates(message as GetUserRequest))
          as GetUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserRequest create() => GetUserRequest._();
  GetUserRequest createEmptyInstance() => create();
  static $pb.PbList<GetUserRequest> createRepeated() =>
      $pb.PbList<GetUserRequest>();
  @$core.pragma('dart2js:noInline')
  static GetUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserRequest>(create);
  static GetUserRequest? _defaultInstance;

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

class GetUserResponse extends $pb.GeneratedMessage {
  factory GetUserResponse({
    $7.User? user,
    $7.UserBudget? budget,
    $core.Iterable<$7.BudgetGrant>? activeGrants,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    if (budget != null) {
      $result.budget = budget;
    }
    if (activeGrants != null) {
      $result.activeGrants.addAll(activeGrants);
    }
    return $result;
  }
  GetUserResponse._() : super();
  factory GetUserResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetUserResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$7.User>(1, _omitFieldNames ? '' : 'user', subBuilder: $7.User.create)
    ..aOM<$7.UserBudget>(2, _omitFieldNames ? '' : 'budget',
        subBuilder: $7.UserBudget.create)
    ..pc<$7.BudgetGrant>(
        3, _omitFieldNames ? '' : 'activeGrants', $pb.PbFieldType.PM,
        subBuilder: $7.BudgetGrant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserResponse clone() => GetUserResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserResponse copyWith(void Function(GetUserResponse) updates) =>
      super.copyWith((message) => updates(message as GetUserResponse))
          as GetUserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserResponse create() => GetUserResponse._();
  GetUserResponse createEmptyInstance() => create();
  static $pb.PbList<GetUserResponse> createRepeated() =>
      $pb.PbList<GetUserResponse>();
  @$core.pragma('dart2js:noInline')
  static GetUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserResponse>(create);
  static GetUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $7.User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user($7.User v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  $7.User ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $7.UserBudget get budget => $_getN(1);
  @$pb.TagNumber(2)
  set budget($7.UserBudget v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasBudget() => $_has(1);
  @$pb.TagNumber(2)
  void clearBudget() => $_clearField(2);
  @$pb.TagNumber(2)
  $7.UserBudget ensureBudget() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$7.BudgetGrant> get activeGrants => $_getList(2);
}

class UpdateUserRequest extends $pb.GeneratedMessage {
  factory UpdateUserRequest({
    $core.String? id,
    $core.String? displayName,
    $7.UserRole? role,
    $1.FieldMask? updateMask,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (displayName != null) {
      $result.displayName = displayName;
    }
    if (role != null) {
      $result.role = role;
    }
    if (updateMask != null) {
      $result.updateMask = updateMask;
    }
    return $result;
  }
  UpdateUserRequest._() : super();
  factory UpdateUserRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UpdateUserRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..e<$7.UserRole>(3, _omitFieldNames ? '' : 'role', $pb.PbFieldType.OE,
        defaultOrMaker: $7.UserRole.USER_ROLE_UNSPECIFIED,
        valueOf: $7.UserRole.valueOf,
        enumValues: $7.UserRole.values)
    ..aOM<$1.FieldMask>(4, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $1.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserRequest clone() => UpdateUserRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserRequest copyWith(void Function(UpdateUserRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateUserRequest))
          as UpdateUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserRequest create() => UpdateUserRequest._();
  UpdateUserRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateUserRequest> createRepeated() =>
      $pb.PbList<UpdateUserRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateUserRequest>(create);
  static UpdateUserRequest? _defaultInstance;

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

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $7.UserRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role($7.UserRole v) {
    $_setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.FieldMask get updateMask => $_getN(3);
  @$pb.TagNumber(4)
  set updateMask($1.FieldMask v) {
    $_setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasUpdateMask() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdateMask() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.FieldMask ensureUpdateMask() => $_ensure(3);
}

class UpdateUserResponse extends $pb.GeneratedMessage {
  factory UpdateUserResponse({
    $7.User? user,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  UpdateUserResponse._() : super();
  factory UpdateUserResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UpdateUserResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$7.User>(1, _omitFieldNames ? '' : 'user', subBuilder: $7.User.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserResponse clone() => UpdateUserResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserResponse copyWith(void Function(UpdateUserResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateUserResponse))
          as UpdateUserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserResponse create() => UpdateUserResponse._();
  UpdateUserResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateUserResponse> createRepeated() =>
      $pb.PbList<UpdateUserResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateUserResponse>(create);
  static UpdateUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $7.User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user($7.User v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  $7.User ensureUser() => $_ensure(0);
}

class DeactivateUserRequest extends $pb.GeneratedMessage {
  factory DeactivateUserRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeactivateUserRequest._() : super();
  factory DeactivateUserRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeactivateUserRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeactivateUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeactivateUserRequest clone() =>
      DeactivateUserRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeactivateUserRequest copyWith(
          void Function(DeactivateUserRequest) updates) =>
      super.copyWith((message) => updates(message as DeactivateUserRequest))
          as DeactivateUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeactivateUserRequest create() => DeactivateUserRequest._();
  DeactivateUserRequest createEmptyInstance() => create();
  static $pb.PbList<DeactivateUserRequest> createRepeated() =>
      $pb.PbList<DeactivateUserRequest>();
  @$core.pragma('dart2js:noInline')
  static DeactivateUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeactivateUserRequest>(create);
  static DeactivateUserRequest? _defaultInstance;

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

class DeactivateUserResponse extends $pb.GeneratedMessage {
  factory DeactivateUserResponse() => create();
  DeactivateUserResponse._() : super();
  factory DeactivateUserResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeactivateUserResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeactivateUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeactivateUserResponse clone() =>
      DeactivateUserResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeactivateUserResponse copyWith(
          void Function(DeactivateUserResponse) updates) =>
      super.copyWith((message) => updates(message as DeactivateUserResponse))
          as DeactivateUserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeactivateUserResponse create() => DeactivateUserResponse._();
  DeactivateUserResponse createEmptyInstance() => create();
  static $pb.PbList<DeactivateUserResponse> createRepeated() =>
      $pb.PbList<DeactivateUserResponse>();
  @$core.pragma('dart2js:noInline')
  static DeactivateUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeactivateUserResponse>(create);
  static DeactivateUserResponse? _defaultInstance;
}

class ReactivateUserRequest extends $pb.GeneratedMessage {
  factory ReactivateUserRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  ReactivateUserRequest._() : super();
  factory ReactivateUserRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ReactivateUserRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReactivateUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReactivateUserRequest clone() =>
      ReactivateUserRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReactivateUserRequest copyWith(
          void Function(ReactivateUserRequest) updates) =>
      super.copyWith((message) => updates(message as ReactivateUserRequest))
          as ReactivateUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReactivateUserRequest create() => ReactivateUserRequest._();
  ReactivateUserRequest createEmptyInstance() => create();
  static $pb.PbList<ReactivateUserRequest> createRepeated() =>
      $pb.PbList<ReactivateUserRequest>();
  @$core.pragma('dart2js:noInline')
  static ReactivateUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReactivateUserRequest>(create);
  static ReactivateUserRequest? _defaultInstance;

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

class ReactivateUserResponse extends $pb.GeneratedMessage {
  factory ReactivateUserResponse({
    $7.User? user,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  ReactivateUserResponse._() : super();
  factory ReactivateUserResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ReactivateUserResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReactivateUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$7.User>(1, _omitFieldNames ? '' : 'user', subBuilder: $7.User.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReactivateUserResponse clone() =>
      ReactivateUserResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReactivateUserResponse copyWith(
          void Function(ReactivateUserResponse) updates) =>
      super.copyWith((message) => updates(message as ReactivateUserResponse))
          as ReactivateUserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReactivateUserResponse create() => ReactivateUserResponse._();
  ReactivateUserResponse createEmptyInstance() => create();
  static $pb.PbList<ReactivateUserResponse> createRepeated() =>
      $pb.PbList<ReactivateUserResponse>();
  @$core.pragma('dart2js:noInline')
  static ReactivateUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReactivateUserResponse>(create);
  static ReactivateUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $7.User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user($7.User v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  $7.User ensureUser() => $_ensure(0);
}

class DeleteUserRequest extends $pb.GeneratedMessage {
  factory DeleteUserRequest({
    $core.String? id,
    $core.String? confirmEmail,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (confirmEmail != null) {
      $result.confirmEmail = confirmEmail;
    }
    return $result;
  }
  DeleteUserRequest._() : super();
  factory DeleteUserRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeleteUserRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'confirmEmail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteUserRequest clone() => DeleteUserRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteUserRequest copyWith(void Function(DeleteUserRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteUserRequest))
          as DeleteUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteUserRequest create() => DeleteUserRequest._();
  DeleteUserRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteUserRequest> createRepeated() =>
      $pb.PbList<DeleteUserRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteUserRequest>(create);
  static DeleteUserRequest? _defaultInstance;

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

  /// Confirmation: must match user's email to prevent accidental deletion.
  @$pb.TagNumber(2)
  $core.String get confirmEmail => $_getSZ(1);
  @$pb.TagNumber(2)
  set confirmEmail($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasConfirmEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfirmEmail() => $_clearField(2);
}

class DeleteUserResponse extends $pb.GeneratedMessage {
  factory DeleteUserResponse() => create();
  DeleteUserResponse._() : super();
  factory DeleteUserResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeleteUserResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteUserResponse clone() => DeleteUserResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteUserResponse copyWith(void Function(DeleteUserResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteUserResponse))
          as DeleteUserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteUserResponse create() => DeleteUserResponse._();
  DeleteUserResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteUserResponse> createRepeated() =>
      $pb.PbList<DeleteUserResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteUserResponse>(create);
  static DeleteUserResponse? _defaultInstance;
}

class SetBudgetRequest extends $pb.GeneratedMessage {
  factory SetBudgetRequest({
    $core.String? userId,
    $core.double? limitUsd,
    $7.BudgetPeriod? periodType,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (limitUsd != null) {
      $result.limitUsd = limitUsd;
    }
    if (periodType != null) {
      $result.periodType = periodType;
    }
    return $result;
  }
  SetBudgetRequest._() : super();
  factory SetBudgetRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SetBudgetRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetBudgetRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'limitUsd', $pb.PbFieldType.OD)
    ..e<$7.BudgetPeriod>(
        3, _omitFieldNames ? '' : 'periodType', $pb.PbFieldType.OE,
        defaultOrMaker: $7.BudgetPeriod.BUDGET_PERIOD_UNSPECIFIED,
        valueOf: $7.BudgetPeriod.valueOf,
        enumValues: $7.BudgetPeriod.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetBudgetRequest clone() => SetBudgetRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetBudgetRequest copyWith(void Function(SetBudgetRequest) updates) =>
      super.copyWith((message) => updates(message as SetBudgetRequest))
          as SetBudgetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetBudgetRequest create() => SetBudgetRequest._();
  SetBudgetRequest createEmptyInstance() => create();
  static $pb.PbList<SetBudgetRequest> createRepeated() =>
      $pb.PbList<SetBudgetRequest>();
  @$core.pragma('dart2js:noInline')
  static SetBudgetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetBudgetRequest>(create);
  static SetBudgetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get limitUsd => $_getN(1);
  @$pb.TagNumber(2)
  set limitUsd($core.double v) {
    $_setDouble(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLimitUsd() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimitUsd() => $_clearField(2);

  @$pb.TagNumber(3)
  $7.BudgetPeriod get periodType => $_getN(2);
  @$pb.TagNumber(3)
  set periodType($7.BudgetPeriod v) {
    $_setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPeriodType() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodType() => $_clearField(3);
}

class SetBudgetResponse extends $pb.GeneratedMessage {
  factory SetBudgetResponse({
    $7.UserBudget? budget,
  }) {
    final $result = create();
    if (budget != null) {
      $result.budget = budget;
    }
    return $result;
  }
  SetBudgetResponse._() : super();
  factory SetBudgetResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SetBudgetResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetBudgetResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$7.UserBudget>(1, _omitFieldNames ? '' : 'budget',
        subBuilder: $7.UserBudget.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetBudgetResponse clone() => SetBudgetResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetBudgetResponse copyWith(void Function(SetBudgetResponse) updates) =>
      super.copyWith((message) => updates(message as SetBudgetResponse))
          as SetBudgetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetBudgetResponse create() => SetBudgetResponse._();
  SetBudgetResponse createEmptyInstance() => create();
  static $pb.PbList<SetBudgetResponse> createRepeated() =>
      $pb.PbList<SetBudgetResponse>();
  @$core.pragma('dart2js:noInline')
  static SetBudgetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetBudgetResponse>(create);
  static SetBudgetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $7.UserBudget get budget => $_getN(0);
  @$pb.TagNumber(1)
  set budget($7.UserBudget v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBudget() => $_has(0);
  @$pb.TagNumber(1)
  void clearBudget() => $_clearField(1);
  @$pb.TagNumber(1)
  $7.UserBudget ensureBudget() => $_ensure(0);
}

class GetBudgetRequest extends $pb.GeneratedMessage {
  factory GetBudgetRequest({
    $core.String? userId,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    return $result;
  }
  GetBudgetRequest._() : super();
  factory GetBudgetRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetBudgetRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBudgetRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBudgetRequest clone() => GetBudgetRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBudgetRequest copyWith(void Function(GetBudgetRequest) updates) =>
      super.copyWith((message) => updates(message as GetBudgetRequest))
          as GetBudgetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBudgetRequest create() => GetBudgetRequest._();
  GetBudgetRequest createEmptyInstance() => create();
  static $pb.PbList<GetBudgetRequest> createRepeated() =>
      $pb.PbList<GetBudgetRequest>();
  @$core.pragma('dart2js:noInline')
  static GetBudgetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBudgetRequest>(create);
  static GetBudgetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class GetBudgetResponse extends $pb.GeneratedMessage {
  factory GetBudgetResponse({
    $7.UserBudget? budget,
  }) {
    final $result = create();
    if (budget != null) {
      $result.budget = budget;
    }
    return $result;
  }
  GetBudgetResponse._() : super();
  factory GetBudgetResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetBudgetResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBudgetResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$7.UserBudget>(1, _omitFieldNames ? '' : 'budget',
        subBuilder: $7.UserBudget.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBudgetResponse clone() => GetBudgetResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBudgetResponse copyWith(void Function(GetBudgetResponse) updates) =>
      super.copyWith((message) => updates(message as GetBudgetResponse))
          as GetBudgetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBudgetResponse create() => GetBudgetResponse._();
  GetBudgetResponse createEmptyInstance() => create();
  static $pb.PbList<GetBudgetResponse> createRepeated() =>
      $pb.PbList<GetBudgetResponse>();
  @$core.pragma('dart2js:noInline')
  static GetBudgetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBudgetResponse>(create);
  static GetBudgetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $7.UserBudget get budget => $_getN(0);
  @$pb.TagNumber(1)
  set budget($7.UserBudget v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBudget() => $_has(0);
  @$pb.TagNumber(1)
  void clearBudget() => $_clearField(1);
  @$pb.TagNumber(1)
  $7.UserBudget ensureBudget() => $_ensure(0);
}

class ResetSpendRequest extends $pb.GeneratedMessage {
  factory ResetSpendRequest({
    $core.String? userId,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    return $result;
  }
  ResetSpendRequest._() : super();
  factory ResetSpendRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ResetSpendRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetSpendRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetSpendRequest clone() => ResetSpendRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetSpendRequest copyWith(void Function(ResetSpendRequest) updates) =>
      super.copyWith((message) => updates(message as ResetSpendRequest))
          as ResetSpendRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetSpendRequest create() => ResetSpendRequest._();
  ResetSpendRequest createEmptyInstance() => create();
  static $pb.PbList<ResetSpendRequest> createRepeated() =>
      $pb.PbList<ResetSpendRequest>();
  @$core.pragma('dart2js:noInline')
  static ResetSpendRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResetSpendRequest>(create);
  static ResetSpendRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class ResetSpendResponse extends $pb.GeneratedMessage {
  factory ResetSpendResponse({
    $7.UserBudget? budget,
  }) {
    final $result = create();
    if (budget != null) {
      $result.budget = budget;
    }
    return $result;
  }
  ResetSpendResponse._() : super();
  factory ResetSpendResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ResetSpendResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetSpendResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$7.UserBudget>(1, _omitFieldNames ? '' : 'budget',
        subBuilder: $7.UserBudget.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetSpendResponse clone() => ResetSpendResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetSpendResponse copyWith(void Function(ResetSpendResponse) updates) =>
      super.copyWith((message) => updates(message as ResetSpendResponse))
          as ResetSpendResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetSpendResponse create() => ResetSpendResponse._();
  ResetSpendResponse createEmptyInstance() => create();
  static $pb.PbList<ResetSpendResponse> createRepeated() =>
      $pb.PbList<ResetSpendResponse>();
  @$core.pragma('dart2js:noInline')
  static ResetSpendResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResetSpendResponse>(create);
  static ResetSpendResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $7.UserBudget get budget => $_getN(0);
  @$pb.TagNumber(1)
  set budget($7.UserBudget v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBudget() => $_has(0);
  @$pb.TagNumber(1)
  void clearBudget() => $_clearField(1);
  @$pb.TagNumber(1)
  $7.UserBudget ensureBudget() => $_ensure(0);
}

class CreateGrantRequest extends $pb.GeneratedMessage {
  factory CreateGrantRequest({
    $core.String? userId,
    $core.double? amountUsd,
    $core.String? reason,
    $2.Timestamp? startsAt,
    $2.Timestamp? expiresAt,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (amountUsd != null) {
      $result.amountUsd = amountUsd;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    if (startsAt != null) {
      $result.startsAt = startsAt;
    }
    if (expiresAt != null) {
      $result.expiresAt = expiresAt;
    }
    return $result;
  }
  CreateGrantRequest._() : super();
  factory CreateGrantRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CreateGrantRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateGrantRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'amountUsd', $pb.PbFieldType.OD)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOM<$2.Timestamp>(4, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(5, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateGrantRequest clone() => CreateGrantRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateGrantRequest copyWith(void Function(CreateGrantRequest) updates) =>
      super.copyWith((message) => updates(message as CreateGrantRequest))
          as CreateGrantRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateGrantRequest create() => CreateGrantRequest._();
  CreateGrantRequest createEmptyInstance() => create();
  static $pb.PbList<CreateGrantRequest> createRepeated() =>
      $pb.PbList<CreateGrantRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateGrantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateGrantRequest>(create);
  static CreateGrantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get amountUsd => $_getN(1);
  @$pb.TagNumber(2)
  set amountUsd($core.double v) {
    $_setDouble(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAmountUsd() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmountUsd() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Timestamp get startsAt => $_getN(3);
  @$pb.TagNumber(4)
  set startsAt($2.Timestamp v) {
    $_setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasStartsAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartsAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Timestamp ensureStartsAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.Timestamp get expiresAt => $_getN(4);
  @$pb.TagNumber(5)
  set expiresAt($2.Timestamp v) {
    $_setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasExpiresAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Timestamp ensureExpiresAt() => $_ensure(4);
}

class CreateGrantResponse extends $pb.GeneratedMessage {
  factory CreateGrantResponse({
    $7.BudgetGrant? grant,
  }) {
    final $result = create();
    if (grant != null) {
      $result.grant = grant;
    }
    return $result;
  }
  CreateGrantResponse._() : super();
  factory CreateGrantResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CreateGrantResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateGrantResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$7.BudgetGrant>(1, _omitFieldNames ? '' : 'grant',
        subBuilder: $7.BudgetGrant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateGrantResponse clone() => CreateGrantResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateGrantResponse copyWith(void Function(CreateGrantResponse) updates) =>
      super.copyWith((message) => updates(message as CreateGrantResponse))
          as CreateGrantResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateGrantResponse create() => CreateGrantResponse._();
  CreateGrantResponse createEmptyInstance() => create();
  static $pb.PbList<CreateGrantResponse> createRepeated() =>
      $pb.PbList<CreateGrantResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateGrantResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateGrantResponse>(create);
  static CreateGrantResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $7.BudgetGrant get grant => $_getN(0);
  @$pb.TagNumber(1)
  set grant($7.BudgetGrant v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasGrant() => $_has(0);
  @$pb.TagNumber(1)
  void clearGrant() => $_clearField(1);
  @$pb.TagNumber(1)
  $7.BudgetGrant ensureGrant() => $_ensure(0);
}

class ListGrantsRequest extends $pb.GeneratedMessage {
  factory ListGrantsRequest({
    $core.String? userId,
    $core.bool? activeOnly,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (activeOnly != null) {
      $result.activeOnly = activeOnly;
    }
    return $result;
  }
  ListGrantsRequest._() : super();
  factory ListGrantsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListGrantsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListGrantsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOB(2, _omitFieldNames ? '' : 'activeOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListGrantsRequest clone() => ListGrantsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListGrantsRequest copyWith(void Function(ListGrantsRequest) updates) =>
      super.copyWith((message) => updates(message as ListGrantsRequest))
          as ListGrantsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListGrantsRequest create() => ListGrantsRequest._();
  ListGrantsRequest createEmptyInstance() => create();
  static $pb.PbList<ListGrantsRequest> createRepeated() =>
      $pb.PbList<ListGrantsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListGrantsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListGrantsRequest>(create);
  static ListGrantsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get activeOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set activeOnly($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasActiveOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearActiveOnly() => $_clearField(2);
}

class ListGrantsResponse extends $pb.GeneratedMessage {
  factory ListGrantsResponse({
    $core.Iterable<$7.BudgetGrant>? grants,
  }) {
    final $result = create();
    if (grants != null) {
      $result.grants.addAll(grants);
    }
    return $result;
  }
  ListGrantsResponse._() : super();
  factory ListGrantsResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListGrantsResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListGrantsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<$7.BudgetGrant>(1, _omitFieldNames ? '' : 'grants', $pb.PbFieldType.PM,
        subBuilder: $7.BudgetGrant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListGrantsResponse clone() => ListGrantsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListGrantsResponse copyWith(void Function(ListGrantsResponse) updates) =>
      super.copyWith((message) => updates(message as ListGrantsResponse))
          as ListGrantsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListGrantsResponse create() => ListGrantsResponse._();
  ListGrantsResponse createEmptyInstance() => create();
  static $pb.PbList<ListGrantsResponse> createRepeated() =>
      $pb.PbList<ListGrantsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListGrantsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListGrantsResponse>(create);
  static ListGrantsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$7.BudgetGrant> get grants => $_getList(0);
}

class RevokeGrantRequest extends $pb.GeneratedMessage {
  factory RevokeGrantRequest({
    $core.String? userId,
    $core.String? grantId,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (grantId != null) {
      $result.grantId = grantId;
    }
    return $result;
  }
  RevokeGrantRequest._() : super();
  factory RevokeGrantRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RevokeGrantRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeGrantRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'grantId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeGrantRequest clone() => RevokeGrantRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeGrantRequest copyWith(void Function(RevokeGrantRequest) updates) =>
      super.copyWith((message) => updates(message as RevokeGrantRequest))
          as RevokeGrantRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevokeGrantRequest create() => RevokeGrantRequest._();
  RevokeGrantRequest createEmptyInstance() => create();
  static $pb.PbList<RevokeGrantRequest> createRepeated() =>
      $pb.PbList<RevokeGrantRequest>();
  @$core.pragma('dart2js:noInline')
  static RevokeGrantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeGrantRequest>(create);
  static RevokeGrantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get grantId => $_getSZ(1);
  @$pb.TagNumber(2)
  set grantId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasGrantId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGrantId() => $_clearField(2);
}

class RevokeGrantResponse extends $pb.GeneratedMessage {
  factory RevokeGrantResponse() => create();
  RevokeGrantResponse._() : super();
  factory RevokeGrantResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RevokeGrantResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeGrantResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeGrantResponse clone() => RevokeGrantResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeGrantResponse copyWith(void Function(RevokeGrantResponse) updates) =>
      super.copyWith((message) => updates(message as RevokeGrantResponse))
          as RevokeGrantResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevokeGrantResponse create() => RevokeGrantResponse._();
  RevokeGrantResponse createEmptyInstance() => create();
  static $pb.PbList<RevokeGrantResponse> createRepeated() =>
      $pb.PbList<RevokeGrantResponse>();
  @$core.pragma('dart2js:noInline')
  static RevokeGrantResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeGrantResponse>(create);
  static RevokeGrantResponse? _defaultInstance;
}

class ListAuditLogRequest extends $pb.GeneratedMessage {
  factory ListAuditLogRequest({
    $core.String? userId,
    $core.int? limit,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    return $result;
  }
  ListAuditLogRequest._() : super();
  factory ListAuditLogRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListAuditLogRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAuditLogRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuditLogRequest clone() => ListAuditLogRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuditLogRequest copyWith(void Function(ListAuditLogRequest) updates) =>
      super.copyWith((message) => updates(message as ListAuditLogRequest))
          as ListAuditLogRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAuditLogRequest create() => ListAuditLogRequest._();
  ListAuditLogRequest createEmptyInstance() => create();
  static $pb.PbList<ListAuditLogRequest> createRepeated() =>
      $pb.PbList<ListAuditLogRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAuditLogRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAuditLogRequest>(create);
  static ListAuditLogRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class ListAuditLogResponse extends $pb.GeneratedMessage {
  factory ListAuditLogResponse({
    $core.Iterable<$7.AuditEntry>? entries,
  }) {
    final $result = create();
    if (entries != null) {
      $result.entries.addAll(entries);
    }
    return $result;
  }
  ListAuditLogResponse._() : super();
  factory ListAuditLogResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListAuditLogResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAuditLogResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..pc<$7.AuditEntry>(1, _omitFieldNames ? '' : 'entries', $pb.PbFieldType.PM,
        subBuilder: $7.AuditEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuditLogResponse clone() =>
      ListAuditLogResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuditLogResponse copyWith(void Function(ListAuditLogResponse) updates) =>
      super.copyWith((message) => updates(message as ListAuditLogResponse))
          as ListAuditLogResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAuditLogResponse create() => ListAuditLogResponse._();
  ListAuditLogResponse createEmptyInstance() => create();
  static $pb.PbList<ListAuditLogResponse> createRepeated() =>
      $pb.PbList<ListAuditLogResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAuditLogResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAuditLogResponse>(create);
  static ListAuditLogResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$7.AuditEntry> get entries => $_getList(0);
}

class GetCurrentUserRequest extends $pb.GeneratedMessage {
  factory GetCurrentUserRequest() => create();
  GetCurrentUserRequest._() : super();
  factory GetCurrentUserRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetCurrentUserRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCurrentUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentUserRequest clone() =>
      GetCurrentUserRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentUserRequest copyWith(
          void Function(GetCurrentUserRequest) updates) =>
      super.copyWith((message) => updates(message as GetCurrentUserRequest))
          as GetCurrentUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentUserRequest create() => GetCurrentUserRequest._();
  GetCurrentUserRequest createEmptyInstance() => create();
  static $pb.PbList<GetCurrentUserRequest> createRepeated() =>
      $pb.PbList<GetCurrentUserRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCurrentUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCurrentUserRequest>(create);
  static GetCurrentUserRequest? _defaultInstance;
}

class GetCurrentUserResponse extends $pb.GeneratedMessage {
  factory GetCurrentUserResponse({
    $7.User? user,
    $7.UserBudget? budget,
    $core.Iterable<$7.BudgetGrant>? activeGrants,
    $core.double? totalRemainingUsd,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    if (budget != null) {
      $result.budget = budget;
    }
    if (activeGrants != null) {
      $result.activeGrants.addAll(activeGrants);
    }
    if (totalRemainingUsd != null) {
      $result.totalRemainingUsd = totalRemainingUsd;
    }
    return $result;
  }
  GetCurrentUserResponse._() : super();
  factory GetCurrentUserResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetCurrentUserResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCurrentUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$7.User>(1, _omitFieldNames ? '' : 'user', subBuilder: $7.User.create)
    ..aOM<$7.UserBudget>(2, _omitFieldNames ? '' : 'budget',
        subBuilder: $7.UserBudget.create)
    ..pc<$7.BudgetGrant>(
        3, _omitFieldNames ? '' : 'activeGrants', $pb.PbFieldType.PM,
        subBuilder: $7.BudgetGrant.create)
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'totalRemainingUsd', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentUserResponse clone() =>
      GetCurrentUserResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentUserResponse copyWith(
          void Function(GetCurrentUserResponse) updates) =>
      super.copyWith((message) => updates(message as GetCurrentUserResponse))
          as GetCurrentUserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentUserResponse create() => GetCurrentUserResponse._();
  GetCurrentUserResponse createEmptyInstance() => create();
  static $pb.PbList<GetCurrentUserResponse> createRepeated() =>
      $pb.PbList<GetCurrentUserResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCurrentUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCurrentUserResponse>(create);
  static GetCurrentUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $7.User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user($7.User v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  $7.User ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $7.UserBudget get budget => $_getN(1);
  @$pb.TagNumber(2)
  set budget($7.UserBudget v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasBudget() => $_has(1);
  @$pb.TagNumber(2)
  void clearBudget() => $_clearField(2);
  @$pb.TagNumber(2)
  $7.UserBudget ensureBudget() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$7.BudgetGrant> get activeGrants => $_getList(2);

  @$pb.TagNumber(4)
  $core.double get totalRemainingUsd => $_getN(3);
  @$pb.TagNumber(4)
  set totalRemainingUsd($core.double v) {
    $_setDouble(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTotalRemainingUsd() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalRemainingUsd() => $_clearField(4);
}

class GetMyBudgetRequest extends $pb.GeneratedMessage {
  factory GetMyBudgetRequest() => create();
  GetMyBudgetRequest._() : super();
  factory GetMyBudgetRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetMyBudgetRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyBudgetRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyBudgetRequest clone() => GetMyBudgetRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyBudgetRequest copyWith(void Function(GetMyBudgetRequest) updates) =>
      super.copyWith((message) => updates(message as GetMyBudgetRequest))
          as GetMyBudgetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMyBudgetRequest create() => GetMyBudgetRequest._();
  GetMyBudgetRequest createEmptyInstance() => create();
  static $pb.PbList<GetMyBudgetRequest> createRepeated() =>
      $pb.PbList<GetMyBudgetRequest>();
  @$core.pragma('dart2js:noInline')
  static GetMyBudgetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMyBudgetRequest>(create);
  static GetMyBudgetRequest? _defaultInstance;
}

class GetMyBudgetResponse extends $pb.GeneratedMessage {
  factory GetMyBudgetResponse({
    $7.UserBudget? budget,
    $core.Iterable<$7.BudgetGrant>? activeGrants,
    $core.double? totalRemainingUsd,
    $core.double? budgetRemainingUsd,
    $core.double? grantsRemainingUsd,
    $fixnum.Int64? tokensUsedToday,
    $core.String? periodKey,
    $core.String? periodResetsAt,
  }) {
    final $result = create();
    if (budget != null) {
      $result.budget = budget;
    }
    if (activeGrants != null) {
      $result.activeGrants.addAll(activeGrants);
    }
    if (totalRemainingUsd != null) {
      $result.totalRemainingUsd = totalRemainingUsd;
    }
    if (budgetRemainingUsd != null) {
      $result.budgetRemainingUsd = budgetRemainingUsd;
    }
    if (grantsRemainingUsd != null) {
      $result.grantsRemainingUsd = grantsRemainingUsd;
    }
    if (tokensUsedToday != null) {
      $result.tokensUsedToday = tokensUsedToday;
    }
    if (periodKey != null) {
      $result.periodKey = periodKey;
    }
    if (periodResetsAt != null) {
      $result.periodResetsAt = periodResetsAt;
    }
    return $result;
  }
  GetMyBudgetResponse._() : super();
  factory GetMyBudgetResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetMyBudgetResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyBudgetResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.v1'),
      createEmptyInstance: create)
    ..aOM<$7.UserBudget>(1, _omitFieldNames ? '' : 'budget',
        subBuilder: $7.UserBudget.create)
    ..pc<$7.BudgetGrant>(
        2, _omitFieldNames ? '' : 'activeGrants', $pb.PbFieldType.PM,
        subBuilder: $7.BudgetGrant.create)
    ..a<$core.double>(
        3, _omitFieldNames ? '' : 'totalRemainingUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'budgetRemainingUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(
        5, _omitFieldNames ? '' : 'grantsRemainingUsd', $pb.PbFieldType.OD)
    ..aInt64(10, _omitFieldNames ? '' : 'tokensUsedToday')
    ..aOS(20, _omitFieldNames ? '' : 'periodKey')
    ..aOS(21, _omitFieldNames ? '' : 'periodResetsAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyBudgetResponse clone() => GetMyBudgetResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyBudgetResponse copyWith(void Function(GetMyBudgetResponse) updates) =>
      super.copyWith((message) => updates(message as GetMyBudgetResponse))
          as GetMyBudgetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMyBudgetResponse create() => GetMyBudgetResponse._();
  GetMyBudgetResponse createEmptyInstance() => create();
  static $pb.PbList<GetMyBudgetResponse> createRepeated() =>
      $pb.PbList<GetMyBudgetResponse>();
  @$core.pragma('dart2js:noInline')
  static GetMyBudgetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMyBudgetResponse>(create);
  static GetMyBudgetResponse? _defaultInstance;

  /// ── Budget period ──────────────────────────────────────────────────────────
  /// Current daily budget. nil if no budget configured for this user.
  /// Resets at midnight UTC (see issue #136 for timezone support).
  @$pb.TagNumber(1)
  $7.UserBudget get budget => $_getN(0);
  @$pb.TagNumber(1)
  set budget($7.UserBudget v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBudget() => $_has(0);
  @$pb.TagNumber(1)
  void clearBudget() => $_clearField(1);
  @$pb.TagNumber(1)
  $7.UserBudget ensureBudget() => $_ensure(0);

  /// ── Active grants ──────────────────────────────────────────────────────────
  /// Grants are overflow: consumed after the daily budget is exhausted
  /// (budget-first waterfall). Ordered earliest-expiry-first so the UI can
  /// highlight which grant drains next.
  /// Per-grant remaining: grant.amount_usd - grant.spent_usd (compute client-side).
  @$pb.TagNumber(2)
  $pb.PbList<$7.BudgetGrant> get activeGrants => $_getList(1);

  /// ── Totals ─────────────────────────────────────────────────────────────────
  /// Identical to CheckBudget.RemainingUSD — what the proxy enforces.
  /// What the developer sees == what the gate uses for block/allow decisions.
  @$pb.TagNumber(3)
  $core.double get totalRemainingUsd => $_getN(2);
  @$pb.TagNumber(3)
  set totalRemainingUsd($core.double v) {
    $_setDouble(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTotalRemainingUsd() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalRemainingUsd() => $_clearField(3);

  /// ── Derived per-pool remaining (saves client subtraction) ──────────────────
  /// budget.limit_usd - budget.spent_usd, clamped to >= 0.
  @$pb.TagNumber(4)
  $core.double get budgetRemainingUsd => $_getN(3);
  @$pb.TagNumber(4)
  set budgetRemainingUsd($core.double v) {
    $_setDouble(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasBudgetRemainingUsd() => $_has(3);
  @$pb.TagNumber(4)
  void clearBudgetRemainingUsd() => $_clearField(4);

  /// Sum of (amount_usd - spent_usd) across all active grants.
  @$pb.TagNumber(5)
  $core.double get grantsRemainingUsd => $_getN(4);
  @$pb.TagNumber(5)
  set grantsRemainingUsd($core.double v) {
    $_setDouble(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasGrantsRemainingUsd() => $_has(4);
  @$pb.TagNumber(5)
  void clearGrantsRemainingUsd() => $_clearField(5);

  /// ── Today's token picture (Firestore fast path) ────────────────────────────
  /// Total tokens used today across ALL calls, regardless of whether cost was
  /// absorbed by the budget or a grant (all_tokens_used counter).
  /// For the accurate input/output split, call DashboardService.GetMyUsage.
  @$pb.TagNumber(10)
  $fixnum.Int64 get tokensUsedToday => $_getI64(5);
  @$pb.TagNumber(10)
  set tokensUsedToday($fixnum.Int64 v) {
    $_setInt64(5, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasTokensUsedToday() => $_has(5);
  @$pb.TagNumber(10)
  void clearTokensUsedToday() => $_clearField(10);

  /// ── Period metadata ────────────────────────────────────────────────────────
  /// UTC date key for the current budget period, e.g. "2026-05-09".
  @$pb.TagNumber(20)
  $core.String get periodKey => $_getSZ(6);
  @$pb.TagNumber(20)
  set periodKey($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasPeriodKey() => $_has(6);
  @$pb.TagNumber(20)
  void clearPeriodKey() => $_clearField(20);

  /// ISO 8601 timestamp of the next budget reset (midnight UTC).
  /// e.g. "2026-05-10T00:00:00Z". Client converts to local time for display.
  @$pb.TagNumber(21)
  $core.String get periodResetsAt => $_getSZ(7);
  @$pb.TagNumber(21)
  set periodResetsAt($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasPeriodResetsAt() => $_has(7);
  @$pb.TagNumber(21)
  void clearPeriodResetsAt() => $_clearField(21);
}

/// UserService manages users, budgets, and grants.
class UserServiceApi {
  $pb.RpcClient _client;
  UserServiceApi(this._client);

  /// CreateUser pre-provisions a user by email (optionally with an initial budget).
  $async.Future<CreateUserResponse> createUser(
          $pb.ClientContext? ctx, CreateUserRequest request) =>
      _client.invoke<CreateUserResponse>(
          ctx, 'UserService', 'CreateUser', request, CreateUserResponse());

  /// ListUsers returns all users with pagination.
  $async.Future<ListUsersResponse> listUsers(
          $pb.ClientContext? ctx, ListUsersRequest request) =>
      _client.invoke<ListUsersResponse>(
          ctx, 'UserService', 'ListUsers', request, ListUsersResponse());

  /// GetUser returns a user with their budget and active grants.
  $async.Future<GetUserResponse> getUser(
          $pb.ClientContext? ctx, GetUserRequest request) =>
      _client.invoke<GetUserResponse>(
          ctx, 'UserService', 'GetUser', request, GetUserResponse());

  /// UpdateUser modifies a user's display name or role.
  $async.Future<UpdateUserResponse> updateUser(
          $pb.ClientContext? ctx, UpdateUserRequest request) =>
      _client.invoke<UpdateUserResponse>(
          ctx, 'UserService', 'UpdateUser', request, UpdateUserResponse());

  /// DeactivateUser disables a user's access (sets status to INACTIVE).
  $async.Future<DeactivateUserResponse> deactivateUser(
          $pb.ClientContext? ctx, DeactivateUserRequest request) =>
      _client.invoke<DeactivateUserResponse>(ctx, 'UserService',
          'DeactivateUser', request, DeactivateUserResponse());

  /// ReactivateUser re-enables a previously deactivated user.
  $async.Future<ReactivateUserResponse> reactivateUser(
          $pb.ClientContext? ctx, ReactivateUserRequest request) =>
      _client.invoke<ReactivateUserResponse>(ctx, 'UserService',
          'ReactivateUser', request, ReactivateUserResponse());

  /// DeleteUser permanently removes an inactive user and all associated data.
  /// Only inactive users can be deleted (enforced server-side).
  $async.Future<DeleteUserResponse> deleteUser(
          $pb.ClientContext? ctx, DeleteUserRequest request) =>
      _client.invoke<DeleteUserResponse>(
          ctx, 'UserService', 'DeleteUser', request, DeleteUserResponse());

  /// SetBudget configures a user's recurring budget.
  $async.Future<SetBudgetResponse> setBudget(
          $pb.ClientContext? ctx, SetBudgetRequest request) =>
      _client.invoke<SetBudgetResponse>(
          ctx, 'UserService', 'SetBudget', request, SetBudgetResponse());

  /// GetBudget returns a user's current budget for the active period.
  $async.Future<GetBudgetResponse> getBudget(
          $pb.ClientContext? ctx, GetBudgetRequest request) =>
      _client.invoke<GetBudgetResponse>(
          ctx, 'UserService', 'GetBudget', request, GetBudgetResponse());

  /// ResetSpend zeroes a user's current-period spend (emergency override).
  $async.Future<ResetSpendResponse> resetSpend(
          $pb.ClientContext? ctx, ResetSpendRequest request) =>
      _client.invoke<ResetSpendResponse>(
          ctx, 'UserService', 'ResetSpend', request, ResetSpendResponse());

  /// CreateGrant issues a one-time bonus budget with an expiry window.
  $async.Future<CreateGrantResponse> createGrant(
          $pb.ClientContext? ctx, CreateGrantRequest request) =>
      _client.invoke<CreateGrantResponse>(
          ctx, 'UserService', 'CreateGrant', request, CreateGrantResponse());

  /// ListGrants returns all grants for a user (active and expired).
  $async.Future<ListGrantsResponse> listGrants(
          $pb.ClientContext? ctx, ListGrantsRequest request) =>
      _client.invoke<ListGrantsResponse>(
          ctx, 'UserService', 'ListGrants', request, ListGrantsResponse());

  /// RevokeGrant cancels an active grant.
  $async.Future<RevokeGrantResponse> revokeGrant(
          $pb.ClientContext? ctx, RevokeGrantRequest request) =>
      _client.invoke<RevokeGrantResponse>(
          ctx, 'UserService', 'RevokeGrant', request, RevokeGrantResponse());

  /// ListAuditLog returns the audit trail for a user.
  $async.Future<ListAuditLogResponse> listAuditLog(
          $pb.ClientContext? ctx, ListAuditLogRequest request) =>
      _client.invoke<ListAuditLogResponse>(
          ctx, 'UserService', 'ListAuditLog', request, ListAuditLogResponse());

  /// GetCurrentUser returns the authenticated user's profile, budget, and grants.
  $async.Future<GetCurrentUserResponse> getCurrentUser(
          $pb.ClientContext? ctx, GetCurrentUserRequest request) =>
      _client.invoke<GetCurrentUserResponse>(ctx, 'UserService',
          'GetCurrentUser', request, GetCurrentUserResponse());

  /// GetMyBudget returns just the budget summary for the authenticated user.
  $async.Future<GetMyBudgetResponse> getMyBudget(
          $pb.ClientContext? ctx, GetMyBudgetRequest request) =>
      _client.invoke<GetMyBudgetResponse>(
          ctx, 'UserService', 'GetMyBudget', request, GetMyBudgetResponse());
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
