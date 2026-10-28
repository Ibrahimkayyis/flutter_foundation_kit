part of 'pagination.dart';

mixin _PaginationMixin<T, Impl extends _BasePagination<T>> on State<Impl> {
  late PaginatedController<T> _controller;

  PaginatedQuery buildQuery(PaginatedQuery query) => query;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        PaginatedController(
          fetchFunc:
              widget.fetchFunc != null
                  ? (query) => widget.fetchFunc!.call(buildQuery(query))
                  : (query) => Future.value(Success(Paginated.emptyList(), "")),
          initialPaginated: widget.initialPaginated,
        );
  }
}
