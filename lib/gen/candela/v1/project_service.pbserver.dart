//
//  Generated code. Do not modify.
//  source: candela/v1/project_service.proto
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

import 'project_service.pb.dart' as $14;
import 'project_service.pbjson.dart';

export 'project_service.pb.dart';

abstract class ProjectServiceBase extends $pb.GeneratedService {
  $async.Future<$14.CreateProjectResponse> createProject(
      $pb.ServerContext ctx, $14.CreateProjectRequest request);
  $async.Future<$14.GetProjectResponse> getProject(
      $pb.ServerContext ctx, $14.GetProjectRequest request);
  $async.Future<$14.ListProjectsResponse> listProjects(
      $pb.ServerContext ctx, $14.ListProjectsRequest request);
  $async.Future<$14.DeleteProjectResponse> deleteProject(
      $pb.ServerContext ctx, $14.DeleteProjectRequest request);
  $async.Future<$14.CreateAPIKeyResponse> createAPIKey(
      $pb.ServerContext ctx, $14.CreateAPIKeyRequest request);
  $async.Future<$14.ListAPIKeysResponse> listAPIKeys(
      $pb.ServerContext ctx, $14.ListAPIKeysRequest request);
  $async.Future<$14.RevokeAPIKeyResponse> revokeAPIKey(
      $pb.ServerContext ctx, $14.RevokeAPIKeyRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateProject':
        return $14.CreateProjectRequest();
      case 'GetProject':
        return $14.GetProjectRequest();
      case 'ListProjects':
        return $14.ListProjectsRequest();
      case 'DeleteProject':
        return $14.DeleteProjectRequest();
      case 'CreateAPIKey':
        return $14.CreateAPIKeyRequest();
      case 'ListAPIKeys':
        return $14.ListAPIKeysRequest();
      case 'RevokeAPIKey':
        return $14.RevokeAPIKeyRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateProject':
        return this.createProject(ctx, request as $14.CreateProjectRequest);
      case 'GetProject':
        return this.getProject(ctx, request as $14.GetProjectRequest);
      case 'ListProjects':
        return this.listProjects(ctx, request as $14.ListProjectsRequest);
      case 'DeleteProject':
        return this.deleteProject(ctx, request as $14.DeleteProjectRequest);
      case 'CreateAPIKey':
        return this.createAPIKey(ctx, request as $14.CreateAPIKeyRequest);
      case 'ListAPIKeys':
        return this.listAPIKeys(ctx, request as $14.ListAPIKeysRequest);
      case 'RevokeAPIKey':
        return this.revokeAPIKey(ctx, request as $14.RevokeAPIKeyRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ProjectServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ProjectServiceBase$messageJson;
}
