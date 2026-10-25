import 'package:equatable/equatable.dart';
import 'package:tarkeez/core/database/local_database.dart';

class ProjectModel extends Equatable {
  const new({
    required this.id,
    required this.name,
    required this.colorId,
    required this.createdAt,
    this.deletedAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final int colorId;
  final DateTime createdAt;
  final DateTime? deletedAt;

  /// The server's own stamp, kept as text. Only set on pulled rows.
  final String? updatedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    colorId,
    createdAt,
    deletedAt,
    updatedAt,
  ];

  ProjectModel copyWith({
    String? id,
    String? name,
    int? colorId,
    DateTime? createdAt,
    DateTime? deletedAt,
    String? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      colorId: colorId ?? this.colorId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final deleted = json['deleted_at'] as String?;
    return ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      colorId: json['color_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt: deleted == null ? null : DateTime.parse(deleted),
      updatedAt: json['updated_at'] as String?,
    );
  }

  factory ProjectModel.fromLocal(LocalProject row) => ProjectModel(
    id: row.id,
    name: row.name,
    colorId: row.colorId,
    createdAt: row.createdAt,
    deletedAt: row.deletedAt,
  );

  /// `user_id` and `updated_at` are not sent. The cloud sets both.
  Map<String, dynamic> toPushJson() => {
    'id': id,
    'name': name,
    'color_id': colorId,
    'created_at': createdAt.toUtc().toIso8601String(),
    'deleted_at': deletedAt?.toUtc().toIso8601String(),
  };
}
