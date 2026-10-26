import 'package:equatable/equatable.dart';
import 'package:tarkeez/core/database/local_database.dart';

class DailyRollupModel extends Equatable {
  const new({required this.date, required this.durationSeconds});
  final String date;
  final int durationSeconds;

  @override
  List<Object?> get props => [date, durationSeconds];

  DailyRollupModel copyWith({int? durationSeconds}) => DailyRollupModel(
    date: date,
    durationSeconds: durationSeconds ?? this.durationSeconds,
  );

  factory DailyRollupModel.fromRow(LocalDailyRollup row) {
    return DailyRollupModel(
      date: row.date,
      durationSeconds: row.durationSeconds,
    );
  }
}
