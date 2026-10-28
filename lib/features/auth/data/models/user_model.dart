import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  const new({required this.id, this.email, this.fullName, this.avatarUrl});

  final String id;
  final String? email;
  final String? fullName;
  final String? avatarUrl;

  factory UserModel.fromSupabaseUser(User user) => UserModel(
    id: user.id,
    email: user.userMetadata?['email'] as String?,
    fullName: user.userMetadata?['full_name'] as String?,
    avatarUrl: user.userMetadata?['avatar_url'] as String?,
  );

  factory UserModel.fromRow(Map<String, dynamic> row) => UserModel(
    id: row['id'] as String,
    email: row['email'] as String?,
    fullName: row['full_name'] as String?,
    avatarUrl: row['avatar_url'] as String?,
  );
}
