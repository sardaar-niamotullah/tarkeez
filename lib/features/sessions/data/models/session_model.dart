import 'package:equatable/equatable.dart';
import 'package:tarkeez/core/database/local_database.dart';

class SessionModel extends Equatable {
  const new({
    this.id,
    this.projectId,
    required this.startedAt,
    required this.endedAt,
    this.utcOffsetMinutes = 0,
    this.deletedAt,
    this.updatedAt,
  });

  final String? id;
  final String? projectId;
  final DateTime startedAt, endedAt;

  /// The device's offset from UTC when the session was recorded.
  final int utcOffsetMinutes;

  final DateTime? deletedAt;

  /// The server's own stamp, kept as text. Only set on pulled rows.
  final String? updatedAt;

  @override
  List<Object?> get props => [
    id,
    projectId,
    startedAt,
    endedAt,
    utcOffsetMinutes,
    deletedAt,
    updatedAt,
  ];

  SessionModel copyWith({
    String? id,
    String? projectId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? utcOffsetMinutes,
    DateTime? deletedAt,
    String? updatedAt,
  }) {
    return SessionModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory SessionModel.fromLocal(LocalSession row) => SessionModel(
    id: row.id,
    projectId: row.projectId,
    startedAt: row.startedAt,
    endedAt: row.endedAt,
    utcOffsetMinutes: row.utcOffsetMinutes,
    deletedAt: row.deletedAt,
  );

  // Keep the old name so existing callers still compile.
  factory SessionModel.fromRow(LocalSession row) => SessionModel.fromLocal(row);

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    final deleted = json['deleted_at'] as String?;
    return SessionModel(
      id: json['id'] as String,
      projectId: json['project_id'] as String?,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: DateTime.parse(json['ended_at'] as String),
      utcOffsetMinutes: json['utc_offset_minutes'] as int,
      deletedAt: deleted == null ? null : DateTime.parse(deleted),
      updatedAt: json['updated_at'] as String?,
    );
  }

  /// `user_id` and `updated_at` are not sent. The cloud sets both.
  Map<String, dynamic> toPushJson() => {
    'id': id,
    'project_id': projectId,
    'started_at': startedAt.toUtc().toIso8601String(),
    'ended_at': endedAt.toUtc().toIso8601String(),
    'utc_offset_minutes': utcOffsetMinutes,
    'deleted_at': deletedAt?.toUtc().toIso8601String(),
  };
}