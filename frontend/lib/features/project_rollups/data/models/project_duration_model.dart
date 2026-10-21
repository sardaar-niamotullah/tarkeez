import 'package:tarkeez/features/projects/data/models/project_model.dart';

class ProjectDurationModel {
  const new({this.project, required this.durationInSeconds});
  final ProjectModel? project;
  final int durationInSeconds;
}
