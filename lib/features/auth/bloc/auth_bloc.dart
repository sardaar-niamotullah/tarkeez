import 'package:tarkeez/features/auth/data/models/user_model.dart';
import 'package:tarkeez/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  new(AuthRepository repository)
    : _repository = repository,
      super(const AuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<SignOutRequested>(_onSignOut);
  }

  final AuthRepository _repository;

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
}
