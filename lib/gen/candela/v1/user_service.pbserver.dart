//
//  Generated code. Do not modify.
//  source: candela/v1/user_service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'user_service.pb.dart' as $15;
import 'user_service.pbjson.dart';

export 'user_service.pb.dart';

abstract class UserServiceBase extends $pb.GeneratedService {
  $async.Future<$15.CreateUserResponse> createUser(
      $pb.ServerContext ctx, $15.CreateUserRequest request);
  $async.Future<$15.ListUsersResponse> listUsers(
      $pb.ServerContext ctx, $15.ListUsersRequest request);
  $async.Future<$15.GetUserResponse> getUser(
      $pb.ServerContext ctx, $15.GetUserRequest request);
  $async.Future<$15.UpdateUserResponse> updateUser(
      $pb.ServerContext ctx, $15.UpdateUserRequest request);
  $async.Future<$15.DeactivateUserResponse> deactivateUser(
      $pb.ServerContext ctx, $15.DeactivateUserRequest request);
  $async.Future<$15.ReactivateUserResponse> reactivateUser(
      $pb.ServerContext ctx, $15.ReactivateUserRequest request);
  $async.Future<$15.DeleteUserResponse> deleteUser(
      $pb.ServerContext ctx, $15.DeleteUserRequest request);
  $async.Future<$15.SetBudgetResponse> setBudget(
      $pb.ServerContext ctx, $15.SetBudgetRequest request);
  $async.Future<$15.GetBudgetResponse> getBudget(
      $pb.ServerContext ctx, $15.GetBudgetRequest request);
  $async.Future<$15.ResetSpendResponse> resetSpend(
      $pb.ServerContext ctx, $15.ResetSpendRequest request);
  $async.Future<$15.CreateGrantResponse> createGrant(
      $pb.ServerContext ctx, $15.CreateGrantRequest request);
  $async.Future<$15.ListGrantsResponse> listGrants(
      $pb.ServerContext ctx, $15.ListGrantsRequest request);
  $async.Future<$15.RevokeGrantResponse> revokeGrant(
      $pb.ServerContext ctx, $15.RevokeGrantRequest request);
  $async.Future<$15.ListAuditLogResponse> listAuditLog(
      $pb.ServerContext ctx, $15.ListAuditLogRequest request);
  $async.Future<$15.GetCurrentUserResponse> getCurrentUser(
      $pb.ServerContext ctx, $15.GetCurrentUserRequest request);
  $async.Future<$15.GetMyBudgetResponse> getMyBudget(
      $pb.ServerContext ctx, $15.GetMyBudgetRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateUser':
        return $15.CreateUserRequest();
      case 'ListUsers':
        return $15.ListUsersRequest();
      case 'GetUser':
        return $15.GetUserRequest();
      case 'UpdateUser':
        return $15.UpdateUserRequest();
      case 'DeactivateUser':
        return $15.DeactivateUserRequest();
      case 'ReactivateUser':
        return $15.ReactivateUserRequest();
      case 'DeleteUser':
        return $15.DeleteUserRequest();
      case 'SetBudget':
        return $15.SetBudgetRequest();
      case 'GetBudget':
        return $15.GetBudgetRequest();
      case 'ResetSpend':
        return $15.ResetSpendRequest();
      case 'CreateGrant':
        return $15.CreateGrantRequest();
      case 'ListGrants':
        return $15.ListGrantsRequest();
      case 'RevokeGrant':
        return $15.RevokeGrantRequest();
      case 'ListAuditLog':
        return $15.ListAuditLogRequest();
      case 'GetCurrentUser':
        return $15.GetCurrentUserRequest();
      case 'GetMyBudget':
        return $15.GetMyBudgetRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateUser':
        return this.createUser(ctx, request as $15.CreateUserRequest);
      case 'ListUsers':
        return this.listUsers(ctx, request as $15.ListUsersRequest);
      case 'GetUser':
        return this.getUser(ctx, request as $15.GetUserRequest);
      case 'UpdateUser':
        return this.updateUser(ctx, request as $15.UpdateUserRequest);
      case 'DeactivateUser':
        return this.deactivateUser(ctx, request as $15.DeactivateUserRequest);
      case 'ReactivateUser':
        return this.reactivateUser(ctx, request as $15.ReactivateUserRequest);
      case 'DeleteUser':
        return this.deleteUser(ctx, request as $15.DeleteUserRequest);
      case 'SetBudget':
        return this.setBudget(ctx, request as $15.SetBudgetRequest);
      case 'GetBudget':
        return this.getBudget(ctx, request as $15.GetBudgetRequest);
      case 'ResetSpend':
        return this.resetSpend(ctx, request as $15.ResetSpendRequest);
      case 'CreateGrant':
        return this.createGrant(ctx, request as $15.CreateGrantRequest);
      case 'ListGrants':
        return this.listGrants(ctx, request as $15.ListGrantsRequest);
      case 'RevokeGrant':
        return this.revokeGrant(ctx, request as $15.RevokeGrantRequest);
      case 'ListAuditLog':
        return this.listAuditLog(ctx, request as $15.ListAuditLogRequest);
      case 'GetCurrentUser':
        return this.getCurrentUser(ctx, request as $15.GetCurrentUserRequest);
      case 'GetMyBudget':
        return this.getMyBudget(ctx, request as $15.GetMyBudgetRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => UserServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => UserServiceBase$messageJson;
}
