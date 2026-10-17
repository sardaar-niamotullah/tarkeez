import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  const new({required this.email, this.name, this.avatarUrl});
  final String email;
  final String? name;
  final String? avatarUrl;

  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      email: user.email ?? '',
      name: user.userMetadata?['full_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }
}
