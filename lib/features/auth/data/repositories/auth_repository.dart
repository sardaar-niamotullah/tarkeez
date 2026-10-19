import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/features/auth/data/models/user_model.dart';
import 'package:tarkeez/core/constants/secret_keys.dart';
import 'package:tarkeez/core/error/app_exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRepository {
  UserModel? get currentUser;
  Stream<void> get sessionEnded;

  Future<Result<void>> signOut();
  Future<Result<UserModel>> signInWithGoogle();
}

class AuthRepositoryImpl implements AuthRepository {
  const new(this._supabase, this._localDatabase);
  
  final SupabaseClient _supabase;
  final LocalDatabase _localDatabase;

  @override
  UserModel? get currentUser {
    final user = _supabase.auth.currentUser;
    return user == null ? null : UserModel.fromSupabaseUser(user);
  }

  @override
  Stream<void> get sessionEnded => _supabase.auth.onAuthStateChange.where(
    (data) => data.event == AuthChangeEvent.signedOut,
  );

  @override
  Future<Result<UserModel>> signInWithGoogle() {
    return resultGuard(() async {
      final webClientId = dotenv.get(SecretKeys.webClientId);
      final iosClientId = dotenv.get(SecretKeys.iosClientId);
      final googleSignIn = GoogleSignIn.instance;
      final scopes = ['email', 'profile'];

      await googleSignIn.initialize(
        serverClientId: webClientId,
        clientId: iosClientId,
      );

      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.attemptLightweightAuthentication();
      } catch (_) {
        googleUser = null;
      }

      googleUser ??= await googleSignIn.authenticate();

      final authorization =
          await googleUser.authorizationClient.authorizationForScopes(scopes) ??
          await googleUser.authorizationClient.authorizeScopes(scopes);
      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        throw const AppAuthException('No ID Token found.');
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization.accessToken,
      );

      final user = response.user;
      if (user == null) {
        throw const AppAuthException('Supabase returned no user.');
      }
      // return UserModel.fromSupabaseUser(user);
      return _mirrorUserLocally(user);
    });
  }

  @override
  Future<Result<void>> signOut() {
    return resultGuard(() async {
      await _supabase.auth.signOut();
      await GoogleSignIn.instance.signOut();
      await GoogleSignIn.instance.disconnect();
    });
  }

  Future<UserModel> _mirrorUserLocally(User authUser) async {
    final row = await _supabase
        .from('users')
        .select('*')
        .eq('id', authUser.id)
        .single();

    final model = UserModel.fromRow(row);

    await _localDatabase.localUsersDao.upsertUser(
      LocalUsersCompanion(
        id: Value(model.id),
        email: Value(model.email),
        fullName: Value(model.name),
        avatarUrl: Value(model.avatarUrl),
      ),
    );
    return model;
  }
}
