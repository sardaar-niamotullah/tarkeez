part of 'time_log_bloc.dart';

sealed class TimeLogState {
  const TimeLogState();
}

final class TimeLogInitial extends TimeLogState {}

final class TimeLogLoading extends TimeLogState {
  final List<TimeLogModel> timeLogs;
  const TimeLogLoading({this.timeLogs = const []});
}

final class TimeLogFailure extends TimeLogState {
  final String errorMessage;
  final List<TimeLogModel> timeLogs;
  const TimeLogFailure(this.errorMessage, {this.timeLogs = const []});
}

final class TimeLogLoaded extends TimeLogState {
  final List<TimeLogModel> timeLogs;
  const TimeLogLoaded(this.timeLogs);
}
