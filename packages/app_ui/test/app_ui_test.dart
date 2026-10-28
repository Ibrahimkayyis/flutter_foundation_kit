import 'package:flutter_test/flutter_test.dart';
import 'package:app_ui/app_ui.dart';

void main() {
  test('app_ui exports can be loaded', () {
    expect(ButtonSize.defaultSize, isNotNull);
    expect(ButtonType.primary, isNotNull);
  });
}
