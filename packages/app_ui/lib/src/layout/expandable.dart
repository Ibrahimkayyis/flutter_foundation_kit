import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:app_ui/src/layout/widget_size.dart';
import 'package:app_ui/src/style/styles.dart';

class ExpandableContent {
  final Widget child;
  final String title;

  ExpandableContent({required this.child, required this.title});
}

class ExpandableWidget extends StatefulWidget {
  final List<ExpandableContent> list;
  final ScrollController? scrollController;
  final double topPadding;
  const ExpandableWidget({
    super.key,
    required this.list,
    this.scrollController,
    this.topPadding = 100,
  });

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _SizeData {
  final WidgetSizeData Function()? body;
  final WidgetSizeData Function()? header;

  _SizeData({this.body, this.header});
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  final Map<int, _SizeData> _childSizes = {};
  int? _openedIndex;
  late double _appBarSize;

  @override
  void initState() {
    super.initState();
    _appBarSize = AppBar().preferredSize.height;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.basic8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: ExpansionPanelList(
          expandIconColor: color.basic3,
          dividerColor: color.basic8,
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 4,
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              _openedIndex = panelIndex == _openedIndex ? null : panelIndex;
            });
            if (isExpanded) return;
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
              final scrollController = widget.scrollController;
              final childSize = _childSizes[panelIndex];
              final headerSizeCallback = childSize?.header;
              final bodySizeCallback = childSize?.body;
              if (scrollController == null ||
                  headerSizeCallback == null ||
                  bodySizeCallback == null) {
                return;
              }
              await Future.delayed(const Duration(milliseconds: 200));
              final headerSize = headerSizeCallback();
              final topOffset = headerSize.offset.dy - headerSize.size.height;
              final extraTopPadding = _appBarSize + widget.topPadding;
              final newOffset =
                  scrollController.offset + topOffset - extraTopPadding;
              scrollController.animateTo(
                newOffset,
                duration: const Duration(milliseconds: 250),
                curve: Curves.linear,
              );
            });
          },
          children:
              widget.list
                  .mapIndexed(
                    (i, e) => ExpansionPanel(
                      isExpanded: i == _openedIndex,
                      canTapOnHeader: true,
                      headerBuilder: (context, isExpanded) {
                        return WidgetSize(
                          onChange: (widgetSizeCallback) {
                            final oldWidgetSize = _childSizes[i] ?? _SizeData();
                            _childSizes[i] = _SizeData(
                              header: widgetSizeCallback,
                              body: oldWidgetSize.body,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            child: Text(
                              e.title,
                              style: context.text.base.copyWith(
                                fontWeight:
                                    isExpanded
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color: color.basic3,
                              ),
                            ),
                          ),
                        );
                      },
                      body: WidgetSize(
                        onChange: (widgetSizeCallback) {
                          final oldWidgetSize = _childSizes[i] ?? _SizeData();
                          _childSizes[i] = _SizeData(
                            body: widgetSizeCallback,
                            header: oldWidgetSize.header,
                          );
                        },
                        child: Column(
                          children: [
                            Divider(thickness: 2, color: color.basic8),
                            e.child,
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

extension _ListExt<T> on Iterable<T> {
  Iterable<Y> mapIndexed<Y>(Y Function(int index, T item) f) {
    return Iterable.generate(length, (index) => f(index, elementAt(index)));
  }
}
