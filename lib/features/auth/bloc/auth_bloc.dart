import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/features/auth/data/models/user_model.dart';
import 'package:tarkeez/features/auth/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  new(AuthRepository repository)
    : _repository = repository,
      super(
        repository.currentUser != null
            ? AuthSuccess(repository.currentUser!)
            : const AuthInitial(),
      ) {
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<SignOutRequested>(_onSignOut);
    on<SessionEnded>(_onSessionEnded);

    _sessionSub = _repository.sessionEnded.listen((_) => add(SessionEnded()));
  }

  final AuthRepository _repository;
  late final StreamSubscription<void> _sessionSub;

  void _onSessionEnded(SessionEnded event, Emitter<AuthState> emit) {
    // Only matters if we were signed in. A manual sign-out is already
    // handled by _onSignOut (state is AuthLoading by then).
    if (state is AuthSuccess) emit(const AuthSignOut());
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _repository.signInWithGoogle();
    result.fold(
      onSuccess: (user) => emit(AuthSuccess(user)),
      onFailure: (error) => emit(AuthFailure(error.message)),
    );
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _repository.signOut();
    result.fold(
      onSuccess: (_) => emit(const AuthSignOut()),
      onFailure: (error) => emit(AuthFailure(error.message)),
    );
  }

  @override
  Future<void> close() {
    _sessionSub.cancel();
    return super.close();
  }
}