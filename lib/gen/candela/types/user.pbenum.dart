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

import 'package:protobuf/protobuf.dart' as $pb;

/// UserRole defines the access level of a user.
class UserRole extends $pb.ProtobufEnum {
  static const UserRole USER_ROLE_UNSPECIFIED =
      UserRole._(0, _omitEnumNames ? '' : 'USER_ROLE_UNSPECIFIED');
  static const UserRole USER_ROLE_DEVELOPER =
      UserRole._(1, _omitEnumNames ? '' : 'USER_ROLE_DEVELOPER');
  static const UserRole USER_ROLE_ADMIN =
      UserRole._(2, _omitEnumNames ? '' : 'USER_ROLE_ADMIN');

  static const $core.List<UserRole> values = <UserRole>[
    USER_ROLE_UNSPECIFIED,
    USER_ROLE_DEVELOPER,
    USER_ROLE_ADMIN,
  ];

  static final $core.List<UserRole?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static UserRole? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UserRole._(super.v, super.n);
}

/// UserScope determines the data visibility scope.
class UserScope extends $pb.ProtobufEnum {
  static const UserScope USER_SCOPE_UNSPECIFIED =
      UserScope._(0, _omitEnumNames ? '' : 'USER_SCOPE_UNSPECIFIED');
  static const UserScope USER_SCOPE_PERSONAL =
      UserScope._(1, _omitEnumNames ? '' : 'USER_SCOPE_PERSONAL');
  static const UserScope USER_SCOPE_GLOBAL =
      UserScope._(2, _omitEnumNames ? '' : 'USER_SCOPE_GLOBAL');

  static const $core.List<UserScope> values = <UserScope>[
    USER_SCOPE_UNSPECIFIED,
    USER_SCOPE_PERSONAL,
    USER_SCOPE_GLOBAL,
  ];

  static final $core.List<UserScope?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static UserScope? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UserScope._(super.v, super.n);
}

/// UserStatus tracks the lifecycle of a user account.
class UserStatus extends $pb.ProtobufEnum {
  static const UserStatus USER_STATUS_UNSPECIFIED =
      UserStatus._(0, _omitEnumNames ? '' : 'USER_STATUS_UNSPECIFIED');
  static const UserStatus USER_STATUS_PROVISIONED =
      UserStatus._(1, _omitEnumNames ? '' : 'USER_STATUS_PROVISIONED');
  static const UserStatus USER_STATUS_ACTIVE =
      UserStatus._(2, _omitEnumNames ? '' : 'USER_STATUS_ACTIVE');
  static const UserStatus USER_STATUS_INACTIVE =
      UserStatus._(3, _omitEnumNames ? '' : 'USER_STATUS_INACTIVE');

  static const $core.List<UserStatus> values = <UserStatus>[
    USER_STATUS_UNSPECIFIED,
    USER_STATUS_PROVISIONED,
    USER_STATUS_ACTIVE,
    USER_STATUS_INACTIVE,
  ];

  static final $core.List<UserStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static UserStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UserStatus._(super.v, super.n);
}

/// BudgetPeriod defines the recurrence interval for a budget.
/// Currently only daily budgets are supported.
class BudgetPeriod extends $pb.ProtobufEnum {
  static const BudgetPeriod BUDGET_PERIOD_UNSPECIFIED =
      BudgetPeriod._(0, _omitEnumNames ? '' : 'BUDGET_PERIOD_UNSPECIFIED');
  static const BudgetPeriod BUDGET_PERIOD_DAILY =
      BudgetPeriod._(1, _omitEnumNames ? '' : 'BUDGET_PERIOD_DAILY');

  static const $core.List<BudgetPeriod> values = <BudgetPeriod>[
    BUDGET_PERIOD_UNSPECIFIED,
    BUDGET_PERIOD_DAILY,
  ];

  static final $core.List<BudgetPeriod?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static BudgetPeriod? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BudgetPeriod._(super.v, super.n);
}

const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
