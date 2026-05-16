//
//  Generated code. Do not modify.
//  source: candela/v1/dashboard_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "dashboard_service.pb.dart" as candelav1dashboard_service;
import "dashboard_service.connect.spec.dart" as specs;

/// DashboardService provides aggregated metrics and usage data.
/// Exposed via ConnectRPC for the web UI dashboards.
extension type DashboardServiceClient(connect.Transport _transport) {
  /// GetUsageSummary returns aggregated token usage, cost, and request counts.
  Future<candelav1dashboard_service.GetUsageSummaryResponse> getUsageSummary(
    candelav1dashboard_service.GetUsageSummaryRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.getUsageSummary,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetModelBreakdown returns usage broken down by model.
  Future<candelav1dashboard_service.GetModelBreakdownResponse>
      getModelBreakdown(
    candelav1dashboard_service.GetModelBreakdownRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.getModelBreakdown,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetLatencyPercentiles returns latency distribution data.
  Future<candelav1dashboard_service.GetLatencyPercentilesResponse>
      getLatencyPercentiles(
    candelav1dashboard_service.GetLatencyPercentilesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.getLatencyPercentiles,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetMyUsage returns the calling user's personal usage summary (BigQuery).
  /// For real-time budget/grant progress, see UserService.GetMyBudget.
  Future<candelav1dashboard_service.GetMyUsageResponse> getMyUsage(
    candelav1dashboard_service.GetMyUsageRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.getMyUsage,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetTeamLeaderboard returns per-user usage for the team (admin only).
  Future<candelav1dashboard_service.GetTeamLeaderboardResponse>
      getTeamLeaderboard(
    candelav1dashboard_service.GetTeamLeaderboardRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.getTeamLeaderboard,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetJobLeaderboard returns per-job usage for cost attribution.
  Future<candelav1dashboard_service.GetJobLeaderboardResponse>
      getJobLeaderboard(
    candelav1dashboard_service.GetJobLeaderboardRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.getJobLeaderboard,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
