part of 'session_bloc.dart';


sealed class SessionState {
  const SessionState();
}

final class SessionInitial extends SessionState {}

final class SessionLoading extends SessionState {
  final List<SessionModel> sessions;
  const SessionLoading({this.sessions = const []});
}

final class SessionFailure extends SessionState {
  final String errorMessage;
  final List<SessionModel> sessions;
  const SessionFailure(this.errorMessage, {this.sessions = const []});
}

final class SessionLoaded extends SessionState {
  final List<SessionModel> sessions;
  const SessionLoaded(this.sessions);
}
