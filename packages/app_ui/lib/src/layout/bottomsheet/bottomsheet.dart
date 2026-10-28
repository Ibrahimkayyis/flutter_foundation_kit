import 'package:flutter/material.dart';
import 'package:app_ui/src/icon/nti_icon/icon.dart';
import 'package:app_ui/src/style/styles.dart';

part 'header.dart';
part 'expanded.dart';
part 'scrollable.dart';
part 'list_tile.dart';

class NTIBottomSheet extends StatelessWidget {
  static ShapeBorder basicBorder({double? radius}) => RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(radius ?? 16)),
  );

  final Widget Function(BuildContext context, Widget header) builder;
  final Size? headerSize;
  final Color? headerColor;
  const NTIBottomSheet({
    super.key,
    required this.builder,
    this.headerSize,
    this.headerColor,
  });

  static Future<dynamic> launchDraggable(
    BuildContext context, {
    required Widget child,
    double maxChildSize = .7,
    double minChildSize = .25,
    double initialChildSize = .5,
    bool expand = false,
    Size? headerSize = const Size(56, 6),
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 24,
    ),
    Color? headerColor,
  }) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: NTIBottomSheet.basicBorder(),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          expand: expand,
          maxChildSize: maxChildSize,
          minChildSize: minChildSize,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: padding,
                child: NTIBottomSheet(
                  headerColor: headerColor,
                  headerSize: headerSize,
                  builder: (context, header) {
                    return Column(children: [header, child]);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      _BottomSheetHeader(size: headerSize, color: headerColor),
    );
  }
}


typedef AppBottomSheet = NTIBottomSheet;
