import 'package:flutter/widgets.dart';

class SimpleInherited<T> extends InheritedWidget {
  final T data;

  const SimpleInherited({super.key, required this.data, required super.child});

  static T of<T>(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<SimpleInherited<T>>();
    assert(widget != null, 'No SimpleInherited<$T> found in context');
    return widget!.data;
  }

  static T? mayBeOf<T>(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<SimpleInherited<T>>();
    return widget?.data;
  }

  @override
  bool updateShouldNotify(SimpleInherited<T> oldWidget) =>
      data != oldWidget.data;
}
