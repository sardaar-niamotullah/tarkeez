import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  const new({
    required this.id,
    this.email,
    this.fullName,
    this.avatarUrl,
    this.premiumUntil,
  });

  final String id;
  final String? email;
  final String? fullName;
  final String? avatarUrl;
  final String? premiumUntil;

  /// Leaves [premiumUntil] null because the auth session has no premium data.
  /// Never write [premiumUntil] from a model built here: it would overwrite
  /// the stored value with null. Only [UserModel.fromRow] (the cloud `users`
  /// row, read by sync) may set it.
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
    premiumUntil: row['premium_until'] as String?,
  );
}
