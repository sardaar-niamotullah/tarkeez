part of 'session_bloc.dart';

sealed class SessionEvent {
  const new();
}

final class EntrySessionRequested extends SessionEvent {
  const new({
    required this.startedAt,
    required this.endedAt,
    this.project,
  });

  final DateTime startedAt, endedAt;
  final ProjectModel? project;
}

final class FetchSessionsForPeriodRequested extends SessionEvent {
  const new(this.period);

  final PeriodRange period;
}

final class DeleteSessionRequested extends SessionEvent {
  const new(this.session);

  final SessionModel session;
}

/// A pull or a history reset changed the local sessions.
final class SessionsSynced extends SessionEvent {}