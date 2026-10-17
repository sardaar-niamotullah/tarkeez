part of 'auth_bloc.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}
class AuthLoading extends AuthState {
  const AuthLoading();
}
class AuthSuccess extends AuthState {
  final UserModel user;
  const AuthSuccess(this.user);
}
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}
