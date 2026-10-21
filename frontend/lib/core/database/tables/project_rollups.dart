import 'package:drift/drift.dart';

const String noProjectKey = '';

class ProjectRollups extends Table {
  TextColumn get date => text()();
  TextColumn get projectId =>
      text().withDefault(const Constant(noProjectKey))();
  IntColumn get durationSeconds =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {date, projectId};
}