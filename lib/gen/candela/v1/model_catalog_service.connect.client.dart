//
//  Generated code. Do not modify.
//  source: candela/v1/model_catalog_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "model_catalog_service.pb.dart" as candelav1model_catalog_service;
import "model_catalog_service.connect.spec.dart" as specs;

/// ModelCatalogService provides read and admin-write access to the model catalog.
/// ListModelCatalog is available to all authenticated users.
/// UpdateModelCatalogEntry is admin-only and requires a database-backed catalog.
extension type ModelCatalogServiceClient(connect.Transport _transport) {
  /// ListModelCatalog returns all models in the catalog.
  /// Non-admin callers always receive enabled-only models regardless of include_disabled.
  Future<candelav1model_catalog_service.ListModelCatalogResponse>
      listModelCatalog(
    candelav1model_catalog_service.ListModelCatalogRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ModelCatalogService.listModelCatalog,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UpdateModelCatalogEntry updates a single model entry.
  /// Admin-only. Returns Unimplemented when the catalog backend is read-only (e.g., config file).
  Future<candelav1model_catalog_service.UpdateModelCatalogEntryResponse>
      updateModelCatalogEntry(
    candelav1model_catalog_service.UpdateModelCatalogEntryRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ModelCatalogService.updateModelCatalogEntry,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeleteModelCatalogEntry removes a model entry from the catalog.
  /// Admin-only. Returns Unimplemented when the catalog backend is read-only.
  /// Semantics: hard delete from the store. To soft-delete, use UpdateModelCatalogEntry
  /// with update_mask: ["enabled"] and enabled: false.
  Future<candelav1model_catalog_service.DeleteModelCatalogEntryResponse>
      deleteModelCatalogEntry(
    candelav1model_catalog_service.DeleteModelCatalogEntryRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ModelCatalogService.deleteModelCatalogEntry,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
