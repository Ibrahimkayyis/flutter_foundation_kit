part of '../pagination.dart';

class PaginatedTable<T> extends _BasePagination<T> {
  final List<TableColumn<T>> columns;
  final EdgeInsets? loadingPadding;

  const PaginatedTable({
    super.key,
    required this.columns,
    super.controller,
    super.initialPaginated,
    super.fetchFunc,
    this.loadingPadding,
  });

  @override
  State<PaginatedTable<T>> createState() => _PaginatedTableState<T>();
}

class _PaginatedTableState<T> extends State<PaginatedTable<T>>
    with _PaginationMixin<T, PaginatedTable<T>> {
  late int _currentPage;
  List<T> _currentList = [];
  int _currentIndex = -1;
  Sort? _sortData;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_pageListener);
    _currentPage = _controller.initialPaginated.page;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.fetchPage();
    });
  }

  _pageListener() {
    _currentIndex =
        _pagingState.isLoading
            ? _currentIndex
            : (_pagingState.keys?.indexWhere((e) => e.page == _currentPage) ??
                -1);
    _currentList =
        _pagingState.isLoading ? _currentList : _pageByIndex(_currentIndex);
    setState(() {});
  }

  PagingState<PaginatedData, T> get _pagingState => _controller.value;

  List<T> _pageByIndex(int index) {
    if (index == -1) return [];
    return _pagingState.pages?[index] ?? [];
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onFetchPage(int newPage) {
    final currentKeys = _pagingState.keys;
    if (newPage < 1) return;
    final isNewPageValid =
        currentKeys != null &&
        currentKeys.isNotEmpty &&
        (currentKeys.last.totalPage ?? 0) >= newPage;
    if (newPage > 1 && !isNewPageValid) return;
    _currentPage = newPage;
    if (isPageFetched(_currentPage)) {
      _pageListener();
      return;
    }
    _controller.fetchPage(
      tobeFetched: _controller.initialPaginated.copyWith(page: _currentPage),
    );
  }

  bool isPageFetched(int page) {
    final index = _pagingState.keys?.indexWhere((e) => e.page == page);
    if (index == null || index == -1) return false;
    return _pagingState.pages?[index] != null;
  }

  void _onSort(String sortKey) {
    _sortData = Sort(
      key: sortKey,
      order: _sortData?.order == SortOrder.asc ? SortOrder.desc : SortOrder.asc,
    );
    _controller.refresh();
    // _onFetchPage(_currentPage);
  }

  @override
  PaginatedQuery buildQuery(PaginatedQuery query) {
    return query.copyWith(sorts: [if (_sortData != null) _sortData!]);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    final currentKeys = _pagingState.keys;
    if (currentKeys == null || currentKeys.isEmpty) {
      if (_pagingState.isLoading) {
        return Padding(
          padding: widget.loadingPadding ?? EdgeInsets.all(16.r),
          child: const Center(child: NTICircularLoading(radius: 16)),
        );
      }
    }
    final error = _pagingState.error;
    return Stack(
      children: [
        Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(color.basic12),
                columns:
                    widget.columns
                        .map(
                          (e) => DataColumn(
                            label: InkWell(
                              onTap:
                                  e.sortKey != null
                                      ? () => _onSort(e.sortKey!)
                                      : null,
                              child: Row(
                                children: [
                                  Text(e.title, style: context.text.base.bold),
                                  if (_sortData?.key == e.sortKey)
                                    Builder(
                                      builder: (context) {
                                        final sortData = _sortData;
                                        if (sortData == null) {
                                          return const SizedBox();
                                        }
                                        return Icon(
                                          sortData.order == SortOrder.asc
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          size: 16.r,
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                rows:
                    _currentList.mapIndexed((index, e) {
                      final key = currentKeys?[_currentIndex];
                      final pageSize = key?.size ?? 0;
                      final currentPage = key?.page ?? 0;
                      return DataRow(
                        color: WidgetStateProperty.all(
                          index.isEven ? color.basic10 : color.basic12,
                        ),
                        cells:
                            widget.columns
                                .mapIndexed(
                                  (cellIndex, column) => DataCell(
                                    column.builder(
                                      context,
                                      e,
                                      ((currentPage - 1) * pageSize) + (index),
                                    ),
                                  ),
                                )
                                .toList(),
                      );
                    }).toList(),
              ),
            ),
            if (error != null)
              Container(
                color: color.basic12,
                padding: (16.w, 16.h).padding,
                child: AppErrorWidget.fromException(
                  error is BaseException ? error : BaseException.unknownError(),
                  onTryAgain: (_) => _onFetchPage(_currentPage),
                ),
              ),
            _Footer(
              state: _pagingState,
              currentPage: _currentPage,
              onPreviousPage: () => _onFetchPage(_currentPage - 1),
              onNextPage: () => _onFetchPage(_currentPage + 1),
              onRefresh: () => _controller.refresh(),
            ),
          ],
        ),
        Positioned.fill(
          child:
              _pagingState.isLoading
                  ? const NTILoadingOverlay()
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _Footer<T> extends StatelessWidget {
  final int currentPage;
  final Function() onPreviousPage;
  final Function() onNextPage;
  final Function() onRefresh;
  final PagingState<PaginatedData, T> state;
  const _Footer({
    super.key,
    required this.currentPage,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.state,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return NTIFooterContainer(
      child: Builder(
        builder: (context) {
          final key = state.keys?.lastOrNull;
          if (key == null) return const SizedBox.shrink();
          return Row(
            children: [
              Expanded(
                child:
                    state.isLoading
                        ? const SizedBox()
                        : Row(
                          children: [
                            Text(
                              "${(currentPage - 1) * key.size + 1}-${(currentPage * key.size).clamp(0, key.totalItem!)} of ${key.totalItem}",
                            ),
                            InkWell(
                              onTap: () => onRefresh(),
                              child: Padding(
                                padding: 8.leftPadding,
                                child: const AppIcon(AppIcons.refresh, height: 16),
                              ),
                            ),
                          ],
                        ),
              ),
              if (!state.isLoading)
                Row(
                  children: [
                    InkWell(
                      onTap: onPreviousPage,
                      child: Icon(Icons.arrow_back_ios, size: 16.r),
                    ),
                    16.horizontalSpace,
                    InkWell(
                      onTap: onNextPage,
                      child: Icon(Icons.arrow_forward_ios, size: 16.r),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class TableColumn<T> {
  final String? id;
  final String? sortKey;
  final String title;
  final Widget Function(BuildContext context, T data, int index) builder;

  const TableColumn({
    this.id,
    required this.title,
    required this.builder,
    this.sortKey,
  });
}

extension _IterableExt<T> on Iterable<T> {
  Iterable<Y> mapIndexed<Y>(Y Function(int index, T item) mapper) {
    return Iterable.generate(
      length,
      (index) => mapper(index, elementAt(index)),
    );
  }
}
