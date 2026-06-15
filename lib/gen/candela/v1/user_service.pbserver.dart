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

import 'user_service.pb.dart' as $17;
import 'user_service.pbjson.dart';

export 'user_service.pb.dart';

abstract class UserServiceBase extends $pb.GeneratedService {
  $async.Future<$17.CreateUserResponse> createUser(
      $pb.ServerContext ctx, $17.CreateUserRequest request);
  $async.Future<$17.ListUsersResponse> listUsers(
      $pb.ServerContext ctx, $17.ListUsersRequest request);
  $async.Future<$17.GetUserResponse> getUser(
      $pb.ServerContext ctx, $17.GetUserRequest request);
  $async.Future<$17.UpdateUserResponse> updateUser(
      $pb.ServerContext ctx, $17.UpdateUserRequest request);
  $async.Future<$17.DeactivateUserResponse> deactivateUser(
      $pb.ServerContext ctx, $17.DeactivateUserRequest request);
  $async.Future<$17.ReactivateUserResponse> reactivateUser(
      $pb.ServerContext ctx, $17.ReactivateUserRequest request);
  $async.Future<$17.DeleteUserResponse> deleteUser(
      $pb.ServerContext ctx, $17.DeleteUserRequest request);
  $async.Future<$17.SetBudgetResponse> setBudget(
      $pb.ServerContext ctx, $17.SetBudgetRequest request);
  $async.Future<$17.GetBudgetResponse> getBudget(
      $pb.ServerContext ctx, $17.GetBudgetRequest request);
  $async.Future<$17.ResetSpendResponse> resetSpend(
      $pb.ServerContext ctx, $17.ResetSpendRequest request);
  $async.Future<$17.CreateGrantResponse> createGrant(
      $pb.ServerContext ctx, $17.CreateGrantRequest request);
  $async.Future<$17.ListGrantsResponse> listGrants(
      $pb.ServerContext ctx, $17.ListGrantsRequest request);
  $async.Future<$17.RevokeGrantResponse> revokeGrant(
      $pb.ServerContext ctx, $17.RevokeGrantRequest request);
  $async.Future<$17.ListAuditLogResponse> listAuditLog(
      $pb.ServerContext ctx, $17.ListAuditLogRequest request);
  $async.Future<$17.GetCurrentUserResponse> getCurrentUser(
      $pb.ServerContext ctx, $17.GetCurrentUserRequest request);
  $async.Future<$17.GetMyBudgetResponse> getMyBudget(
      $pb.ServerContext ctx, $17.GetMyBudgetRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateUser':
        return $17.CreateUserRequest();
      case 'ListUsers':
        return $17.ListUsersRequest();
      case 'GetUser':
        return $17.GetUserRequest();
      case 'UpdateUser':
        return $17.UpdateUserRequest();
      case 'DeactivateUser':
        return $17.DeactivateUserRequest();
      case 'ReactivateUser':
        return $17.ReactivateUserRequest();
      case 'DeleteUser':
        return $17.DeleteUserRequest();
      case 'SetBudget':
        return $17.SetBudgetRequest();
      case 'GetBudget':
        return $17.GetBudgetRequest();
      case 'ResetSpend':
        return $17.ResetSpendRequest();
      case 'CreateGrant':
        return $17.CreateGrantRequest();
      case 'ListGrants':
        return $17.ListGrantsRequest();
      case 'RevokeGrant':
        return $17.RevokeGrantRequest();
      case 'ListAuditLog':
        return $17.ListAuditLogRequest();
      case 'GetCurrentUser':
        return $17.GetCurrentUserRequest();
      case 'GetMyBudget':
        return $17.GetMyBudgetRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateUser':
        return this.createUser(ctx, request as $17.CreateUserRequest);
      case 'ListUsers':
        return this.listUsers(ctx, request as $17.ListUsersRequest);
      case 'GetUser':
        return this.getUser(ctx, request as $17.GetUserRequest);
      case 'UpdateUser':
        return this.updateUser(ctx, request as $17.UpdateUserRequest);
      case 'DeactivateUser':
        return this.deactivateUser(ctx, request as $17.DeactivateUserRequest);
      case 'ReactivateUser':
        return this.reactivateUser(ctx, request as $17.ReactivateUserRequest);
      case 'DeleteUser':
        return this.deleteUser(ctx, request as $17.DeleteUserRequest);
      case 'SetBudget':
        return this.setBudget(ctx, request as $17.SetBudgetRequest);
      case 'GetBudget':
        return this.getBudget(ctx, request as $17.GetBudgetRequest);
      case 'ResetSpend':
        return this.resetSpend(ctx, request as $17.ResetSpendRequest);
      case 'CreateGrant':
        return this.createGrant(ctx, request as $17.CreateGrantRequest);
      case 'ListGrants':
        return this.listGrants(ctx, request as $17.ListGrantsRequest);
      case 'RevokeGrant':
        return this.revokeGrant(ctx, request as $17.RevokeGrantRequest);
      case 'ListAuditLog':
        return this.listAuditLog(ctx, request as $17.ListAuditLogRequest);
      case 'GetCurrentUser':
        return this.getCurrentUser(ctx, request as $17.GetCurrentUserRequest);
      case 'GetMyBudget':
        return this.getMyBudget(ctx, request as $17.GetMyBudgetRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => UserServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => UserServiceBase$messageJson;
}
