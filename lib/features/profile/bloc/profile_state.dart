part of 'profile_bloc.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  final bool isUpdated;
  const ProfileLoaded(this.profile, {this.isUpdated = false});
}

// Network or other unexpected error
class ProfileFailure extends ProfileState {
  final String message;
  final ProfileModel? profile;

  const ProfileFailure({required this.message, this.profile});
}