import 'package:equatable/equatable.dart';

class PostQuery {
  final String? keywords;
  final List<Filter> filters;
  final List<Sort> sorts;

  const PostQuery({
    this.keywords = "",
    this.filters = const [],
    this.sorts = const [],
  });

  PostQuery copyWith({
    String? keywords,
    List<Filter>? filters,
    List<Sort>? sorts,
  }) => PostQuery(
    keywords: keywords ?? this.keywords,
    filters: filters ?? this.filters,
    sorts: sorts ?? this.sorts,
  );

  Map<String, dynamic> toJson() => {
    if (keywords != null) 'keyword': keywords,
    if (filters.isNotEmpty) ...{
      for (final filter in filters) filter.key: filter.value,
    },

    if (sorts.isNotEmpty)
      'sorts': sorts.map((e) => "${e.key} ${e.order.value}").join(" "),
  };
}

class PaginatedQuery extends PostQuery implements Comparable<PaginatedQuery> {
  final int? page;
  final int? size;

  static const firstPage = 1;

  const PaginatedQuery.takeAll({super.keywords, super.filters, super.sorts})
    : page = null,
      size = null;

  const PaginatedQuery({
    this.page,
    this.size,
    super.keywords,
    super.filters,
    super.sorts,
  }) : assert(page == null || page >= firstPage, "Page should be null or >= 1");

  @override
  PaginatedQuery copyWith({
    String? keywords,
    List<Filter>? filters,
    List<Sort>? sorts,
    int? page,
    int? size,
  }) {
    return PaginatedQuery(
      keywords: keywords ?? this.keywords,
      filters: filters ?? this.filters,
      page: page ?? this.page,
      size: size ?? this.size,
      sorts: sorts ?? this.sorts,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "limit": size, "page": page};
  }

  @override
  int compareTo(PaginatedQuery other) {
    return other == this ? 0 : 1;
  }
}

class Sort extends Equatable {
  final String key;
  final SortOrder order;

  const Sort({required this.key, required this.order});

  Sort copyWith({String? key, SortOrder? order}) =>
      Sort(key: key ?? this.key, order: order ?? this.order);

  Map<String, dynamic> toJson() => {'key': key, 'order': order.value};

  @override
  List<Object?> get props => [key, order];
}

class Filter {
  final String key;
  final FilterOperator operator;
  final dynamic value;
  final dynamic toValue;

  Filter({
    required this.key,
    required this.operator,
    required this.value,
    this.toValue,
  });

  Map<String, dynamic> toJson() => {
    'key': key,
    'operator': operator.value,
    'value': value,
  };
}

enum SortOrder {
  asc('asc'),
  desc('desc');

  final String value;
  const SortOrder(this.value);
}

enum FilterOperator {
  equal('EQUAL'),
  not('NOT'),
  notEqual('NOT_EQUAL'),
  greaterThan('GREATER_THAN'),
  lessThan('LESS_THAN'),
  greaterThanOrEqual('GREATER_THAN_OR_EQUAL'),
  lessThanOrEqual('LESS_THAN_OR_EQUAL'),
  iLike('ILIKE'),
  isSet('IS_SET'),
  isNotSet('IS_NOT_SET'),
  inValues('IN'),
  between('BETWEEN');

  final String value;

  const FilterOperator(this.value);
}
