import 'package:drift/drift.dart';

class DailyRollups extends Table {
  TextColumn get date => text()();
  IntColumn get durationSeconds =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {date};
}