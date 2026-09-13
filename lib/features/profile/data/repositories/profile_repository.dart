import 'dart:io';
import 'package:tarkeez/core/constants/db_table_and_storage_paths.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/core/services/auth_session_service.dart';
import 'package:tarkeez/core/services/storage_service.dart';
import 'package:tarkeez/features/profile/data/models/profile_media_type.dart';
import 'package:tarkeez/features/profile/data/models/profile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProfileRepository {
  Future<Result<ProfileModel>> fetchProfile();
  Future<Result<ProfileModel>> updateProfile({required ProfileModel profile});
  Future<Result<ProfileModel>> updateProfileMedia({
    required ProfileModel profile,
    required File picture,
    required ProfileMediaType mediaType,
  });
}

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient _supabase;
  final StorageService _storage;
  final AuthSessionService _session;

  const ProfileRepositoryImpl(this._supabase, this._storage, this._session);

  @override
  Future<Result<ProfileModel>> fetchProfile() async {
    return resultGuard(() async {
      final data = await _supabase
          .from(DbTableAndStoragePaths.users)
          .select()
          .eq('id', _session.requiredUserId)
          .single();
      return ProfileModel.fromJson(data);
    });
  }

  @override
  Future<Result<ProfileModel>> updateProfile({
    required ProfileModel profile,
  }) async {
    return resultGuard(() async {
      final data = await _supabase
          .from(DbTableAndStoragePaths.users)
          .update({
            'full_name': profile.fullName,
            'bio': profile.bio,
            'profession': profile.profession,
            'education': profile.education,
            'country_code': profile.countryCode,
          })
          .eq('id', _session.requiredUserId)
          .select()
          .single();
      return ProfileModel.fromJson(data);
    });
  }

  @override
  Future<Result<ProfileModel>> updateProfileMedia({
    required ProfileModel profile,
    required File picture,
    required ProfileMediaType mediaType,
  }) {
    return resultGuard(() async {
      final userId = _session.requiredUserId;
      final isAvatar = mediaType == .avatar;
      final previousProfileMediaLink =
          (isAvatar ? profile.avatarUrl : profile.coverUrl) ?? '';
      final columnName = isAvatar ? 'avatar_url' : 'cover_url';

      final mediaUrl = await _storage.uploadFile(
        path: userId,
        file: picture,
        mediaType: mediaType,
      );

      final data = await _supabase
          .from(DbTableAndStoragePaths.users)
          .update({columnName: mediaUrl})
          .eq('id', userId)
          .select()
          .single();

      final profileModel = ProfileModel.fromJson(data);

      if (previousProfileMediaLink.isNotEmpty) {
        try {
          await _storage.deleteFile(fileLink: previousProfileMediaLink);
        } catch (e) {
          debugPrint(
            '⚠️ Old ${isAvatar ? 'avatar' : 'cover'} deletion failed: $e',
          );
        }
      }
      return profileModel;
    });
  }
}
