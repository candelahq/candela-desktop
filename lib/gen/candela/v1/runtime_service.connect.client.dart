//
//  Generated code. Do not modify.
//  source: candela/v1/runtime_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "runtime_service.pb.dart" as candelav1runtime_service;
import "runtime_service.connect.spec.dart" as specs;

/// RuntimeService manages local LLM inference servers (Ollama, vLLM, LM Studio).
/// Used by the embedded management UI and future Flutter desktop client.
/// All RPCs operate on the locally configured runtime backend. The service
/// runs in candela-local and does not require the cloud backend.
/// ── Server lifecycle ──
extension type RuntimeServiceClient(connect.Transport _transport) {
  /// StartRuntime launches the configured runtime process.
  /// If already running, this is a no-op. If a backend override is provided,
  /// the current runtime is stopped and the new one is started.
  Future<candelav1runtime_service.StartRuntimeResponse> startRuntime(
    candelav1runtime_service.StartRuntimeRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RuntimeService.startRuntime,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// StopRuntime gracefully shuts down the running runtime process.
  Future<candelav1runtime_service.StopRuntimeResponse> stopRuntime(
    candelav1runtime_service.StopRuntimeRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RuntimeService.stopRuntime,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetHealth returns the cached health status and loaded models.
  Future<candelav1runtime_service.GetHealthResponse> getHealth(
    candelav1runtime_service.GetHealthRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RuntimeService.getHealth,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoadModel loads a model into GPU memory. For vLLM this triggers a
  /// process restart (returns status "starting"). Poll GetHealth for readiness.
  Future<candelav1runtime_service.LoadModelResponse> loadModel(
    candelav1runtime_service.LoadModelRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RuntimeService.loadModel,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UnloadModel removes a model from GPU memory. For vLLM this stops the process.
  Future<candelav1runtime_service.UnloadModelResponse> unloadModel(
    candelav1runtime_service.UnloadModelRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RuntimeService.unloadModel,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListModels returns all models available in the runtime (both loaded and on-disk).
  Future<candelav1runtime_service.ListModelsResponse> listModels(
    candelav1runtime_service.ListModelsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RuntimeService.listModels,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// PullModel starts an asynchronous model download. Returns immediately.
  /// Poll GetHealth or ListModels to see when the model appears.
  Future<candelav1runtime_service.PullModelResponse> pullModel(
    candelav1runtime_service.PullModelRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RuntimeService.pullModel,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CancelPull cancels an in-flight model download.
  Future<candelav1runtime_service.CancelPullResponse> cancelPull(
    candelav1runtime_service.CancelPullRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RuntimeService.cancelPull,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeleteModel removes a model from disk. Only supported by Ollama.
  Future<candelav1runtime_service.DeleteModelResponse> deleteModel(
    candelav1runtime_service.DeleteModelRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RuntimeService.deleteModel,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListBackends returns registered runtime backends and their install status.
  Future<candelav1runtime_service.ListBackendsResponse> listBackends(
    candelav1runtime_service.ListBackendsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RuntimeService.listBackends,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ResetState clears all local state (preferences, pull history) from the
  /// state database. The YAML config file is not affected.
  Future<candelav1runtime_service.ResetStateResponse> resetState(
    candelav1runtime_service.ResetStateRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RuntimeService.resetState,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListCatalog returns the user's model catalog (suggested models to pull).
  Future<candelav1runtime_service.ListCatalogResponse> listCatalog(
    candelav1runtime_service.ListCatalogRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RuntimeService.listCatalog,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
