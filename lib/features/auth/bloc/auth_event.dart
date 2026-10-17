part of 'auth_bloc.dart';

sealed class AuthEvent {}

class GoogleSignInRequested extends AuthEvent {}
class SignOutRequested extends AuthEvent {}
