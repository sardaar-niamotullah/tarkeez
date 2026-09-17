import 'package:equatable/equatable.dart';

class ProjectModel extends Equatable {
  final String? id;
  final String name;
  final int colorId;
  final DateTime createdAt;

  const ProjectModel({
    this.id,
    required this.name,
    required this.colorId,
    required this.createdAt
  });

  @override
  List<Object?> get props => [id, name, colorId, createdAt];

  ProjectModel copyWith({
    String? id,
    String? name,
    int? colorId,
    DateTime? createdAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      colorId: colorId ?? this.colorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String?,
      colorId: json['color_id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
