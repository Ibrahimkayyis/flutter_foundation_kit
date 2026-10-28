part of 'pagination.dart';

class PaginatedController<T>
    extends ValueNotifier<PagingState<PaginatedData, T>> {
  final PaginatedData initialPaginated;
  final Future<Resource<Paginated<List<T>>>> Function(PaginatedQuery query)
  fetchFunc;

  PaginatedController({
    required this.fetchFunc,
    this.initialPaginated = const PaginatedData(),
  }) : super(PagingState());

  PagingState<PaginatedData, T> _toggleLoading(bool isLoading) =>
      value.copyWith(isLoading: isLoading);

  bool get _shouldFetchMore => !value.isLoading && value.hasNextPage;

  void refresh() {
    value = value.reset();
    fetchPage();
  }

  PaginatedData _buildNewkey(PaginatedData? oldKey) {
    if (oldKey == null) return initialPaginated;
    return oldKey.copyWith(page: oldKey.page + 1, totalPage: oldKey.totalPage);
  }

  Future<void> fetchPage({PaginatedData? tobeFetched}) async {
    if (!_shouldFetchMore) return;
    value = _toggleLoading(true);
    final newKey = tobeFetched ?? _buildNewkey(value.keys?.lastOrNull);
    final result = await fetchFunc(newKey.toQuery());
    assert(ChangeNotifier.debugAssertNotDisposed(this));
    switch (result) {
      case Success<Paginated<List<T>>>():
        final pagination = result.data.pagination;
        final list = result.data.data;
        final isLastPage = pagination.current >= pagination.totalPage;
        final currentValue = value;
        value = currentValue.copyWith(
          isLoading: false,
          hasNextPage: !isLastPage,
          error: null,
          keys: [
            ...?currentValue.keys,
            newKey.copyWith(
              totalPage: pagination.totalPage,
              totalItem: pagination.total,
            ),
          ],
          pages: [...?currentValue.pages, list],
        );
      case Error<Paginated<List<T>>>():
        value = value.copyWith(error: result.exception, isLoading: false);
    }
  }
}
