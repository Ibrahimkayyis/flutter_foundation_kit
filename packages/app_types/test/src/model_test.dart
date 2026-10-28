import 'package:flutter_test/flutter_test.dart';
import 'package:app_types/app_types.dart';

void main() {
  group('Paginated & Pagination Tests', () {
    test('create Paginated fromList', () {
      final items = ['item1', 'item2', 'item3'];
      final paginated = Paginated.fromList(items);

      expect(paginated.data.length, 3);
      expect(paginated.pagination.total, 3);
      expect(paginated.pagination.current, 1);
      expect(paginated.pagination.totalPage, 1);
      expect(paginated.pagination.hasNextPage, false);
      expect(paginated.pagination.hasPreviousPage, false);
    });

    test('Pagination fromJson parses fallback keys correctly', () {
      final json = {
        'total': 100,
        'per_page': 10,
        'total_pages': 10,
        'current_page': 2,
      };

      final pagination = Pagination.fromJson(json);
      expect(pagination.total, 100);
      expect(pagination.size, 10);
      expect(pagination.totalPage, 10);
      expect(pagination.current, 2);
      expect(pagination.hasNextPage, true);
      expect(pagination.hasPreviousPage, true);
    });
  });

  group('Model Tests', () {
    test('ReferenceModel serialization', () {
      const model = ReferenceModel(id: 1, name: 'Admin', displayName: 'Administrator');
      expect(model.id, 1);
      expect(model.name, 'Admin');
      expect(model.displayName, 'Administrator');

      final json = model.toJson();
      final fromJson = ReferenceModel.fromJson(json);
      expect(fromJson, model);
    });

    test('SelectionModel serialization', () {
      const model = SelectionModel(
        string: 'Status',
        value: 'active',
        list: [
          SelectionListItemModel(string: 'Active', value: 'active'),
          SelectionListItemModel(string: 'Inactive', value: 'inactive'),
        ],
      );
      expect(model.string, 'Status');
      expect(model.list.length, 2);

      final json = model.toJson();
      final fromJson = SelectionModel.fromJson(json);
      expect(fromJson, model);
    });
  });
}
