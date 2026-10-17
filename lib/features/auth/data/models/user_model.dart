import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  const new({required this.id, this.email, this.name, this.avatarUrl});
  
  final String id;
  final String? email;
  final String? name;
  final String? avatarUrl;

  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.userMetadata?['email'] as String?,
      name: user.userMetadata?['full_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }
}
