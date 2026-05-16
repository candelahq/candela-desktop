//
//  Generated code. Do not modify.
//  source: candela/v1/project_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "project_service.pb.dart" as candelav1project_service;
import "project_service.connect.spec.dart" as specs;

/// ProjectService manages projects and API keys.
/// Exposed via ConnectRPC for the web UI.
extension type ProjectServiceClient(connect.Transport _transport) {
  Future<candelav1project_service.CreateProjectResponse> createProject(
    candelav1project_service.CreateProjectRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProjectService.createProject,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<candelav1project_service.GetProjectResponse> getProject(
    candelav1project_service.GetProjectRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProjectService.getProject,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<candelav1project_service.ListProjectsResponse> listProjects(
    candelav1project_service.ListProjectsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProjectService.listProjects,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<candelav1project_service.DeleteProjectResponse> deleteProject(
    candelav1project_service.DeleteProjectRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProjectService.deleteProject,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// API Key management
  Future<candelav1project_service.CreateAPIKeyResponse> createAPIKey(
    candelav1project_service.CreateAPIKeyRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProjectService.createAPIKey,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<candelav1project_service.ListAPIKeysResponse> listAPIKeys(
    candelav1project_service.ListAPIKeysRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProjectService.listAPIKeys,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<candelav1project_service.RevokeAPIKeyResponse> revokeAPIKey(
    candelav1project_service.RevokeAPIKeyRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ProjectService.revokeAPIKey,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
