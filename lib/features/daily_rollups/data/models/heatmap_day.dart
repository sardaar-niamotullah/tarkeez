import 'package:equatable/equatable.dart';

class HeatmapDay extends Equatable {
  const HeatmapDay({
    required this.date,
    required this.durationSeconds,
    required this.isFuture,
  });
  final DateTime date;
  final int durationSeconds;
  final bool isFuture;

  @override
  List<Object?> get props => [date, durationSeconds, isFuture];
}
