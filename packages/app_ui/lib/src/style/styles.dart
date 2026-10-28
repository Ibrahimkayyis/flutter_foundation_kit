import 'package:flutter/material.dart';
import 'color/color_theme.dart';
import 'typography/typhography.dart';

export 'color/color_theme.dart';
export 'typography/typhography.dart';

class AppInputDecoration {
  static const radius = BorderRadius.all(Radius.circular(8));

  static const padding = EdgeInsets.fromLTRB(16, 20, 16, 20);

  static InputDecoration inputDecoration(
    BuildContext context, {
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? hintText,
    TextStyle? hintStyle,
    String? prefixText,
    int? errorMaxLines,
    String? suffixText,
    bool showBorder = true,
    bool enabled = true,
    TextStyle? prefixStyle,
    bool isFilled = true,
    EdgeInsets? padding,
    Color? fillColor,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: hintText,
      errorMaxLines: errorMaxLines,
      hintStyle:
          hintStyle ??
          context.text.base.applyColor(context.colorTheme.basic7Reverse),
      prefixText: prefixText,
      suffixText: suffixText,
      filled: isFilled,
      fillColor: enabled ? fillColor : context.colorTheme.basic4Reverse,
      isDense: true,
      prefixStyle: prefixStyle,
      contentPadding: padding,
      errorStyle: TextStyle(color: context.colorTheme.accent12Reverse),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide:
            showBorder
                ? BorderSide(
                  color:
                      isFilled
                          ? context.colorTheme.basic5Reverse
                          : Colors.transparent,
                  width: 1,
                )
                : BorderSide.none,
      ),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide:
            showBorder
                ? BorderSide(color: context.colorTheme.primary12Reverse)
                : BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide:
            showBorder
                ? BorderSide(color: context.colorTheme.primary12Reverse)
                : BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: context.colorTheme.accent12Reverse),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide:
            showBorder
                ? BorderSide(color: context.colorTheme.accent12Reverse)
                : BorderSide.none,
      ),
    );
  }
}


typedef NTIInputDecoration = AppInputDecoration;
