import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class NTIPopover extends StatelessWidget {
  const NTIPopover({super.key, required this.content, required this.child});

  final Widget content;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => content,
          direction: PopoverDirection.bottom,
          backgroundColor: Colors.white,
          width: 360,
          height: 160,
          arrowHeight: 15,
          arrowWidth: 30,
        );
      },
    );
  }
}
