import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:tarkeez/core/services/auth_session_service.dart';
import 'package:tarkeez/features/profile/data/models/profile_media_type.dart';
import 'package:tarkeez/features/profile/data/repositories/profile_repository.dart';
import 'package:tarkeez/features/profile/data/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;
  final AuthSessionService _session;

  ProfileBloc(ProfileRepository repository, AuthSessionService session)
    : _repository = repository,
      _session = session,
      super(const ProfileInitial()) {
    on<ProfileReset>((event, emit) => emit(const ProfileInitial()));
    on<FetchProfileRequested>(_onFetchProfile, transformer: droppable());
    on<UpdateProfileRequested>(_onUpdateProfile);
    on<UpdateProfileMediaRequested>(_onUpdateProfileMedia);
  }

  Future<void> _onFetchProfile(
    FetchProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    debugPrint('🟢 user\'s own FetchProfileRequested called.');
    if (!_session.hasSession) return;
    if (state is ProfileLoaded && !event.forceRefresh) return;
    final previousProfile = state is ProfileLoaded
        ? (state as ProfileLoaded).profile
        : null;

    emit(const ProfileLoading());
    final result = await _repository.fetchProfile();
    debugPrint('💸💰 user\'s own FetchProfileRequested executed as well.');
    result.fold(
      onSuccess: (profile) => emit(ProfileLoaded(profile)),
      onFailure: (error) => emit(
        ProfileFailure(message: error.message, profile: previousProfile),
      ),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final previousProfile = state is ProfileLoaded
        ? (state as ProfileLoaded).profile
        : null;
    emit(const ProfileLoading());
    final result = await _repository.updateProfile(profile: event.profile);
    result.fold(
      onSuccess: (profile) {
        emit(ProfileLoaded(profile, isUpdated: true));
      },
      onFailure: (error) {
        emit(ProfileFailure(message: error.message, profile: previousProfile));
      },
    );
  }

  Future<void> _onUpdateProfileMedia(
    UpdateProfileMediaRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final previousProfile = state is ProfileLoaded
        ? (state as ProfileLoaded).profile
        : null;

    emit(const ProfileLoading());

    final result = await _repository.updateProfileMedia(
      profile: event.profile,
      picture: event.picture,
      mediaType: event.mediaType
    );

    result.fold(
      onSuccess: (profile) {
        emit(ProfileLoaded(profile, isUpdated: true));
      },
      onFailure: (error) {
        emit(ProfileFailure(message: error.message, profile: previousProfile));
      },
    );
  }
}
