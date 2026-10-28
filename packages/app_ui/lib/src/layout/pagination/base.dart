part of 'pagination.dart';

abstract class _BasePagination<T> extends StatefulWidget {
  final PaginatedData initialPaginated;
  final Future<Resource<PaginatedList<T>>> Function(PaginatedQuery query)?
  fetchFunc;
  final PaginatedController<T>? controller;

  const _BasePagination({
    super.key,
    this.fetchFunc,
    this.initialPaginated = const PaginatedData(),
    this.controller,
  });
}
