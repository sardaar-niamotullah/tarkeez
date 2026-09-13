import 'package:supabase_flutter/supabase_flutter.dart';


class AuthSessionService {
  final SupabaseClient _supabaseClient;
  const AuthSessionService(this._supabaseClient);

  String get requiredUserId {
    final id = _supabaseClient.auth.currentUser?.id;
    if (id == null) {
      throw StateError('AuthSessionService.requireUserId called with no active session.');
    }
    return id;
  }

  bool get hasSession => _supabaseClient.auth.currentSession != null;
}