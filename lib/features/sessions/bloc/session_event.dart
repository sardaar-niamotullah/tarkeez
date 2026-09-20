part of 'session_bloc.dart';

sealed class SessionEvent {
  const SessionEvent();
}

final class EntrySessionRequested extends SessionEvent {
  const EntrySessionRequested({
    required this.startedAt,
    required this.endedAt,
    this.project,
  });
  final DateTime startedAt, endedAt;
  final ProjectModel? project;
}

final class FetchAllSessionsRequested extends SessionEvent {}

final class FetchSessionsInDateRangeRequested extends SessionEvent {
  const FetchSessionsInDateRangeRequested({
    required this.startedAt,
    required this.endedAt,
  });
  final DateTime startedAt, endedAt;
}

final class DeleteSessionRequested extends SessionEvent {
  const DeleteSessionRequested(this.session);
  final SessionModel session;
}
