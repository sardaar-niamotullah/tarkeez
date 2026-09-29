import 'package:tarkeez/core/extensions/period_range_extension.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';
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

  /// Keeps only sessions whose local start-day falls inside period.
  /// Safe to rely on the session's day alone because SessionBloc splits
  /// every entry at local midnight, so a session never spans two days.
  static List<SessionModel> sessionsInPeriod(
    List<SessionModel> sessions,
    PeriodRange period,
  ) {
    final range = period.dateRange();
    if (range == null) return sessions;

    final (start, end) = range;
    final endExclusive = end.add(const Duration(days: 1));

    return sessions.where((s) {
      final localDay = _dateOnly(s.startedAt.toLocal());
      return !localDay.isBefore(start) && localDay.isBefore(endExclusive);
    }).toList();
  }

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

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
