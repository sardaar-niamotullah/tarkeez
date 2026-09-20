import 'package:equatable/equatable.dart';
import 'package:tarkeez/core/database/app_database.dart';

class DailyRollupModel extends Equatable {
  const DailyRollupModel({required this.date, required this.durationSeconds});
  final String date;
  final int durationSeconds;

  @override
  List<Object?> get props => [date, durationSeconds];

  DailyRollupModel copyWith({int? durationSeconds}) => DailyRollupModel(
    date: date,
    durationSeconds: durationSeconds ?? this.durationSeconds,
  );

  factory DailyRollupModel.fromRow(DailyRollup row) {
    return DailyRollupModel(
      date: row.date,
      durationSeconds: row.durationSeconds,
    );
  }
}
