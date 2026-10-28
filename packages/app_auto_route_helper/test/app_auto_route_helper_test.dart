import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_ui/test_helper.dart';
import 'package:app_auto_route_helper/app_auto_route_helper.dart';

class _TestConsumerWidget extends StatelessWidget {
  const _TestConsumerWidget();

  @override
  Widget build(BuildContext context) {
    final controller = DraggableScrollController.of(context);
    return Text(controller != null ? 'FoundController' : 'NoController');
  }
}

class _TestStatelessWithMixin extends StatelessWidget
    with DraggableScrollControllerMixin {
  const _TestStatelessWithMixin();

  @override
  Widget build(BuildContext context) {
    final controller = getScrollController(context);
    return Text(controller != null ? 'MixinFound' : 'MixinNotFound');
  }
}

void main() {
  testWidgets('DraggableScrollController provides controller to descendants', (
    tester,
  ) async {
    final scrollController = ScrollController();

    await tester.pumpWidget(
      TestHelper.buildTestableWidget(
        DraggableScrollController(
          scrollController: scrollController,
          child: const Column(
            children: [
              _TestConsumerWidget(),
              _TestStatelessWithMixin(),
            ],
          ),
        ),
      ),
    );

    expect(find.text('FoundController'), findsOneWidget);
    expect(find.text('MixinFound'), findsOneWidget);
    scrollController.dispose();
  });

  testWidgets('ModalDraggableSheet renders scrollable child correctly', (
    tester,
  ) async {
    await tester.pumpWidget(
      TestHelper.buildTestableWidget(
        Scaffold(
          body: ModalDraggableSheet(
            child: Builder(
              builder: (context) {
                return ListView(
                  controller: DraggableScrollController.of(context),
                  children: const [Text('ModalSheetContent')],
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('ModalSheetContent'), findsOneWidget);
  });
}
