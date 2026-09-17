import 'package:equatable/equatable.dart';
import 'package:tarkeez/core/database/app_database.dart';

class ProjectModel extends Equatable {
  final String? id;
  final String name;
  final int colorId;
  final DateTime createdAt;

  const ProjectModel({
    this.id,
    required this.name,
    required this.colorId,
    required this.createdAt,
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

  factory ProjectModel.fromRow(Project row) {
    return ProjectModel(
      id: row.id,
      colorId: row.colorId,
      name: row.name,
      createdAt: row.createdAt,
    );
  }
}
