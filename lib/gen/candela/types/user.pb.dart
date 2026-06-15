//
//  Generated code. Do not modify.
//  source: candela/types/user.proto
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
import 'user.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'user.pbenum.dart';

/// User represents a developer or admin in the Candela platform.
/// Firestore path: users/{id}
class User extends $pb.GeneratedMessage {
  factory User({
    $core.String? id,
    $core.String? email,
    $core.String? displayName,
    UserRole? role,
    UserStatus? status,
    $2.Timestamp? createdAt,
    $2.Timestamp? lastSeenAt,
    $core.int? rateLimit,
    $2.Timestamp? lastActiveAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (email != null) {
      $result.email = email;
    }
    if (displayName != null) {
      $result.displayName = displayName;
    }
    if (role != null) {
      $result.role = role;
    }
    if (status != null) {
      $result.status = status;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (lastSeenAt != null) {
      $result.lastSeenAt = lastSeenAt;
    }
    if (rateLimit != null) {
      $result.rateLimit = rateLimit;
    }
    if (lastActiveAt != null) {
      $result.lastActiveAt = lastActiveAt;
    }
    return $result;
  }
  User._() : super();
  factory User.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'User',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..e<UserRole>(4, _omitFieldNames ? '' : 'role', $pb.PbFieldType.OE,
        defaultOrMaker: UserRole.USER_ROLE_UNSPECIFIED,
        valueOf: UserRole.valueOf,
        enumValues: UserRole.values)
    ..e<UserStatus>(5, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: UserStatus.USER_STATUS_UNSPECIFIED,
        valueOf: UserStatus.valueOf,
        enumValues: UserStatus.values)
    ..aOM<$2.Timestamp>(6, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'lastSeenAt',
        subBuilder: $2.Timestamp.create)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'rateLimit', $pb.PbFieldType.O3)
    ..aOM<$2.Timestamp>(9, _omitFieldNames ? '' : 'lastActiveAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User copyWith(void Function(User) updates) =>
      super.copyWith((message) => updates(message as User)) as User;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

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
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

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

  @$pb.TagNumber(4)
  UserRole get role => $_getN(3);
  @$pb.TagNumber(4)
  set role(UserRole v) {
    $_setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => $_clearField(4);

  @$pb.TagNumber(5)
  UserStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(UserStatus v) {
    $_setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($2.Timestamp v) {
    $_setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $2.Timestamp get lastSeenAt => $_getN(6);
  @$pb.TagNumber(7)
  set lastSeenAt($2.Timestamp v) {
    $_setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasLastSeenAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearLastSeenAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensureLastSeenAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.int get rateLimit => $_getIZ(7);
  @$pb.TagNumber(8)
  set rateLimit($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasRateLimit() => $_has(7);
  @$pb.TagNumber(8)
  void clearRateLimit() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.Timestamp get lastActiveAt => $_getN(8);
  @$pb.TagNumber(9)
  set lastActiveAt($2.Timestamp v) {
    $_setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasLastActiveAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastActiveAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Timestamp ensureLastActiveAt() => $_ensure(8);
}

/// UserBudget tracks a user's recurring spend for a budget period.
/// Firestore path: users/{user_id}/budgets/{period_key}
class UserBudget extends $pb.GeneratedMessage {
  factory UserBudget({
    $core.String? userId,
    $core.double? limitUsd,
    $core.double? spentUsd,
    $fixnum.Int64? tokensUsed,
    BudgetPeriod? periodType,
    $core.String? periodKey,
    $2.Timestamp? periodStart,
    $2.Timestamp? periodEnd,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (limitUsd != null) {
      $result.limitUsd = limitUsd;
    }
    if (spentUsd != null) {
      $result.spentUsd = spentUsd;
    }
    if (tokensUsed != null) {
      $result.tokensUsed = tokensUsed;
    }
    if (periodType != null) {
      $result.periodType = periodType;
    }
    if (periodKey != null) {
      $result.periodKey = periodKey;
    }
    if (periodStart != null) {
      $result.periodStart = periodStart;
    }
    if (periodEnd != null) {
      $result.periodEnd = periodEnd;
    }
    return $result;
  }
  UserBudget._() : super();
  factory UserBudget.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UserBudget.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserBudget',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'limitUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'spentUsd', $pb.PbFieldType.OD)
    ..aInt64(4, _omitFieldNames ? '' : 'tokensUsed')
    ..e<BudgetPeriod>(
        5, _omitFieldNames ? '' : 'periodType', $pb.PbFieldType.OE,
        defaultOrMaker: BudgetPeriod.BUDGET_PERIOD_UNSPECIFIED,
        valueOf: BudgetPeriod.valueOf,
        enumValues: BudgetPeriod.values)
    ..aOS(6, _omitFieldNames ? '' : 'periodKey')
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'periodStart',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'periodEnd',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserBudget clone() => UserBudget()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserBudget copyWith(void Function(UserBudget) updates) =>
      super.copyWith((message) => updates(message as UserBudget)) as UserBudget;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserBudget create() => UserBudget._();
  UserBudget createEmptyInstance() => create();
  static $pb.PbList<UserBudget> createRepeated() => $pb.PbList<UserBudget>();
  @$core.pragma('dart2js:noInline')
  static UserBudget getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserBudget>(create);
  static UserBudget? _defaultInstance;

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
  $core.double get spentUsd => $_getN(2);
  @$pb.TagNumber(3)
  set spentUsd($core.double v) {
    $_setDouble(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSpentUsd() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpentUsd() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get tokensUsed => $_getI64(3);
  @$pb.TagNumber(4)
  set tokensUsed($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTokensUsed() => $_has(3);
  @$pb.TagNumber(4)
  void clearTokensUsed() => $_clearField(4);

  @$pb.TagNumber(5)
  BudgetPeriod get periodType => $_getN(4);
  @$pb.TagNumber(5)
  set periodType(BudgetPeriod v) {
    $_setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPeriodType() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get periodKey => $_getSZ(5);
  @$pb.TagNumber(6)
  set periodKey($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPeriodKey() => $_has(5);
  @$pb.TagNumber(6)
  void clearPeriodKey() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.Timestamp get periodStart => $_getN(6);
  @$pb.TagNumber(7)
  set periodStart($2.Timestamp v) {
    $_setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasPeriodStart() => $_has(6);
  @$pb.TagNumber(7)
  void clearPeriodStart() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensurePeriodStart() => $_ensure(6);

  @$pb.TagNumber(8)
  $2.Timestamp get periodEnd => $_getN(7);
  @$pb.TagNumber(8)
  set periodEnd($2.Timestamp v) {
    $_setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasPeriodEnd() => $_has(7);
  @$pb.TagNumber(8)
  void clearPeriodEnd() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensurePeriodEnd() => $_ensure(7);
}

/// BudgetGrant is a one-time bonus budget with an expiry window.
/// Consumed AFTER the recurring budget (budget-first waterfall).
/// When the daily budget is exhausted, grants absorb the overflow.
/// Multiple grants are consumed earliest-expiry-first to minimise waste.
/// Firestore path: users/{user_id}/grants/{id}
class BudgetGrant extends $pb.GeneratedMessage {
  factory BudgetGrant({
    $core.String? id,
    $core.String? userId,
    $core.double? amountUsd,
    $core.double? spentUsd,
    $core.String? reason,
    $core.String? grantedBy,
    $2.Timestamp? startsAt,
    $2.Timestamp? expiresAt,
    $2.Timestamp? createdAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (userId != null) {
      $result.userId = userId;
    }
    if (amountUsd != null) {
      $result.amountUsd = amountUsd;
    }
    if (spentUsd != null) {
      $result.spentUsd = spentUsd;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    if (grantedBy != null) {
      $result.grantedBy = grantedBy;
    }
    if (startsAt != null) {
      $result.startsAt = startsAt;
    }
    if (expiresAt != null) {
      $result.expiresAt = expiresAt;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  BudgetGrant._() : super();
  factory BudgetGrant.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BudgetGrant.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BudgetGrant',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'amountUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'spentUsd', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOS(6, _omitFieldNames ? '' : 'grantedBy')
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BudgetGrant clone() => BudgetGrant()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BudgetGrant copyWith(void Function(BudgetGrant) updates) =>
      super.copyWith((message) => updates(message as BudgetGrant))
          as BudgetGrant;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BudgetGrant create() => BudgetGrant._();
  BudgetGrant createEmptyInstance() => create();
  static $pb.PbList<BudgetGrant> createRepeated() => $pb.PbList<BudgetGrant>();
  @$core.pragma('dart2js:noInline')
  static BudgetGrant getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BudgetGrant>(create);
  static BudgetGrant? _defaultInstance;

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
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get amountUsd => $_getN(2);
  @$pb.TagNumber(3)
  set amountUsd($core.double v) {
    $_setDouble(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAmountUsd() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmountUsd() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get spentUsd => $_getN(3);
  @$pb.TagNumber(4)
  set spentUsd($core.double v) {
    $_setDouble(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSpentUsd() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpentUsd() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get grantedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set grantedBy($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasGrantedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearGrantedBy() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.Timestamp get startsAt => $_getN(6);
  @$pb.TagNumber(7)
  set startsAt($2.Timestamp v) {
    $_setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasStartsAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartsAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensureStartsAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $2.Timestamp get expiresAt => $_getN(7);
  @$pb.TagNumber(8)
  set expiresAt($2.Timestamp v) {
    $_setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasExpiresAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpiresAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureExpiresAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $2.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($2.Timestamp v) {
    $_setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Timestamp ensureCreatedAt() => $_ensure(8);
}

/// AuditEntry records an admin action for accountability.
/// Firestore path: users/{user_id}/audit/{id}
class AuditEntry extends $pb.GeneratedMessage {
  factory AuditEntry({
    $core.String? id,
    $core.String? userId,
    $core.String? actorEmail,
    $core.String? action,
    $core.String? details,
    $2.Timestamp? timestamp,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (userId != null) {
      $result.userId = userId;
    }
    if (actorEmail != null) {
      $result.actorEmail = actorEmail;
    }
    if (action != null) {
      $result.action = action;
    }
    if (details != null) {
      $result.details = details;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    return $result;
  }
  AuditEntry._() : super();
  factory AuditEntry.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AuditEntry.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuditEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'actorEmail')
    ..aOS(4, _omitFieldNames ? '' : 'action')
    ..aOS(5, _omitFieldNames ? '' : 'details')
    ..aOM<$2.Timestamp>(6, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuditEntry clone() => AuditEntry()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuditEntry copyWith(void Function(AuditEntry) updates) =>
      super.copyWith((message) => updates(message as AuditEntry)) as AuditEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuditEntry create() => AuditEntry._();
  AuditEntry createEmptyInstance() => create();
  static $pb.PbList<AuditEntry> createRepeated() => $pb.PbList<AuditEntry>();
  @$core.pragma('dart2js:noInline')
  static AuditEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuditEntry>(create);
  static AuditEntry? _defaultInstance;

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
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get actorEmail => $_getSZ(2);
  @$pb.TagNumber(3)
  set actorEmail($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasActorEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearActorEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get action => $_getSZ(3);
  @$pb.TagNumber(4)
  set action($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get details => $_getSZ(4);
  @$pb.TagNumber(5)
  set details($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDetails() => $_has(4);
  @$pb.TagNumber(5)
  void clearDetails() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Timestamp get timestamp => $_getN(5);
  @$pb.TagNumber(6)
  set timestamp($2.Timestamp v) {
    $_setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasTimestamp() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimestamp() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureTimestamp() => $_ensure(5);
}

/// RateWindow tracks per-minute request counts for rate limiting.
/// Firestore path: rate_limit/{user_id}:{window_key}
/// TTL: auto-expires after 2 minutes.
class RateWindow extends $pb.GeneratedMessage {
  factory RateWindow({
    $core.String? userId,
    $core.int? requestCount,
    $core.int? limit,
    $core.String? windowKey,
    $2.Timestamp? expireAt,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (requestCount != null) {
      $result.requestCount = requestCount;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    if (windowKey != null) {
      $result.windowKey = windowKey;
    }
    if (expireAt != null) {
      $result.expireAt = expireAt;
    }
    return $result;
  }
  RateWindow._() : super();
  factory RateWindow.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RateWindow.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateWindow',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'requestCount', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'windowKey')
    ..aOM<$2.Timestamp>(5, _omitFieldNames ? '' : 'expireAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateWindow clone() => RateWindow()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateWindow copyWith(void Function(RateWindow) updates) =>
      super.copyWith((message) => updates(message as RateWindow)) as RateWindow;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RateWindow create() => RateWindow._();
  RateWindow createEmptyInstance() => create();
  static $pb.PbList<RateWindow> createRepeated() => $pb.PbList<RateWindow>();
  @$core.pragma('dart2js:noInline')
  static RateWindow getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateWindow>(create);
  static RateWindow? _defaultInstance;

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
  $core.int get requestCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set requestCount($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRequestCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get windowKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set windowKey($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasWindowKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearWindowKey() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.Timestamp get expireAt => $_getN(4);
  @$pb.TagNumber(5)
  set expireAt($2.Timestamp v) {
    $_setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasExpireAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpireAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Timestamp ensureExpireAt() => $_ensure(4);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
