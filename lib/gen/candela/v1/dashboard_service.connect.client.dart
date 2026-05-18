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
  /// GetDashboardData returns a consolidated dashboard view including usage
  /// summary, per-model breakdown, and (if authenticated) per-user budget
  /// context. Replaces the concurrent fan-out of GetUsageSummary +
  /// GetModelBreakdown + GetMyUsage with a single round-trip.
  Future<candelav1dashboard_service.GetDashboardDataResponse> getDashboardData(
    candelav1dashboard_service.GetDashboardDataRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.getDashboardData,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Deprecated: use GetDashboardData instead.
  @deprecated
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

  /// Deprecated: use GetDashboardData instead.
  @deprecated
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

  /// Deprecated: use GetDashboardData with include_budget=true instead.
  /// For real-time budget/grant progress, see UserService.GetMyBudget.
  @deprecated
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
