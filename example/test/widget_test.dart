import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('FoundationKitExampleApp renders successfully and displays sections', (
    tester,
  ) async {
    await tester.pumpWidget(const FoundationKitExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('Flutter Foundation Kit'), findsOneWidget);
    expect(find.text('1. Design System & Typography'), findsOneWidget);
    expect(find.text('2. Universal Form Inputs'), findsOneWidget);
    expect(find.text('3. Button Variants'), findsOneWidget);
    expect(find.text('Primary Button'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
  });
}
