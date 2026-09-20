part of 'session_bloc.dart';

sealed class SessionState {
  const SessionState();
}

final class SessionInitial extends SessionState {}

final class SessionLoading extends SessionState {
  const SessionLoading({this.sessions = const []});
  final List<SessionModel> sessions;
}

final class SessionFailure extends SessionState {
  const SessionFailure(this.errorMessage, {this.sessions = const []});
  final String errorMessage;
  final List<SessionModel> sessions;
}

final class SessionLoaded extends SessionState {
  const SessionLoaded(this.sessions, {this.isDeleted = false});
  final List<SessionModel> sessions;
  final bool isDeleted;

  const SessionLoaded.plain(List<SessionModel> sessions) : this(sessions);
  const SessionLoaded.deleted(List<SessionModel> sessions)
    : this(sessions, isDeleted: true);
}
