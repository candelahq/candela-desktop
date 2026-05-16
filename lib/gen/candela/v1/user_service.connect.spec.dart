//
//  Generated code. Do not modify.
//  source: candela/v1/user_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "user_service.pb.dart" as candelav1user_service;

/// UserService manages users, budgets, and grants.
/// ── Admin endpoints ──
abstract final class UserService {
  /// Fully-qualified name of the UserService service.
  static const name = 'candela.v1.UserService';

  /// CreateUser pre-provisions a user by email (optionally with an initial budget).
  static const createUser = connect.Spec(
    '/$name/CreateUser',
    connect.StreamType.unary,
    candelav1user_service.CreateUserRequest.new,
    candelav1user_service.CreateUserResponse.new,
  );

  /// ListUsers returns all users with pagination.
  static const listUsers = connect.Spec(
    '/$name/ListUsers',
    connect.StreamType.unary,
    candelav1user_service.ListUsersRequest.new,
    candelav1user_service.ListUsersResponse.new,
  );

  /// GetUser returns a user with their budget and active grants.
  static const getUser = connect.Spec(
    '/$name/GetUser',
    connect.StreamType.unary,
    candelav1user_service.GetUserRequest.new,
    candelav1user_service.GetUserResponse.new,
  );

  /// UpdateUser modifies a user's display name or role.
  static const updateUser = connect.Spec(
    '/$name/UpdateUser',
    connect.StreamType.unary,
    candelav1user_service.UpdateUserRequest.new,
    candelav1user_service.UpdateUserResponse.new,
  );

  /// DeactivateUser disables a user's access (sets status to INACTIVE).
  static const deactivateUser = connect.Spec(
    '/$name/DeactivateUser',
    connect.StreamType.unary,
    candelav1user_service.DeactivateUserRequest.new,
    candelav1user_service.DeactivateUserResponse.new,
  );

  /// ReactivateUser re-enables a previously deactivated user.
  static const reactivateUser = connect.Spec(
    '/$name/ReactivateUser',
    connect.StreamType.unary,
    candelav1user_service.ReactivateUserRequest.new,
    candelav1user_service.ReactivateUserResponse.new,
  );

  /// DeleteUser permanently removes an inactive user and all associated data.
  /// Only inactive users can be deleted (enforced server-side).
  static const deleteUser = connect.Spec(
    '/$name/DeleteUser',
    connect.StreamType.unary,
    candelav1user_service.DeleteUserRequest.new,
    candelav1user_service.DeleteUserResponse.new,
  );

  /// SetBudget configures a user's recurring budget.
  static const setBudget = connect.Spec(
    '/$name/SetBudget',
    connect.StreamType.unary,
    candelav1user_service.SetBudgetRequest.new,
    candelav1user_service.SetBudgetResponse.new,
  );

  /// GetBudget returns a user's current budget for the active period.
  static const getBudget = connect.Spec(
    '/$name/GetBudget',
    connect.StreamType.unary,
    candelav1user_service.GetBudgetRequest.new,
    candelav1user_service.GetBudgetResponse.new,
  );

  /// ResetSpend zeroes a user's current-period spend (emergency override).
  static const resetSpend = connect.Spec(
    '/$name/ResetSpend',
    connect.StreamType.unary,
    candelav1user_service.ResetSpendRequest.new,
    candelav1user_service.ResetSpendResponse.new,
  );

  /// CreateGrant issues a one-time bonus budget with an expiry window.
  static const createGrant = connect.Spec(
    '/$name/CreateGrant',
    connect.StreamType.unary,
    candelav1user_service.CreateGrantRequest.new,
    candelav1user_service.CreateGrantResponse.new,
  );

  /// ListGrants returns all grants for a user (active and expired).
  static const listGrants = connect.Spec(
    '/$name/ListGrants',
    connect.StreamType.unary,
    candelav1user_service.ListGrantsRequest.new,
    candelav1user_service.ListGrantsResponse.new,
  );

  /// RevokeGrant cancels an active grant.
  static const revokeGrant = connect.Spec(
    '/$name/RevokeGrant',
    connect.StreamType.unary,
    candelav1user_service.RevokeGrantRequest.new,
    candelav1user_service.RevokeGrantResponse.new,
  );

  /// ListAuditLog returns the audit trail for a user.
  static const listAuditLog = connect.Spec(
    '/$name/ListAuditLog',
    connect.StreamType.unary,
    candelav1user_service.ListAuditLogRequest.new,
    candelav1user_service.ListAuditLogResponse.new,
  );

  /// GetCurrentUser returns the authenticated user's profile, budget, and grants.
  static const getCurrentUser = connect.Spec(
    '/$name/GetCurrentUser',
    connect.StreamType.unary,
    candelav1user_service.GetCurrentUserRequest.new,
    candelav1user_service.GetCurrentUserResponse.new,
  );

  /// GetMyBudget returns just the budget summary for the authenticated user.
  static const getMyBudget = connect.Spec(
    '/$name/GetMyBudget',
    connect.StreamType.unary,
    candelav1user_service.GetMyBudgetRequest.new,
    candelav1user_service.GetMyBudgetResponse.new,
  );
}
