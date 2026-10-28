import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_ui/nti_ui.dart';

void main() {
  group('ColorUtils', () {
    // parseFromString returns correct color for valid hex string
    // Given : A valid hex color string
    // When : The parseFromString method is called
    // Expected : The correct Color object is returned
    test('parseFromString returns correct color for valid hex string', () {
      const hexColor = '#ffffff';
      final color = ColorUtils.parseFromString(hexColor);
      expect(color, equals(const Color(0xffffffff)));
    });

    // parseFromString returns transparent color for invalid hex string
    // Given : An invalid hex color string
    // When : The parseFromString method is called
    // Expected : A transparent Color object is returned
    test(
      'parseFromString returns transparent color for invalid hex string',
      () {
        const invalidHexColor = 'invalid';
        final color = ColorUtils.parseFromString(invalidHexColor);
        expect(color, equals(Colors.transparent));
      },
    );
  });
}
