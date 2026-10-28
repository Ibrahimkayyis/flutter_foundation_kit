import 'package:equatable/equatable.dart';
import 'package:app_types/src/json.dart';

typedef PaginatedList<T> = Paginated<List<T>>;

class Paginated<T> {
  final T data;
  final Pagination pagination;

  Paginated({required this.data, required this.pagination});

  static Paginated<List<T>> emptyList<T>() {
    return Paginated<List<T>>(
      data: [],
      pagination: const Pagination(total: 0, size: 0, totalPage: 0, current: 0),
    );
  }

  // Create Paginated List and make it as last page
  static Paginated<List<T>> fromList<T>(
    List<T> list, {
    int? total,
    int? current,
    int? totalPage,
    int? size,
  }) {
    return Paginated(
      data: list,
      pagination: Pagination(
        total: total ?? list.length,
        size: size ?? list.length,
        totalPage: totalPage ?? 1,
        current: current ?? 1,
      ),
    );
  }

  Future<Paginated<Y>> map<Y>(Y Function(T) mapper) async {
    return Paginated(data: mapper(data), pagination: pagination);
  }

  factory Paginated.resultMapper(JSON json, T data) {
    return Paginated(data: data, pagination: Pagination.fromJson(json));
  }
}

class Pagination extends Equatable implements Comparable<Pagination> {
  final int total;
  final int size;
  final int totalPage;
  final int current;

  const Pagination({
    required this.total,
    required this.size,
    required this.totalPage,
    required this.current,
  });

  factory Pagination.fromJson(JSON json) {
    if (json is! Map) {
      return const Pagination(total: 0, size: 0, totalPage: 0, current: 0);
    }
    return Pagination(
      total: (json['total_records'] ?? json['total'] ?? json['count'] ?? 0) as int,
      size: (json['per_page'] ?? json['size'] ?? json['limit'] ?? 0) as int,
      totalPage: (json['total_pages'] ?? json['total_page'] ?? json['last_page'] ?? 0) as int,
      current: (json['current_page'] ?? json['current'] ?? json['page'] ?? 1) as int,
    );
  }

  Pagination copyWith({int? total, int? size, int? totalPage, int? current}) =>
      Pagination(
        total: total ?? this.total,
        size: size ?? this.size,
        totalPage: totalPage ?? this.totalPage,
        current: current ?? this.current,
      );

  bool get hasNextPage => current < totalPage;
  bool get hasPreviousPage => current > 1;

  @override
  int compareTo(Pagination other) {
    return other == this ? 0 : 1;
  }

  @override
  List<Object?> get props => [total, size, totalPage, current];
}
