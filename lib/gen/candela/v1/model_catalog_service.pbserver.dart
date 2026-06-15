//
//  Generated code. Do not modify.
//  source: candela/v1/model_catalog_service.proto
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

import 'model_catalog_service.pb.dart' as $12;
import 'model_catalog_service.pbjson.dart';

export 'model_catalog_service.pb.dart';

abstract class ModelCatalogServiceBase extends $pb.GeneratedService {
  $async.Future<$12.ListModelCatalogResponse> listModelCatalog(
      $pb.ServerContext ctx, $12.ListModelCatalogRequest request);
  $async.Future<$12.UpdateModelCatalogEntryResponse> updateModelCatalogEntry(
      $pb.ServerContext ctx, $12.UpdateModelCatalogEntryRequest request);
  $async.Future<$12.DeleteModelCatalogEntryResponse> deleteModelCatalogEntry(
      $pb.ServerContext ctx, $12.DeleteModelCatalogEntryRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListModelCatalog':
        return $12.ListModelCatalogRequest();
      case 'UpdateModelCatalogEntry':
        return $12.UpdateModelCatalogEntryRequest();
      case 'DeleteModelCatalogEntry':
        return $12.DeleteModelCatalogEntryRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListModelCatalog':
        return this
            .listModelCatalog(ctx, request as $12.ListModelCatalogRequest);
      case 'UpdateModelCatalogEntry':
        return this.updateModelCatalogEntry(
            ctx, request as $12.UpdateModelCatalogEntryRequest);
      case 'DeleteModelCatalogEntry':
        return this.deleteModelCatalogEntry(
            ctx, request as $12.DeleteModelCatalogEntryRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      ModelCatalogServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ModelCatalogServiceBase$messageJson;
}
