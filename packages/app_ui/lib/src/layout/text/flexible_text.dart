import 'package:flutter/material.dart';
import 'package:app_ui/src/style/styles.dart';

enum FlexInfoBehaviour { row, column, adaptive }

class FlexInfoWidget extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? contentWidget;
  final double? spacing;
  final double? titleFontSize;
  final double? itemFontSize;
  final bool isFitted;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final FlexInfoBehaviour behaviour;

  const FlexInfoWidget({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    this.titleStyle,
    this.contentStyle,
    this.isFitted = false,
    this.spacing,
    this.titleFontSize,
    this.itemFontSize,
    this.behaviour = FlexInfoBehaviour.adaptive,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    final titleFinalWidget = Text(
      title,
      style:
          titleStyle ??
          context.text.base.copyWith(
            fontSize: titleFontSize,
            color: color.basic6,
          ),
    );
    final descFinalWidget =
        (contentWidget ??
            (content != null
                ? Text(
                  content!,
                  style:
                      contentStyle ??
                      context.text.base.copyWith(
                        fontSize: itemFontSize,
                        color: color.basic3,
                      ),
                )
                : const SizedBox()));
    switch (behaviour) {
      case FlexInfoBehaviour.row:
        return Row(
          children: [
            titleFinalWidget,
            SizedBox(width: spacing ?? 8.0),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: descFinalWidget,
              ),
            ),
          ],
        );
      case FlexInfoBehaviour.column:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleFinalWidget,
            SizedBox(height: spacing ?? 8.0),
            descFinalWidget,
          ],
        );
      case FlexInfoBehaviour.adaptive:
        return Wrap(
          spacing: spacing ?? 8.0,
          runSpacing: spacing ?? 8.0,
          alignment: WrapAlignment.spaceBetween,
          children: [titleFinalWidget, descFinalWidget],
        );
    }
  }
}
