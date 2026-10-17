part of 'auth_bloc.dart';

sealed class AuthState {
  const new();
}

class AuthInitial extends AuthState {
  const new();
}

class AuthLoading extends AuthState {
  const new();
}

class AuthSuccess extends AuthState {
  const new(this.user);
  final UserModel user;
}

class AuthFailure extends AuthState {
  const new(this.message);
  final String message;
}

final class AuthSignOut extends AuthState {
  const new();
}
