import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_ui/nti_ui.dart';
import 'package:app_ui/test_helper.dart';
import 'package:app_types/types.dart';

void main() {
  const size = 10;
  const maxPage = 2;
  String buildItem(int index) {
    return "Item $index";
  }

  Future<Resource<PaginatedList<String>>> mockFetch(
    PaginatedQuery query,
  ) async {
    final page = query.page ?? 1;
    final list = List.generate(
      size,
      (index) => buildItem((index + 1) + (page - 1) * size),
    );
    return Resource.success(
      PaginatedList.fromList(
        list,
        current: page,
        size: size,
        total: size * maxPage,
        totalPage: maxPage,
      ),
      "",
    );
  }

  group('Pagination List (Non Sliver)', () {
    testWidgets('Should Render Without Seperated', (tester) async {
      final controller = PaginatedController<String>(fetchFunc: mockFetch);
      await tester.pumpWidget(
        TestHelper.buildTestableWidget(
          PaginatedListWidget(
            controller: controller,
            shrinkWrap: true,
            builderDelegate: PageChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return Text(item.toString(), key: ValueKey(item));
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final listFinder = find.byType(Scrollable);
      final itemFinder = find.text(buildItem(19));

      // Scroll until the item to be found appears.
      await tester.scrollUntilVisible(
        itemFinder,
        500.0,
        scrollable: listFinder,
      );
      expect(controller.value.keys?.length, 2);
      expect(controller.value.keys?[1].page, maxPage);
    });

    testWidgets('Should Render With Seperated', (tester) async {
      final controller = PaginatedController<String>(fetchFunc: mockFetch);
      await tester.pumpWidget(
        TestHelper.buildTestableWidget(
          PaginatedListWidget(
            controller: controller,
            shrinkWrap: true,
            separatorBuilder: (context, index) => Text('Seperator-$index'),
            builderDelegate: PageChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return Text(item.toString(), key: ValueKey(item));
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final listFinder = find.byType(Scrollable);
      final itemFinder = find.text('Seperator-18');
      // Scroll until the item to be found appears.
      await tester.scrollUntilVisible(
        itemFinder,
        500.0,
        scrollable: listFinder,
      );
    });
  });

  group('Pagination List (Sliver)', () {
    testWidgets('Should Render Without Seperated', (tester) async {
      final controller = PaginatedController<String>(fetchFunc: mockFetch);
      await tester.pumpWidget(
        TestHelper.buildTestableWidget(
          CustomScrollView(
            slivers: [
              PaginatedSliverListWidget(
                controller: controller,
                builderDelegate: PageChildBuilderDelegate(
                  itemBuilder: (context, item, index) {
                    return Text(item.toString(), key: ValueKey(item));
                  },
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final listFinder = find.byType(Scrollable);
      final itemFinder = find.text(buildItem(19));

      // Scroll until the item to be found appears.
      await tester.scrollUntilVisible(
        itemFinder,
        500.0,
        scrollable: listFinder,
      );

      expect(controller.value.keys?.length, 2);
      expect(controller.value.keys?[1].page, maxPage);
    });

    testWidgets('Should Render With Seperated', (tester) async {
      final controller = PaginatedController<String>(fetchFunc: mockFetch);
      await tester.pumpWidget(
        TestHelper.buildTestableWidget(
          CustomScrollView(
            slivers: [
              PaginatedSliverListWidget(
                controller: controller,
                separatorBuilder: (context, index) => Text('Seperator-$index'),
                builderDelegate: PageChildBuilderDelegate(
                  itemBuilder: (context, item, index) {
                    return Text(item.toString(), key: ValueKey(item));
                  },
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final listFinder = find.byType(Scrollable);
      final itemFinder = find.text('Seperator-18');
      // Scroll until the item to be found appears.
      await tester.scrollUntilVisible(
        itemFinder,
        500.0,
        scrollable: listFinder,
      );
    });
  });

  group('Pagination Error Test', () {
    testWidgets('Should Render Error', (tester) async {
      const exception = BaseException("ERROR");
      final controller = PaginatedController<String>(
        fetchFunc: (query) async {
          return Resource.error(exception);
        },
      );
      await tester.pumpWidget(
        TestHelper.buildTestableWidget(
          PaginatedListWidget(
            controller: controller,
            builderDelegate: PageChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return Text(item.toString(), key: ValueKey(item));
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(controller.value.error, exception);
      expect(find.byType(AppErrorWidget), findsOneWidget);
    });
  });
}
