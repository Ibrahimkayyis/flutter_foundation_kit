import 'package:equatable/equatable.dart';

class SelectionModel extends Equatable {
  final String string;
  final String value;
  final List<SelectionListItemModel> list;

  const SelectionModel({
    required this.string,
    required this.value,
    required this.list,
  });

  factory SelectionModel.fromJson(Map<String, dynamic> json) {
    final list = (json['list'] ?? []) as List<dynamic>;
    return SelectionModel(
      string: json['string'] as String? ?? '',
      value: json['value'] as String? ?? '',
      list: list
          .whereType<Map<String, dynamic>>()
          .map((e) => SelectionListItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'string': string,
    'value': value,
    'list': list.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [string, value, list];
}

class SelectionListItemModel extends Equatable {
  final String string;
  final String value;

  const SelectionListItemModel({required this.string, required this.value});

  factory SelectionListItemModel.fromJson(Map<String, dynamic> json) {
    return SelectionListItemModel(
      string: json['string'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'string': string,
    'value': value,
  };

  @override
  List<Object?> get props => [string, value];
}
