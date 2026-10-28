import 'package:flutter/material.dart';
import 'package:app_ui/src/style/styles.dart';

class NTIFooterContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const NTIFooterContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    return Container(
      padding:
          padding ??
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ).copyWith(bottom: 24),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.colorTheme.basic4Reverse,
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, .5), // changes position of shadow
          ),
        ],
        color: color.basic1Reverse,
      ),
      child: child,
    );
  }
}
