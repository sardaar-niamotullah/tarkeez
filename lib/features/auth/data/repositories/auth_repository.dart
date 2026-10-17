import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/features/auth/data/models/user_model.dart';
import 'package:tarkeez/core/constants/secret_keys.dart';
import 'package:tarkeez/core/error/app_exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRepository {
  Future<Result<void>> signOut();
  Future<Result<UserModel>> signInWithGoogle();
  Future<Result<UserModel>> signInWithGoogleLegacy();
}

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;
  const AuthRepositoryImpl(this._supabase);

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
        throw AppAuthException('No ID Token found.');
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
      return UserModel.fromSupabaseUser(user);
    });
  }

  @override
  Future<Result<UserModel>> signInWithGoogleLegacy() {
    return resultGuard(() async {
      final webClientId = dotenv.get(SecretKeys.webClientId);
      final iosClientId = dotenv.get(SecretKeys.iosClientId);
      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId: webClientId,
        clientId: iosClientId,
      );

      try {
        final googleUser = await googleSignIn.authenticate();
        const scopes = ['email', 'profile'];
        final authorization =
            await googleUser.authorizationClient.authorizationForScopes(
              scopes,
            ) ??
            await googleUser.authorizationClient.authorizeScopes(scopes);

        final idToken = googleUser.authentication.idToken;
        if (idToken == null) {
          throw const AppAuthException('No ID token received from Google.');
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

        return UserModel.fromSupabaseUser(user);
      } on GoogleSignInException catch (e) {
        if (e.code == GoogleSignInExceptionCode.canceled) {
          throw const AppAuthException('Google sign-in was cancelled.');
        }
        rethrow;
      }
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
}
