import 'package:equatable/equatable.dart';

class ProjectModel extends Equatable {
  final String? id;
  final String name;
  final String userId;
  final int colorId;
  final DateTime createdAt;

  const ProjectModel({
    this.id,
    required this.name,
    required this.userId,
    required this.colorId,
    required this.createdAt
  });

  @override
  List<Object?> get props => [id, name, userId, colorId, createdAt];

  ProjectModel copyWith({
    String? id,
    String? name,
    String? userId,
    int? colorId,
    DateTime? createdAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      colorId: colorId ?? this.colorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      colorId: json['color_id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'color_id': colorId};
  }
}
