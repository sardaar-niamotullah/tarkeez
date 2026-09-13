part of 'time_log_bloc.dart';

sealed class TimeLogEvent {
  const TimeLogEvent();
}

final class EntryTimeLogRequested extends TimeLogEvent {
  final DateTime startedAt, endedAt;
  final ProjectModel? project;
  const EntryTimeLogRequested({required this.startedAt, required this.endedAt, this.project});
}

final class FetchTimeLogsRequested extends TimeLogEvent {}
