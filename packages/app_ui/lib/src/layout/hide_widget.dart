import 'package:flutter/material.dart';

class NTIHideWidget extends StatelessWidget {
  final Widget child;
  final bool hide;
  const NTIHideWidget({super.key, required this.child, this.hide = true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      maintainAnimation: true,
      maintainSize: true,
      visible: !hide,
      maintainState: true,
      child: child,
    );
  }
}
