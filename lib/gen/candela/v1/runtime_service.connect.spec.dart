//
//  Generated code. Do not modify.
//  source: candela/v1/runtime_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "runtime_service.pb.dart" as candelav1runtime_service;

/// RuntimeService manages local LLM inference servers (Ollama, vLLM, LM Studio).
/// Used by the embedded management UI and future Flutter desktop client.
/// All RPCs operate on the locally configured runtime backend. The service
/// runs in candela-local and does not require the cloud backend.
/// ── Server lifecycle ──
abstract final class RuntimeService {
  /// Fully-qualified name of the RuntimeService service.
  static const name = 'candela.v1.RuntimeService';

  /// StartRuntime launches the configured runtime process.
  /// If already running, this is a no-op. If a backend override is provided,
  /// the current runtime is stopped and the new one is started.
  static const startRuntime = connect.Spec(
    '/$name/StartRuntime',
    connect.StreamType.unary,
    candelav1runtime_service.StartRuntimeRequest.new,
    candelav1runtime_service.StartRuntimeResponse.new,
  );

  /// StopRuntime gracefully shuts down the running runtime process.
  static const stopRuntime = connect.Spec(
    '/$name/StopRuntime',
    connect.StreamType.unary,
    candelav1runtime_service.StopRuntimeRequest.new,
    candelav1runtime_service.StopRuntimeResponse.new,
  );

  /// GetHealth returns the cached health status and loaded models.
  static const getHealth = connect.Spec(
    '/$name/GetHealth',
    connect.StreamType.unary,
    candelav1runtime_service.GetHealthRequest.new,
    candelav1runtime_service.GetHealthResponse.new,
  );

  /// LoadModel loads a model into GPU memory. For vLLM this triggers a
  /// process restart (returns status "starting"). Poll GetHealth for readiness.
  static const loadModel = connect.Spec(
    '/$name/LoadModel',
    connect.StreamType.unary,
    candelav1runtime_service.LoadModelRequest.new,
    candelav1runtime_service.LoadModelResponse.new,
  );

  /// UnloadModel removes a model from GPU memory. For vLLM this stops the process.
  static const unloadModel = connect.Spec(
    '/$name/UnloadModel',
    connect.StreamType.unary,
    candelav1runtime_service.UnloadModelRequest.new,
    candelav1runtime_service.UnloadModelResponse.new,
  );

  /// ListModels returns all models available in the runtime (both loaded and on-disk).
  static const listModels = connect.Spec(
    '/$name/ListModels',
    connect.StreamType.unary,
    candelav1runtime_service.ListModelsRequest.new,
    candelav1runtime_service.ListModelsResponse.new,
  );

  /// PullModel starts an asynchronous model download. Returns immediately.
  /// Poll GetHealth or ListModels to see when the model appears.
  static const pullModel = connect.Spec(
    '/$name/PullModel',
    connect.StreamType.unary,
    candelav1runtime_service.PullModelRequest.new,
    candelav1runtime_service.PullModelResponse.new,
  );

  /// CancelPull cancels an in-flight model download.
  static const cancelPull = connect.Spec(
    '/$name/CancelPull',
    connect.StreamType.unary,
    candelav1runtime_service.CancelPullRequest.new,
    candelav1runtime_service.CancelPullResponse.new,
  );

  /// DeleteModel removes a model from disk. Only supported by Ollama.
  static const deleteModel = connect.Spec(
    '/$name/DeleteModel',
    connect.StreamType.unary,
    candelav1runtime_service.DeleteModelRequest.new,
    candelav1runtime_service.DeleteModelResponse.new,
  );

  /// ListBackends returns registered runtime backends and their install status.
  static const listBackends = connect.Spec(
    '/$name/ListBackends',
    connect.StreamType.unary,
    candelav1runtime_service.ListBackendsRequest.new,
    candelav1runtime_service.ListBackendsResponse.new,
  );

  /// ResetState clears all local state (preferences, pull history) from the
  /// state database. The YAML config file is not affected.
  static const resetState = connect.Spec(
    '/$name/ResetState',
    connect.StreamType.unary,
    candelav1runtime_service.ResetStateRequest.new,
    candelav1runtime_service.ResetStateResponse.new,
  );

  /// ListCatalog returns the user's model catalog (suggested models to pull).
  static const listCatalog = connect.Spec(
    '/$name/ListCatalog',
    connect.StreamType.unary,
    candelav1runtime_service.ListCatalogRequest.new,
    candelav1runtime_service.ListCatalogResponse.new,
  );
}
