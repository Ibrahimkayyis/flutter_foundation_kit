import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class ModalBottomSheetAutoRoute extends CustomRoute {
  ModalBottomSheetAutoRoute({
    required super.page,
    super.path,
    super.usesPathAsKey,
    super.guards,
    super.fullMatch,
    super.meta,
    super.maintainState,
    super.fullscreenDialog,
    super.children,
    super.title,
    super.restorationId,
    super.keepHistory,
    super.initial,
    super.transitionsBuilder,
    super.durationInMilliseconds,
    super.reverseDurationInMilliseconds,
    super.opaque,
    super.barrierDismissible,
    super.barrierLabel,
    super.barrierColor,
    double? fixedSize,
    double initialSize = .5,
    double minSize = .25,
    double maxSize = .95,
    ShapeBorder? shape,
    bool? isScrollControlled,
    bool? enableDrag,
    bool? showDragHandle,
    Color? backgroundColor,
    bool? useSafeArea,
    String? barrierOnTapHint,
  }) : super(
         customRouteBuilder: routeBuilderFactory(
           initialChildSize: fixedSize ?? initialSize,
           maxChildSize: fixedSize ?? maxSize,
           minChildSize: fixedSize ?? minSize,
           barrierColor: barrierColor,
           barrierDismissible: barrierDismissible,
           backgroundColor: backgroundColor,
           barrierLabel: barrierLabel,
           shape: shape,
           isScrollControlled: isScrollControlled,
           enableDrag: enableDrag,
           showDragHandle: showDragHandle,
           useSafeArea: useSafeArea,
           barrierOnTapHint: barrierOnTapHint,
         ),
       );

  static CustomRouteBuilder routeBuilderFactory({
    required double initialChildSize,
    required double minChildSize,
    required double maxChildSize,
    required bool barrierDismissible,
    Color? backgroundColor,
    Color? barrierColor,
    ShapeBorder? shape,
    bool? enableDrag,
    bool? showDragHandle,
    bool? isScrollControlled,
    bool? useSafeArea,
    String? barrierLabel,
    String? barrierOnTapHint,
  }) {
    return <T>(BuildContext context, Widget child, AutoRoutePage<T> page) {
      return ModalBottomSheetRoute<T>(
        backgroundColor: backgroundColor,
        isDismissible: barrierDismissible,
        modalBarrierColor: barrierColor,
        shape: shape ?? AppBottomSheet.basicBorder(),
        isScrollControlled: isScrollControlled ?? true,
        enableDrag: enableDrag ?? true,
        showDragHandle: showDragHandle,
        barrierLabel: barrierLabel,
        settings: page,
        useSafeArea: useSafeArea ?? false,
        barrierOnTapHint: barrierOnTapHint,
        builder: (context) {
          return isScrollControlled ?? true
              ? ModalDraggableSheet(
                initialChildSize: initialChildSize,
                minChildSize: minChildSize,
                maxChildSize: maxChildSize,
                child: child,
              )
              : child;
        },
      );
    };
  }
}

class ModalDraggableSheet extends StatelessWidget {
  const ModalDraggableSheet({
    super.key,
    required this.child,
    this.initialChildSize = .5,
    this.minChildSize = .25,
    this.maxChildSize = .95,
  });

  final Widget child;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      expand: false,
      builder:
          (context, ScrollController scrollController) => AppBottomSheet(
            builder: (context, header) {
              return Column(
                children: [
                  const SizedBox(height: 16),
                  header,
                  const SizedBox(height: 16),
                  Flexible(
                    child: DraggableScrollController(
                      scrollController: scrollController,
                      child: child,
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}

class DraggableScrollController extends InheritedWidget {
  const DraggableScrollController({
    super.key,
    this.scrollController,
    required super.child,
  });

  final ScrollController? scrollController;

  static ScrollController? of(BuildContext context, {bool listen = false}) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<DraggableScrollController>()
          ?.scrollController;
    }
    final widget =
        context
                .getElementForInheritedWidgetOfExactType<
                  DraggableScrollController
                >()
                ?.widget
            as DraggableScrollController?;
    return widget?.scrollController;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

mixin DraggableScrollControllerStateMixin<T extends StatefulWidget>
    on State<T> {
  ScrollController? get scrollController =>
      DraggableScrollController.of(context);
}

mixin DraggableScrollControllerMixin on StatelessWidget {
  ScrollController? getScrollController(BuildContext context) =>
      DraggableScrollController.of(context);
}
