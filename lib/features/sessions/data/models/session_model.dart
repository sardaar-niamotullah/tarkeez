import 'package:equatable/equatable.dart';
import 'package:tarkeez/core/database/app_database.dart';

class SessionModel extends Equatable {
  final String? id;
  final DateTime startedAt, endedAt;
  final String? projectId;

  const SessionModel({
    this.id,
    this.projectId,
    required this.startedAt,
    required this.endedAt,
  });

  @override
  List<Object?> get props => [id, projectId, startedAt, endedAt];

  SessionModel copyWith({
    String? id,
    String? projectId,
    DateTime? startedAt,
    DateTime? endedAt,
  }) {
    return SessionModel(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      projectId: projectId ?? this.projectId,
    );
  }

  factory SessionModel.fromRow(Session row) {
    return SessionModel(
      id: row.id,
      projectId: row.projectId,
      startedAt: row.startedAt,
      endedAt: row.endedAt
    );
  }
}
