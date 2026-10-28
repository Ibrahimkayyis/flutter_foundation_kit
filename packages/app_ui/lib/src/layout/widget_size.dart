import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WidgetSizeData {
  final Size size;
  final Offset offset;

  WidgetSizeData(this.size, this.offset);
}

class WidgetSize extends StatefulWidget {
  final Widget child;
  final void Function(WidgetSizeData Function() widgetCallback)? onChange;

  const WidgetSize({super.key, this.onChange, required this.child});

  @override
  State<WidgetSize> createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<WidgetSize> {
  final widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: widgetKey, child: widget.child);
  }

  void postFrameCallback(_) {
    widget.onChange?.call(() {
      final renderBox =
          widgetKey.currentContext?.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      return WidgetSizeData(size, offset);
    });
  }
}
