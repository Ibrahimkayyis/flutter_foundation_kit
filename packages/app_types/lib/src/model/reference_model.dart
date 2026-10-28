import 'package:equatable/equatable.dart';

class ReferenceModel extends Equatable {
  final int id;
  final String name;
  final String displayName;

  const ReferenceModel({
    required this.id,
    required this.name,
    String? displayName,
  }) : displayName = displayName ?? name;

  factory ReferenceModel.fromJson(Map<String, dynamic> json) => ReferenceModel(
    id: json['id'] as int? ?? 0,
    name: json['name'] as String? ?? '',
    displayName: json['display_name'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'display_name': displayName,
  };

  @override
  List<Object?> get props => [id, name, displayName];
}
