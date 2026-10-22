part of 'auth_bloc.dart';

sealed class AuthEvent {}

class GoogleSignInRequested extends AuthEvent {}
class SignOutRequested extends AuthEvent {}
/// Fired when Supabase ends the session (expiry, revoked, signed out elsewhere).
class SessionEnded extends AuthEvent {}