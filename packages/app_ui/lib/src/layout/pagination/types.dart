part of 'pagination.dart';

typedef PaginatedNoKeyItemBuilder<ItemType> =
    Widget Function(BuildContext context, ItemType item, int index);

typedef PaginatedItemBuilder<ItemType> =
    Widget Function(BuildContext context, ItemType item, int index, Key? key);

typedef PaginatedWrapperBuilder<ItemType> =
    Widget Function(
      BuildContext context,
      Widget child,
      ItemType item,
      int index,
      Key? key,
    );

class PaginatedData extends Equatable implements Comparable<PaginatedData> {
  final int page;
  final int size;
  final int? totalPage;
  final int? totalItem;

  const PaginatedData({
    this.page = PaginatedQuery.firstPage,
    this.size = 10,
    this.totalPage,
    this.totalItem,
  });

  PaginatedData copyWith({
    int? page,
    int? size,
    int? totalPage,
    int? totalItem,
  }) => PaginatedData(
    page: page ?? this.page,
    size: size ?? this.size,
    totalPage: totalPage ?? this.totalPage,
    totalItem: totalItem ?? this.totalItem,
  );

  PaginatedQuery toQuery() {
    return PaginatedQuery(page: page, size: size);
  }

  @override
  List<Object?> get props => [page, size, totalPage, totalItem];

  @override
  int compareTo(PaginatedData other) {
    return other == this ? 0 : 1;
  }
}

class PageChildBuilderDelegate<T> extends PagedChildBuilderDelegate<T> {
  final Widget Function(BuildContext context, BaseException exception)?
  firstPageErrorBuilder;
  PageChildBuilderDelegate({
    super.animateTransitions,
    this.firstPageErrorBuilder,
    required super.itemBuilder,
    super.firstPageProgressIndicatorBuilder,
    super.newPageErrorIndicatorBuilder,
    super.newPageProgressIndicatorBuilder,
    super.noItemsFoundIndicatorBuilder,
    super.noMoreItemsIndicatorBuilder,
    super.transitionDuration,
  });
}
