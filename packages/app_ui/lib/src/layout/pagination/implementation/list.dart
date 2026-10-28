part of '../pagination.dart';

abstract class _BasePaginatedList<T> extends _BasePagination<T> {
  final PageChildBuilderDelegate<T> builderDelegate;
  final IndexedWidgetBuilder? separatorBuilder;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? itemExtent;

  const _BasePaginatedList({
    super.key,
    super.fetchFunc,
    super.controller,
    super.initialPaginated,
    this.separatorBuilder,
    required this.builderDelegate,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.itemExtent,
  });
}

class PaginatedListWidget<T> extends _BasePaginatedList<T> {
  final double? cacheExtent;
  final Clip clipBehavior;
  final bool shrinkWrap;
  final DragStartBehavior dragStartBehavior;
  final ScrollPhysics? physics;
  final ScrollController? scrollController;
  final Axis scrollDirection;
  final bool reverse;
  final EdgeInsets padding;
  final bool? primary;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;

  const PaginatedListWidget({
    super.key,
    super.fetchFunc,
    super.controller,
    super.initialPaginated,
    super.separatorBuilder,
    required super.builderDelegate,
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    super.itemExtent,
    this.cacheExtent,
    this.clipBehavior = Clip.hardEdge,
    this.shrinkWrap = false,
    this.dragStartBehavior = DragStartBehavior.start,
    this.physics,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.padding = const EdgeInsets.all(0),
    this.primary,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
  });

  @override
  State<PaginatedListWidget<T>> createState() => _PaginatedListState<T>();
}

class _PaginatedListState<T> extends State<PaginatedListWidget<T>>
    with
        _PaginationMixin<T, PaginatedListWidget<T>>,
        _PaginationList<T, PaginatedListWidget<T>> {
  @override
  Widget build(BuildContext context) {
    final separatorBuilder = widget.separatorBuilder;
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, state, _) {
        return separatorBuilder != null
            ? PagedListView.separated(
              state: state,
              fetchNextPage: _controller.fetchPage,
              separatorBuilder: separatorBuilder,
              builderDelegate: _pagedChildBuilderDelegate(_controller),
              addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
              addRepaintBoundaries: widget.addRepaintBoundaries,
              addSemanticIndexes: widget.addSemanticIndexes,
              itemExtent: widget.itemExtent,
              cacheExtent: widget.cacheExtent,
              clipBehavior: widget.clipBehavior,
              shrinkWrap: widget.shrinkWrap,
              dragStartBehavior: widget.dragStartBehavior,
              physics: widget.physics,
              keyboardDismissBehavior: widget.keyboardDismissBehavior,
              reverse: widget.reverse,
              padding: widget.padding,
              primary: widget.primary,
              restorationId: widget.restorationId,
              scrollController: widget.scrollController,
              scrollDirection: widget.scrollDirection,
            )
            : PagedListView(
              state: state,
              fetchNextPage: _controller.fetchPage,
              builderDelegate: _pagedChildBuilderDelegate(_controller),
              addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
              addRepaintBoundaries: widget.addRepaintBoundaries,
              addSemanticIndexes: widget.addSemanticIndexes,
              itemExtent: widget.itemExtent,
              cacheExtent: widget.cacheExtent,
              clipBehavior: widget.clipBehavior,
              shrinkWrap: widget.shrinkWrap,
              dragStartBehavior: widget.dragStartBehavior,
              physics: widget.physics,
              keyboardDismissBehavior: widget.keyboardDismissBehavior,
              reverse: widget.reverse,
              padding: widget.padding,
              primary: widget.primary,
              restorationId: widget.restorationId,
              scrollController: widget.scrollController,
              scrollDirection: widget.scrollDirection,
            );
      },
    );
  }
}

class PaginatedSliverListWidget<T> extends _BasePaginatedList<T> {
  final bool shrinkWrapFirstPageIndicators;
  final int? Function(Widget, int)? semanticIndexCallback;
  const PaginatedSliverListWidget({
    super.key,
    super.fetchFunc,
    super.controller,
    super.initialPaginated,
    super.separatorBuilder,
    required super.builderDelegate,
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    super.itemExtent,
    this.shrinkWrapFirstPageIndicators = false,
    this.semanticIndexCallback,
  });

  @override
  State<PaginatedSliverListWidget<T>> createState() =>
      _PaginatedSliverListState<T>();
}

class _PaginatedSliverListState<T> extends State<PaginatedSliverListWidget<T>>
    with
        _PaginationMixin<T, PaginatedSliverListWidget<T>>,
        _PaginationList<T, PaginatedSliverListWidget<T>> {
  @override
  Widget build(BuildContext context) {
    final seperatorBuilder = widget.separatorBuilder;

    return ValueListenableBuilder(
      valueListenable: _controller,
      builder:
          (context, state, _) =>
              seperatorBuilder != null
                  ? PagedSliverList.separated(
                    state: state,
                    separatorBuilder: seperatorBuilder,
                    fetchNextPage: _controller.fetchPage,
                    builderDelegate: _pagedChildBuilderDelegate(_controller),
                    addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                    addRepaintBoundaries: widget.addRepaintBoundaries,
                    addSemanticIndexes: widget.addSemanticIndexes,
                    itemExtent: widget.itemExtent,
                    semanticIndexCallback: widget.semanticIndexCallback,
                    shrinkWrapFirstPageIndicators:
                        widget.shrinkWrapFirstPageIndicators,
                  )
                  : PagedSliverList(
                    state: state,
                    fetchNextPage: _controller.fetchPage,
                    builderDelegate: _pagedChildBuilderDelegate(_controller),
                    addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                    addRepaintBoundaries: widget.addRepaintBoundaries,
                    addSemanticIndexes: widget.addSemanticIndexes,
                    itemExtent: widget.itemExtent,
                    semanticIndexCallback: widget.semanticIndexCallback,
                    shrinkWrapFirstPageIndicators:
                        widget.shrinkWrapFirstPageIndicators,
                  ),
    );
  }
}

mixin _PaginationList<T, Impl extends _BasePaginatedList<T>> on State<Impl> {
  PagedChildBuilderDelegate<T> _pagedChildBuilderDelegate(
    PaginatedController<T> controller,
  ) => PagedChildBuilderDelegate(
    itemBuilder: widget.builderDelegate.itemBuilder,
    animateTransitions: widget.builderDelegate.animateTransitions,
    firstPageErrorIndicatorBuilder: (context) {
      final firstPageErrorBuilder =
          widget.builderDelegate.firstPageErrorBuilder;
      final error =
          controller.value.error is BaseException
              ? controller.value.error as BaseException
              : BaseException.unknownError();
      if (firstPageErrorBuilder != null) {
        return firstPageErrorBuilder.call(context, error);
      }
      return Padding(
        padding: 16.topPadding,
        child: AppErrorWidget.fromException(
          error,
          isCenter: false,
          onTryAgain: (_) => controller.refresh(),
        ),
      );
    },
    firstPageProgressIndicatorBuilder:
        widget.builderDelegate.firstPageProgressIndicatorBuilder,
    newPageErrorIndicatorBuilder:
        widget.builderDelegate.newPageErrorIndicatorBuilder,
    newPageProgressIndicatorBuilder:
        widget.builderDelegate.newPageProgressIndicatorBuilder,
    noItemsFoundIndicatorBuilder:
        widget.builderDelegate.noItemsFoundIndicatorBuilder,
    noMoreItemsIndicatorBuilder:
        widget.builderDelegate.noMoreItemsIndicatorBuilder,
    transitionDuration: widget.builderDelegate.transitionDuration,
  );
}
