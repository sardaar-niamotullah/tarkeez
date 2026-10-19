import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class CurrentUser {
  String get id;
}

class SupabaseCurrentUser implements CurrentUser {
  @override
  String get id {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw StateError('No signed-in user');
    return user.id;
  }
}