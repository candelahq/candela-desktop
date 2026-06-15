//
//  Generated code. Do not modify.
//  source: candela/v1/model_catalog_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "model_catalog_service.pb.dart" as candelav1model_catalog_service;

/// ModelCatalogService provides read and admin-write access to the model catalog.
/// ListModelCatalog is available to all authenticated users.
/// UpdateModelCatalogEntry is admin-only and requires a database-backed catalog.
abstract final class ModelCatalogService {
  /// Fully-qualified name of the ModelCatalogService service.
  static const name = 'candela.v1.ModelCatalogService';

  /// ListModelCatalog returns all models in the catalog.
  /// Non-admin callers always receive enabled-only models regardless of include_disabled.
  static const listModelCatalog = connect.Spec(
    '/$name/ListModelCatalog',
    connect.StreamType.unary,
    candelav1model_catalog_service.ListModelCatalogRequest.new,
    candelav1model_catalog_service.ListModelCatalogResponse.new,
  );

  /// UpdateModelCatalogEntry updates a single model entry.
  /// Admin-only. Returns Unimplemented when the catalog backend is read-only (e.g., config file).
  static const updateModelCatalogEntry = connect.Spec(
    '/$name/UpdateModelCatalogEntry',
    connect.StreamType.unary,
    candelav1model_catalog_service.UpdateModelCatalogEntryRequest.new,
    candelav1model_catalog_service.UpdateModelCatalogEntryResponse.new,
  );

  /// DeleteModelCatalogEntry removes a model entry from the catalog.
  /// Admin-only. Returns Unimplemented when the catalog backend is read-only.
  /// Semantics: hard delete from the store. To soft-delete, use UpdateModelCatalogEntry
  /// with update_mask: ["enabled"] and enabled: false.
  static const deleteModelCatalogEntry = connect.Spec(
    '/$name/DeleteModelCatalogEntry',
    connect.StreamType.unary,
    candelav1model_catalog_service.DeleteModelCatalogEntryRequest.new,
    candelav1model_catalog_service.DeleteModelCatalogEntryResponse.new,
  );
}
