import 'package:supabase_flutter/supabase_flutter.dart';


class AuthSessionService {
  const new(this._supabaseClient);
  
  final SupabaseClient _supabaseClient;

  String get requiredUserId {
    final id = _supabaseClient.auth.currentUser?.id;
    if (id == null) {
      throw StateError('AuthSessionService.requireUserId called with no active session.');
    }
    return id;
  }

  bool get hasSession => _supabaseClient.auth.currentSession != null;
}