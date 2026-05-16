//
//  Generated code. Do not modify.
//  source: candela/v1/user_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "user_service.pb.dart" as candelav1user_service;
import "user_service.connect.spec.dart" as specs;

/// UserService manages users, budgets, and grants.
/// ── Admin endpoints ──
extension type UserServiceClient(connect.Transport _transport) {
  /// CreateUser pre-provisions a user by email (optionally with an initial budget).
  Future<candelav1user_service.CreateUserResponse> createUser(
    candelav1user_service.CreateUserRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.createUser,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListUsers returns all users with pagination.
  Future<candelav1user_service.ListUsersResponse> listUsers(
    candelav1user_service.ListUsersRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.listUsers,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetUser returns a user with their budget and active grants.
  Future<candelav1user_service.GetUserResponse> getUser(
    candelav1user_service.GetUserRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.getUser,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UpdateUser modifies a user's display name or role.
  Future<candelav1user_service.UpdateUserResponse> updateUser(
    candelav1user_service.UpdateUserRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.updateUser,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeactivateUser disables a user's access (sets status to INACTIVE).
  Future<candelav1user_service.DeactivateUserResponse> deactivateUser(
    candelav1user_service.DeactivateUserRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.deactivateUser,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ReactivateUser re-enables a previously deactivated user.
  Future<candelav1user_service.ReactivateUserResponse> reactivateUser(
    candelav1user_service.ReactivateUserRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.reactivateUser,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeleteUser permanently removes an inactive user and all associated data.
  /// Only inactive users can be deleted (enforced server-side).
  Future<candelav1user_service.DeleteUserResponse> deleteUser(
    candelav1user_service.DeleteUserRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.deleteUser,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// SetBudget configures a user's recurring budget.
  Future<candelav1user_service.SetBudgetResponse> setBudget(
    candelav1user_service.SetBudgetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.setBudget,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetBudget returns a user's current budget for the active period.
  Future<candelav1user_service.GetBudgetResponse> getBudget(
    candelav1user_service.GetBudgetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.getBudget,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ResetSpend zeroes a user's current-period spend (emergency override).
  Future<candelav1user_service.ResetSpendResponse> resetSpend(
    candelav1user_service.ResetSpendRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.resetSpend,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CreateGrant issues a one-time bonus budget with an expiry window.
  Future<candelav1user_service.CreateGrantResponse> createGrant(
    candelav1user_service.CreateGrantRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.createGrant,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListGrants returns all grants for a user (active and expired).
  Future<candelav1user_service.ListGrantsResponse> listGrants(
    candelav1user_service.ListGrantsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.listGrants,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RevokeGrant cancels an active grant.
  Future<candelav1user_service.RevokeGrantResponse> revokeGrant(
    candelav1user_service.RevokeGrantRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.revokeGrant,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListAuditLog returns the audit trail for a user.
  Future<candelav1user_service.ListAuditLogResponse> listAuditLog(
    candelav1user_service.ListAuditLogRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.listAuditLog,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetCurrentUser returns the authenticated user's profile, budget, and grants.
  Future<candelav1user_service.GetCurrentUserResponse> getCurrentUser(
    candelav1user_service.GetCurrentUserRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.getCurrentUser,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetMyBudget returns just the budget summary for the authenticated user.
  Future<candelav1user_service.GetMyBudgetResponse> getMyBudget(
    candelav1user_service.GetMyBudgetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.getMyBudget,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
