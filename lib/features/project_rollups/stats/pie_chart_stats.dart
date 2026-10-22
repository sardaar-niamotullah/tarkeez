import 'package:tarkeez/core/extensions/period_range_extension.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_duration_model.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/core/utils/rollup_date_utils.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_rollup_model.dart';

class PieChartStats {
  PieChartStats._();

  /// Keeps rollups whose date key falls inside [period]. 'YYYY-MM-DD' keys
  /// sort lexicographically, so plain string comparison is enough.
  static List<ProjectRollupModel> rollupsInPeriod(
    List<ProjectRollupModel> rollups,
    PeriodRange period, {
    DateTime? now,
  }) {
    final range = period.dateRange(now: now);
    if (range == null) return rollups;

    final (start, end) = range;
    final startKey = RollupDateUtils.format(start);
    final endKey = RollupDateUtils.format(end);

    return rollups
        .where(
          (r) =>
              r.date.compareTo(startKey) >= 0 && r.date.compareTo(endKey) <= 0,
        )
        .toList();
  }

  /// Sums rollup seconds per project. Rows with no project, or whose
  /// project no longer exists, go into a single null-project bucket.
  /// Sorted by duration, descending.
  static List<ProjectDurationModel> aggregateByProject({
    required List<ProjectRollupModel> rollups,
    required List<ProjectModel> projects,
    required PeriodRange period,
    DateTime? now,
  }) {
    final projectsById = {
      for (final p in projects)
        if (p.id != null) p.id!: p,
    };

    final durationByProjectId = <String?, int>{};

    for (final rollup in rollupsInPeriod(rollups, period, now: now)) {
      if (rollup.durationSeconds <= 0) continue;

      final key =
          rollup.projectId != null && projectsById.containsKey(rollup.projectId)
          ? rollup.projectId
          : null;

      durationByProjectId.update(
        key,
        (existing) => existing + rollup.durationSeconds,
        ifAbsent: () => rollup.durationSeconds,
      );
    }

    return durationByProjectId.entries
        .map(
          (e) => ProjectDurationModel(
            project: e.key == null ? null : projectsById[e.key],
            durationInSeconds: e.value,
          ),
        )
        .toList()
      ..sort((a, b) => b.durationInSeconds.compareTo(a.durationInSeconds));
  }
}
