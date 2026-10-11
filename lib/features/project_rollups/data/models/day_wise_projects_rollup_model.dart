import 'package:tarkeez/features/project_rollups/data/models/project_duration_model.dart';

class DayWiseProjectsRollupModel {
  const new({required this.date, required this.projects});
  final DateTime date;
  final List<ProjectDurationModel> projects;

  int get totalSeconds =>
      projects.fold(0, (sum, p) => sum + p.durationInSeconds);
}