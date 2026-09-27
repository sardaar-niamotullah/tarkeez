import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/sessions/data/models/session_model.dart';

/// Aggregated time spent on a single project. project is null for the
/// "No project" bucket (sessions with no projectId, or one that no longer
/// resolves to a known project).
class ProjectDurationModel {
  const ProjectDurationModel({this.project, required this.durationInSeconds});
  final ProjectModel? project;
  final int durationInSeconds;
}

class ProjectSessionStats {
  ProjectSessionStats._();
  /// Sums session durations per project, bucketing unassigned/unresolvable
  /// sessions under a single null-project entry. Zero-duration entries are
  /// dropped. Result is sorted by duration, descending.
  static List<ProjectDurationModel> aggregateByProject({
    required List<SessionModel> sessions,
    required List<ProjectModel> projects,
  }) {
    final projectsById = {
      for (final p in projects)
        if (p.id != null) p.id!: p,
    };

    final durationByProjectId = <String?, int>{};

    for (final session in sessions) {
      final seconds = session.endedAt.difference(session.startedAt).inSeconds;
      if (seconds <= 0) continue;

      final key =
          session.projectId != null &&
              projectsById.containsKey(session.projectId)
          ? session.projectId
          : null;

      durationByProjectId.update(
        key,
        (existing) => existing + seconds,
        ifAbsent: () => seconds,
      );
    }

    final result =
        durationByProjectId.entries
            .where((entry) => entry.value > 0)
            .map(
              (entry) => ProjectDurationModel(
                project: entry.key == null ? null : projectsById[entry.key],
                durationInSeconds: entry.value,
              ),
            )
            .toList()
          ..sort((a, b) => b.durationInSeconds.compareTo(a.durationInSeconds));

    return result;
  }
}
