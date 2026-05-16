//
//  Generated code. Do not modify.
//  source: candela/v1/runtime_service.proto
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

import 'runtime_service.pb.dart' as $13;
import 'runtime_service.pbjson.dart';

export 'runtime_service.pb.dart';

abstract class RuntimeServiceBase extends $pb.GeneratedService {
  $async.Future<$13.StartRuntimeResponse> startRuntime(
      $pb.ServerContext ctx, $13.StartRuntimeRequest request);
  $async.Future<$13.StopRuntimeResponse> stopRuntime(
      $pb.ServerContext ctx, $13.StopRuntimeRequest request);
  $async.Future<$13.GetHealthResponse> getHealth(
      $pb.ServerContext ctx, $13.GetHealthRequest request);
  $async.Future<$13.LoadModelResponse> loadModel(
      $pb.ServerContext ctx, $13.LoadModelRequest request);
  $async.Future<$13.UnloadModelResponse> unloadModel(
      $pb.ServerContext ctx, $13.UnloadModelRequest request);
  $async.Future<$13.ListModelsResponse> listModels(
      $pb.ServerContext ctx, $13.ListModelsRequest request);
  $async.Future<$13.PullModelResponse> pullModel(
      $pb.ServerContext ctx, $13.PullModelRequest request);
  $async.Future<$13.CancelPullResponse> cancelPull(
      $pb.ServerContext ctx, $13.CancelPullRequest request);
  $async.Future<$13.DeleteModelResponse> deleteModel(
      $pb.ServerContext ctx, $13.DeleteModelRequest request);
  $async.Future<$13.ListBackendsResponse> listBackends(
      $pb.ServerContext ctx, $13.ListBackendsRequest request);
  $async.Future<$13.ResetStateResponse> resetState(
      $pb.ServerContext ctx, $13.ResetStateRequest request);
  $async.Future<$13.ListCatalogResponse> listCatalog(
      $pb.ServerContext ctx, $13.ListCatalogRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'StartRuntime':
        return $13.StartRuntimeRequest();
      case 'StopRuntime':
        return $13.StopRuntimeRequest();
      case 'GetHealth':
        return $13.GetHealthRequest();
      case 'LoadModel':
        return $13.LoadModelRequest();
      case 'UnloadModel':
        return $13.UnloadModelRequest();
      case 'ListModels':
        return $13.ListModelsRequest();
      case 'PullModel':
        return $13.PullModelRequest();
      case 'CancelPull':
        return $13.CancelPullRequest();
      case 'DeleteModel':
        return $13.DeleteModelRequest();
      case 'ListBackends':
        return $13.ListBackendsRequest();
      case 'ResetState':
        return $13.ResetStateRequest();
      case 'ListCatalog':
        return $13.ListCatalogRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'StartRuntime':
        return this.startRuntime(ctx, request as $13.StartRuntimeRequest);
      case 'StopRuntime':
        return this.stopRuntime(ctx, request as $13.StopRuntimeRequest);
      case 'GetHealth':
        return this.getHealth(ctx, request as $13.GetHealthRequest);
      case 'LoadModel':
        return this.loadModel(ctx, request as $13.LoadModelRequest);
      case 'UnloadModel':
        return this.unloadModel(ctx, request as $13.UnloadModelRequest);
      case 'ListModels':
        return this.listModels(ctx, request as $13.ListModelsRequest);
      case 'PullModel':
        return this.pullModel(ctx, request as $13.PullModelRequest);
      case 'CancelPull':
        return this.cancelPull(ctx, request as $13.CancelPullRequest);
      case 'DeleteModel':
        return this.deleteModel(ctx, request as $13.DeleteModelRequest);
      case 'ListBackends':
        return this.listBackends(ctx, request as $13.ListBackendsRequest);
      case 'ResetState':
        return this.resetState(ctx, request as $13.ResetStateRequest);
      case 'ListCatalog':
        return this.listCatalog(ctx, request as $13.ListCatalogRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => RuntimeServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => RuntimeServiceBase$messageJson;
}
