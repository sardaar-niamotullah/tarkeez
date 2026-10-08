import 'package:tarkeez/core/utils/rollup_date_utils.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_duration_model.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_rollup_model.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class DayRollupModel {
  const new({required this.date, required this.projects});
  final DateTime date;

  /// Sorted by duration, descending.
  final List<ProjectDurationModel> projects;

  int get totalSeconds =>
      projects.fold(0, (sum, p) => sum + p.durationInSeconds);
}

class DayWiseStats {
  DayWiseStats._();

  /// Groups rollups by day for the last [days] calendar days (today included).
  /// Days with no tracked time are skipped. Newest day first.
  static List<DayRollupModel> recentDays({
    required List<ProjectRollupModel> rollups,
    required List<ProjectModel> projects,
    int days = 5,
    DateTime? now,
  }) {
    final today = now ?? DateTime.now();
    final startKey = RollupDateUtils.format(
      DateTime(today.year, today.month, today.day - (days - 1)),
    );
    final endKey = RollupDateUtils.format(today);

    final projectsById = {
      for (final p in projects)
        if (p.id != null) p.id!: p,
    };

    // date key -> (project id or null -> seconds)
    final byDate = <String, Map<String?, int>>{};

    for (final rollup in rollups) {
      if (rollup.durationSeconds <= 0) continue;
      if (rollup.date.compareTo(startKey) < 0 ||
          rollup.date.compareTo(endKey) > 0) {
        continue;
      }

      // Same rule as PieChartStats: no project / deleted project -> null bucket.
      final key =
          rollup.projectId != null && projectsById.containsKey(rollup.projectId)
          ? rollup.projectId
          : null;

      byDate
          .putIfAbsent(rollup.date, () => {})
          .update(
            key,
            (existing) => existing + rollup.durationSeconds,
            ifAbsent: () => rollup.durationSeconds,
          );
    }

    final dateKeys = byDate.keys.toList()..sort((a, b) => b.compareTo(a));

    return [
      for (final dateKey in dateKeys)
        DayRollupModel(
          date: DateTime.parse(dateKey), // 'YYYY-MM-DD' -> local midnight
          projects:
              byDate[dateKey]!.entries
                  .map(
                    (e) => ProjectDurationModel(
                      project: e.key == null ? null : projectsById[e.key],
                      durationInSeconds: e.value,
                    ),
                  )
                  .toList()
                ..sort(
                  (a, b) => b.durationInSeconds.compareTo(a.durationInSeconds),
                ),
        ),
    ];
  }
}
