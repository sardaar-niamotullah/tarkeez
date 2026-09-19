part of 'session_bloc.dart';

sealed class SessionEvent {
  const SessionEvent();
}

final class EntrySessionRequested extends SessionEvent {
  final DateTime startedAt, endedAt;
  final ProjectModel? project;
  const EntrySessionRequested({required this.startedAt, required this.endedAt, this.project});
}

final class FetchSessionsRequested extends SessionEvent {}
