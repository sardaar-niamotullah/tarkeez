import 'package:tarkeez/features/projects/data/models/project_model.dart';

abstract final class DummyProject {
  static ProjectModel project = ProjectModel(
    name: 'Dummy project',
    colorId: 3,
    createdAt: DateTime(2026),
  );
}
