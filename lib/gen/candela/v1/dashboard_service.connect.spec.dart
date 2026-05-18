//
//  Generated code. Do not modify.
//  source: candela/v1/dashboard_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "dashboard_service.pb.dart" as candelav1dashboard_service;

/// DashboardService provides aggregated metrics and usage data.
/// Exposed via ConnectRPC for the web UI dashboards.
abstract final class DashboardService {
  /// Fully-qualified name of the DashboardService service.
  static const name = 'candela.v1.DashboardService';

  /// GetDashboardData returns a consolidated dashboard view including usage
  /// summary, per-model breakdown, and (if authenticated) per-user budget
  /// context. Replaces the concurrent fan-out of GetUsageSummary +
  /// GetModelBreakdown + GetMyUsage with a single round-trip.
  static const getDashboardData = connect.Spec(
    '/$name/GetDashboardData',
    connect.StreamType.unary,
    candelav1dashboard_service.GetDashboardDataRequest.new,
    candelav1dashboard_service.GetDashboardDataResponse.new,
  );

  /// Deprecated: use GetDashboardData instead.
  static const getUsageSummary = connect.Spec(
    '/$name/GetUsageSummary',
    connect.StreamType.unary,
    candelav1dashboard_service.GetUsageSummaryRequest.new,
    candelav1dashboard_service.GetUsageSummaryResponse.new,
  );

  /// Deprecated: use GetDashboardData instead.
  static const getModelBreakdown = connect.Spec(
    '/$name/GetModelBreakdown',
    connect.StreamType.unary,
    candelav1dashboard_service.GetModelBreakdownRequest.new,
    candelav1dashboard_service.GetModelBreakdownResponse.new,
  );

  /// GetLatencyPercentiles returns latency distribution data.
  static const getLatencyPercentiles = connect.Spec(
    '/$name/GetLatencyPercentiles',
    connect.StreamType.unary,
    candelav1dashboard_service.GetLatencyPercentilesRequest.new,
    candelav1dashboard_service.GetLatencyPercentilesResponse.new,
  );

  /// Deprecated: use GetDashboardData with include_budget=true instead.
  /// For real-time budget/grant progress, see UserService.GetMyBudget.
  static const getMyUsage = connect.Spec(
    '/$name/GetMyUsage',
    connect.StreamType.unary,
    candelav1dashboard_service.GetMyUsageRequest.new,
    candelav1dashboard_service.GetMyUsageResponse.new,
  );

  /// GetTeamLeaderboard returns per-user usage for the team (admin only).
  static const getTeamLeaderboard = connect.Spec(
    '/$name/GetTeamLeaderboard',
    connect.StreamType.unary,
    candelav1dashboard_service.GetTeamLeaderboardRequest.new,
    candelav1dashboard_service.GetTeamLeaderboardResponse.new,
  );

  /// GetJobLeaderboard returns per-job usage for cost attribution.
  static const getJobLeaderboard = connect.Spec(
    '/$name/GetJobLeaderboard',
    connect.StreamType.unary,
    candelav1dashboard_service.GetJobLeaderboardRequest.new,
    candelav1dashboard_service.GetJobLeaderboardResponse.new,
  );
}
