//
//  Generated code. Do not modify.
//  source: candela/v1/dashboard_service.proto
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

import 'dashboard_service.pb.dart' as $8;
import 'dashboard_service.pbjson.dart';

export 'dashboard_service.pb.dart';

abstract class DashboardServiceBase extends $pb.GeneratedService {
  $async.Future<$8.GetDashboardDataResponse> getDashboardData(
      $pb.ServerContext ctx, $8.GetDashboardDataRequest request);
  $async.Future<$8.GetUsageSummaryResponse> getUsageSummary(
      $pb.ServerContext ctx, $8.GetUsageSummaryRequest request);
  $async.Future<$8.GetModelBreakdownResponse> getModelBreakdown(
      $pb.ServerContext ctx, $8.GetModelBreakdownRequest request);
  $async.Future<$8.GetLatencyPercentilesResponse> getLatencyPercentiles(
      $pb.ServerContext ctx, $8.GetLatencyPercentilesRequest request);
  $async.Future<$8.GetMyUsageResponse> getMyUsage(
      $pb.ServerContext ctx, $8.GetMyUsageRequest request);
  $async.Future<$8.GetTeamLeaderboardResponse> getTeamLeaderboard(
      $pb.ServerContext ctx, $8.GetTeamLeaderboardRequest request);
  $async.Future<$8.GetJobLeaderboardResponse> getJobLeaderboard(
      $pb.ServerContext ctx, $8.GetJobLeaderboardRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetDashboardData':
        return $8.GetDashboardDataRequest();
      case 'GetUsageSummary':
        return $8.GetUsageSummaryRequest();
      case 'GetModelBreakdown':
        return $8.GetModelBreakdownRequest();
      case 'GetLatencyPercentiles':
        return $8.GetLatencyPercentilesRequest();
      case 'GetMyUsage':
        return $8.GetMyUsageRequest();
      case 'GetTeamLeaderboard':
        return $8.GetTeamLeaderboardRequest();
      case 'GetJobLeaderboard':
        return $8.GetJobLeaderboardRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetDashboardData':
        return this
            .getDashboardData(ctx, request as $8.GetDashboardDataRequest);
      case 'GetUsageSummary':
        return this.getUsageSummary(ctx, request as $8.GetUsageSummaryRequest);
      case 'GetModelBreakdown':
        return this
            .getModelBreakdown(ctx, request as $8.GetModelBreakdownRequest);
      case 'GetLatencyPercentiles':
        return this.getLatencyPercentiles(
            ctx, request as $8.GetLatencyPercentilesRequest);
      case 'GetMyUsage':
        return this.getMyUsage(ctx, request as $8.GetMyUsageRequest);
      case 'GetTeamLeaderboard':
        return this
            .getTeamLeaderboard(ctx, request as $8.GetTeamLeaderboardRequest);
      case 'GetJobLeaderboard':
        return this
            .getJobLeaderboard(ctx, request as $8.GetJobLeaderboardRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => DashboardServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => DashboardServiceBase$messageJson;
}
