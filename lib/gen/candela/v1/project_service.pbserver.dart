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

import 'project_service.pb.dart' as $12;
import 'project_service.pbjson.dart';

export 'project_service.pb.dart';

abstract class ProjectServiceBase extends $pb.GeneratedService {
  $async.Future<$12.CreateProjectResponse> createProject(
      $pb.ServerContext ctx, $12.CreateProjectRequest request);
  $async.Future<$12.GetProjectResponse> getProject(
      $pb.ServerContext ctx, $12.GetProjectRequest request);
  $async.Future<$12.ListProjectsResponse> listProjects(
      $pb.ServerContext ctx, $12.ListProjectsRequest request);
  $async.Future<$12.DeleteProjectResponse> deleteProject(
      $pb.ServerContext ctx, $12.DeleteProjectRequest request);
  $async.Future<$12.CreateAPIKeyResponse> createAPIKey(
      $pb.ServerContext ctx, $12.CreateAPIKeyRequest request);
  $async.Future<$12.ListAPIKeysResponse> listAPIKeys(
      $pb.ServerContext ctx, $12.ListAPIKeysRequest request);
  $async.Future<$12.RevokeAPIKeyResponse> revokeAPIKey(
      $pb.ServerContext ctx, $12.RevokeAPIKeyRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateProject':
        return $12.CreateProjectRequest();
      case 'GetProject':
        return $12.GetProjectRequest();
      case 'ListProjects':
        return $12.ListProjectsRequest();
      case 'DeleteProject':
        return $12.DeleteProjectRequest();
      case 'CreateAPIKey':
        return $12.CreateAPIKeyRequest();
      case 'ListAPIKeys':
        return $12.ListAPIKeysRequest();
      case 'RevokeAPIKey':
        return $12.RevokeAPIKeyRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateProject':
        return this.createProject(ctx, request as $12.CreateProjectRequest);
      case 'GetProject':
        return this.getProject(ctx, request as $12.GetProjectRequest);
      case 'ListProjects':
        return this.listProjects(ctx, request as $12.ListProjectsRequest);
      case 'DeleteProject':
        return this.deleteProject(ctx, request as $12.DeleteProjectRequest);
      case 'CreateAPIKey':
        return this.createAPIKey(ctx, request as $12.CreateAPIKeyRequest);
      case 'ListAPIKeys':
        return this.listAPIKeys(ctx, request as $12.ListAPIKeysRequest);
      case 'RevokeAPIKey':
        return this.revokeAPIKey(ctx, request as $12.RevokeAPIKeyRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ProjectServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ProjectServiceBase$messageJson;
}
