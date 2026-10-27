import 'package:equatable/equatable.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/project_rollups.dart'
    show noProjectKey;

class ProjectRollupModel extends Equatable {
  const new({
    required this.date,
    required this.projectId,
    required this.durationSeconds,
  });

  final String date;

  /// null means "no project". The DB stores it as noProjectKey (''). A deleted
  /// or missing project also arrives as '' (see project_rollups_effective).
  final String? projectId;
  final int durationSeconds;

  bool get hasProject => projectId != null;

  @override
  List<Object?> get props => [date, projectId, durationSeconds];

  ProjectRollupModel copyWith({int? durationSeconds}) => ProjectRollupModel(
    date: date,
    projectId: projectId,
    durationSeconds: durationSeconds ?? this.durationSeconds,
  );

  factory ProjectRollupModel.fromRow(ProjectRollup row) {
    return ProjectRollupModel(
      date: row.date,
      projectId: row.projectId == noProjectKey ? null : row.projectId,
      durationSeconds: row.durationSeconds,
    );
  }
}
