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

import 'runtime_service.pb.dart' as $15;
import 'runtime_service.pbjson.dart';

export 'runtime_service.pb.dart';

abstract class RuntimeServiceBase extends $pb.GeneratedService {
  $async.Future<$15.StartRuntimeResponse> startRuntime(
      $pb.ServerContext ctx, $15.StartRuntimeRequest request);
  $async.Future<$15.StopRuntimeResponse> stopRuntime(
      $pb.ServerContext ctx, $15.StopRuntimeRequest request);
  $async.Future<$15.GetHealthResponse> getHealth(
      $pb.ServerContext ctx, $15.GetHealthRequest request);
  $async.Future<$15.LoadModelResponse> loadModel(
      $pb.ServerContext ctx, $15.LoadModelRequest request);
  $async.Future<$15.UnloadModelResponse> unloadModel(
      $pb.ServerContext ctx, $15.UnloadModelRequest request);
  $async.Future<$15.ListModelsResponse> listModels(
      $pb.ServerContext ctx, $15.ListModelsRequest request);
  $async.Future<$15.PullModelResponse> pullModel(
      $pb.ServerContext ctx, $15.PullModelRequest request);
  $async.Future<$15.CancelPullResponse> cancelPull(
      $pb.ServerContext ctx, $15.CancelPullRequest request);
  $async.Future<$15.DeleteModelResponse> deleteModel(
      $pb.ServerContext ctx, $15.DeleteModelRequest request);
  $async.Future<$15.ListBackendsResponse> listBackends(
      $pb.ServerContext ctx, $15.ListBackendsRequest request);
  $async.Future<$15.ResetStateResponse> resetState(
      $pb.ServerContext ctx, $15.ResetStateRequest request);
  $async.Future<$15.ListCatalogResponse> listCatalog(
      $pb.ServerContext ctx, $15.ListCatalogRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'StartRuntime':
        return $15.StartRuntimeRequest();
      case 'StopRuntime':
        return $15.StopRuntimeRequest();
      case 'GetHealth':
        return $15.GetHealthRequest();
      case 'LoadModel':
        return $15.LoadModelRequest();
      case 'UnloadModel':
        return $15.UnloadModelRequest();
      case 'ListModels':
        return $15.ListModelsRequest();
      case 'PullModel':
        return $15.PullModelRequest();
      case 'CancelPull':
        return $15.CancelPullRequest();
      case 'DeleteModel':
        return $15.DeleteModelRequest();
      case 'ListBackends':
        return $15.ListBackendsRequest();
      case 'ResetState':
        return $15.ResetStateRequest();
      case 'ListCatalog':
        return $15.ListCatalogRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'StartRuntime':
        return this.startRuntime(ctx, request as $15.StartRuntimeRequest);
      case 'StopRuntime':
        return this.stopRuntime(ctx, request as $15.StopRuntimeRequest);
      case 'GetHealth':
        return this.getHealth(ctx, request as $15.GetHealthRequest);
      case 'LoadModel':
        return this.loadModel(ctx, request as $15.LoadModelRequest);
      case 'UnloadModel':
        return this.unloadModel(ctx, request as $15.UnloadModelRequest);
      case 'ListModels':
        return this.listModels(ctx, request as $15.ListModelsRequest);
      case 'PullModel':
        return this.pullModel(ctx, request as $15.PullModelRequest);
      case 'CancelPull':
        return this.cancelPull(ctx, request as $15.CancelPullRequest);
      case 'DeleteModel':
        return this.deleteModel(ctx, request as $15.DeleteModelRequest);
      case 'ListBackends':
        return this.listBackends(ctx, request as $15.ListBackendsRequest);
      case 'ResetState':
        return this.resetState(ctx, request as $15.ResetStateRequest);
      case 'ListCatalog':
        return this.listCatalog(ctx, request as $15.ListCatalogRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => RuntimeServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => RuntimeServiceBase$messageJson;
}
