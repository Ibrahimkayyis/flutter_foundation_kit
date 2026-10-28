import 'package:flutter/material.dart';

class ColorUtils {
  static Color parseFromString(String color) {
    try {
      final cleanedHex = color.replaceAll("#", "ff");
      final hextToInteger = int.parse(cleanedHex, radix: 16);
      return Color(hextToInteger);
    } catch (e) {
      return Colors.transparent;
    }
  }
}
