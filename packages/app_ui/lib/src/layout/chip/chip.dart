import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_ui/src/ext/index.dart';
import 'package:app_ui/src/style/color/color_theme.dart';
import 'package:app_ui/src/style/typography/typhography.dart';

class NTIChip extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? fontSize;

  const NTIChip({
    super.key,
    required this.label,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.fontSize,
  });
  @override
  Widget build(BuildContext context) {
    final color = this.color ?? context.colorTheme.primary1;
    final backgroundColor =
        this.backgroundColor ?? color.withAlpha((0.2 * 256).floor());
    return Container(
      padding: 8.w.horizontalPadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor ?? color),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        label,
        style: context.text.sm.applyColor(color).copyWith(fontSize: fontSize),
      ),
    );
  }
}
