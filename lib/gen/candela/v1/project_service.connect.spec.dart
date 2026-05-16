//
//  Generated code. Do not modify.
//  source: candela/v1/project_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "project_service.pb.dart" as candelav1project_service;

/// ProjectService manages projects and API keys.
/// Exposed via ConnectRPC for the web UI.
abstract final class ProjectService {
  /// Fully-qualified name of the ProjectService service.
  static const name = 'candela.v1.ProjectService';

  static const createProject = connect.Spec(
    '/$name/CreateProject',
    connect.StreamType.unary,
    candelav1project_service.CreateProjectRequest.new,
    candelav1project_service.CreateProjectResponse.new,
  );

  static const getProject = connect.Spec(
    '/$name/GetProject',
    connect.StreamType.unary,
    candelav1project_service.GetProjectRequest.new,
    candelav1project_service.GetProjectResponse.new,
  );

  static const listProjects = connect.Spec(
    '/$name/ListProjects',
    connect.StreamType.unary,
    candelav1project_service.ListProjectsRequest.new,
    candelav1project_service.ListProjectsResponse.new,
  );

  static const deleteProject = connect.Spec(
    '/$name/DeleteProject',
    connect.StreamType.unary,
    candelav1project_service.DeleteProjectRequest.new,
    candelav1project_service.DeleteProjectResponse.new,
  );

  /// API Key management
  static const createAPIKey = connect.Spec(
    '/$name/CreateAPIKey',
    connect.StreamType.unary,
    candelav1project_service.CreateAPIKeyRequest.new,
    candelav1project_service.CreateAPIKeyResponse.new,
  );

  static const listAPIKeys = connect.Spec(
    '/$name/ListAPIKeys',
    connect.StreamType.unary,
    candelav1project_service.ListAPIKeysRequest.new,
    candelav1project_service.ListAPIKeysResponse.new,
  );

  static const revokeAPIKey = connect.Spec(
    '/$name/RevokeAPIKey',
    connect.StreamType.unary,
    candelav1project_service.RevokeAPIKeyRequest.new,
    candelav1project_service.RevokeAPIKeyResponse.new,
  );
}
