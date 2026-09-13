part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class ProfileReset extends ProfileEvent {}

class FetchProfileRequested extends ProfileEvent {
  final bool forceRefresh;
  FetchProfileRequested({this.forceRefresh = false});
}

class UpdateProfileRequested extends ProfileEvent {
  final ProfileModel profile;
  UpdateProfileRequested({required this.profile});
}

class UpdateProfileMediaRequested extends ProfileEvent {
  final ProfileModel profile;
  final File picture;
  final ProfileMediaType mediaType;
  UpdateProfileMediaRequested({required this.profile, required this.picture, required this.mediaType});
}
