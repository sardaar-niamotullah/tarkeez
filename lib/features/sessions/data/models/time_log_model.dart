import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  final String? id;
  final DateTime startedAt, endedAt;
  final String userId;
  final String? projectId;

  const SessionModel({
    this.id,
    required this.startedAt,
    required this.endedAt,
    required this.userId,
    this.projectId,
  });

  @override
  List<Object?> get props => [id, startedAt, endedAt, userId, projectId];

  SessionModel copyWith({
    String? id,
    DateTime? startedAt,
    DateTime? endedAt,
    String? userId,
    String? projectId,
  }) {
    return SessionModel(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
    );
  }

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String?,
      startedAt: DateTime.parse(json['started_at'] as String).toLocal(),
      endedAt: DateTime.parse(json['ended_at'] as String).toLocal(),
      userId: json['user_id'] as String,
      projectId: json['project_id'] as String?,
    );
  }
}
