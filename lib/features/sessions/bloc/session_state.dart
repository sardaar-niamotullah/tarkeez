part of 'session_bloc.dart';

sealed class SessionState {
  const SessionState();
}

final class SessionInitial extends SessionState {}

final class SessionLoading extends SessionState {
  final List<SessionModel> sessions;
  final bool isInitialLoad;
  const SessionLoading({this.sessions = const [], this.isInitialLoad = true});
}

final class SessionFailure extends SessionState {
  final String errorMessage;
  final List<SessionModel> sessions;
  const SessionFailure(this.errorMessage, {this.sessions = const []});
}

final class SessionLoaded extends SessionState {
  final List<SessionModel> sessions;
  final bool isEntered, isDeleted;
  const SessionLoaded(
    this.sessions, {
    this.isEntered = false,
    this.isDeleted = false,
  }) : assert(
         !(isEntered && isDeleted),
         'Only one of isEntered / isDeleted may be true at a time.',
       );

  const SessionLoaded.plain(List<SessionModel> sessions) : this(sessions);
  const SessionLoaded.entered(List<SessionModel> sessions)
    : this(sessions, isEntered: true);
  const SessionLoaded.deleted(List<SessionModel> sessions)
    : this(sessions, isDeleted: true);
}
