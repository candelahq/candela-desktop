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

  /// GetUsageSummary returns aggregated token usage, cost, and request counts.
  static const getUsageSummary = connect.Spec(
    '/$name/GetUsageSummary',
    connect.StreamType.unary,
    candelav1dashboard_service.GetUsageSummaryRequest.new,
    candelav1dashboard_service.GetUsageSummaryResponse.new,
  );

  /// GetModelBreakdown returns usage broken down by model.
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

  /// GetMyUsage returns the calling user's personal usage summary (BigQuery).
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
