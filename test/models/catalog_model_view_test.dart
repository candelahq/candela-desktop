import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart';
import 'package:candela_desktop/models/catalog_model_view.dart';
import 'package:candela_desktop/gen/candela/types/model_catalog.pb.dart';
import 'package:candela_desktop/gen/candela/v1/runtime_service.pb.dart';

void main() {
  group('CatalogModelView', () {
    group('fromTeamEntry', () {
      test('populates all pricing fields from ModelCatalogEntry', () {
        final entry = ModelCatalogEntry(
          modelId: 'gemini-2.5-pro',
          provider: 'google',
          displayName: 'Gemini 2.5 Pro',
          inputPerMillion: 1.25,
          outputPerMillion: 10.0,
          enabled: true,
          category: 'chat',
          contextWindow: Int64(1000000),
          inputPerMillionHigh: 2.50,
          outputPerMillionHigh: 15.0,
          discountPercent: 20.0,
        );

        final view = CatalogModelView.fromTeamEntry(entry);

        expect(view.modelId, 'gemini-2.5-pro');
        expect(view.displayName, 'Gemini 2.5 Pro');
        expect(view.provider, 'google');
        expect(view.inputPerMillion, 1.25);
        expect(view.outputPerMillion, 10.0);
        expect(view.category, 'chat');
        expect(view.contextWindow, 1000000);
        expect(view.inputPerMillionHigh, 2.50);
        expect(view.outputPerMillionHigh, 15.0);
        expect(view.discountPercent, 20.0);
        expect(view.enabled, isTrue);
        expect(view.hasPricing, isTrue);
        expect(view.sizeHint, isNull);
        expect(view.description, isNull);
      });

      test('falls back to modelId when displayName is empty', () {
        final entry = ModelCatalogEntry(
          modelId: 'claude-sonnet-4',
          provider: 'anthropic',
        );

        final view = CatalogModelView.fromTeamEntry(entry);
        expect(view.displayName, 'claude-sonnet-4');
      });

      test('omits optional fields when zero/empty', () {
        final entry = ModelCatalogEntry(
          modelId: 'test-model',
          provider: 'test',
          inputPerMillion: 0.5,
          outputPerMillion: 1.0,
        );

        final view = CatalogModelView.fromTeamEntry(entry);
        expect(view.category, isNull);
        expect(view.contextWindow, isNull);
        expect(view.inputPerMillionHigh, isNull);
        expect(view.outputPerMillionHigh, isNull);
        expect(view.discountPercent, isNull);
      });

      test('disabled entries have enabled=false', () {
        final entry = ModelCatalogEntry(
          modelId: 'disabled-model',
          provider: 'test',
          enabled: false,
        );

        final view = CatalogModelView.fromTeamEntry(entry);
        expect(view.enabled, isFalse);
      });
    });

    group('fromLocalModel', () {
      test('populates local fields without pricing', () {
        final model = CatalogModel(
          id: 'llama3.2:3b',
          name: 'Llama 3.2 3B',
          description: 'Small and fast local model',
          sizeHint: '2.0 GB',
          pinned: true,
        );

        final view = CatalogModelView.fromLocalModel(model);

        expect(view.modelId, 'llama3.2:3b');
        expect(view.displayName, 'Llama 3.2 3B');
        expect(view.provider, 'ollama');
        expect(view.description, 'Small and fast local model');
        expect(view.sizeHint, '2.0 GB');
        expect(view.pinned, isTrue);
        expect(view.hasPricing, isFalse);
        expect(view.inputPerMillion, isNull);
        expect(view.outputPerMillion, isNull);
        expect(view.category, isNull);
      });

      test('falls back to id when name is empty', () {
        final model = CatalogModel(id: 'phi3:mini');

        final view = CatalogModelView.fromLocalModel(model);
        expect(view.displayName, 'phi3:mini');
      });

      test('omits optional fields when empty', () {
        final model = CatalogModel(id: 'test');

        final view = CatalogModelView.fromLocalModel(model);
        expect(view.description, isNull);
        expect(view.sizeHint, isNull);
        expect(view.pinned, isFalse);
      });
    });

    group('CatalogResult', () {
      test('isTeamMode returns true for team source', () {
        const result = CatalogResult(source: CatalogSource.team);
        expect(result.isTeamMode, isTrue);
      });

      test('isTeamMode returns false for local source', () {
        const result = CatalogResult(source: CatalogSource.local);
        expect(result.isTeamMode, isFalse);
      });

      test('defaults to empty models and no error', () {
        const result = CatalogResult(source: CatalogSource.team);
        expect(result.models, isEmpty);
        expect(result.error, isNull);
        expect(result.adminEditable, isFalse);
      });
    });
  });
}
