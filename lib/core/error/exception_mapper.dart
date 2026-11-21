import 'dart:io' show SocketException;

import 'package:google_sign_in/google_sign_in.dart' show GoogleSignInException;
import 'package:http/http.dart' show ClientException;
import 'package:supabase_flutter/supabase_flutter.dart'
    as supabase
    show AuthException, AuthRetryableFetchException, PostgrestException;
import 'package:tarkeez/core/error/app_exception.dart';
import 'package:tarkeez/core/error/app_logger.dart';

AppException mapException(Object error) {
  final AppException mapped;
  if (error is supabase.AuthRetryableFetchException) {
    mapped = NetworkException();
  } else if (error is supabase.AuthException) {
    mapped = AppAuthException(error.message);
  } else if (error is supabase.PostgrestException) {
    mapped = error.code == '23505'
        ? const DuplicateEntryException()
        : const ServerException();
  } else if (error is ClientException || error is SocketException) {
    mapped = NetworkException();
  } else if (error is FileSizeTooLargeException) {
    mapped = error;
  } else if (error is AppException) {
    mapped = error;
  } else if (error is GoogleSignInException) {
    mapped = AppAuthException('${error.code} ${error.description}');
  } else {
    mapped = UnknownException('$error');
  }
  AppLogger.error('[Generic]: ${mapped.message}');
  AppLogger.error('[Technical]: $error');
  return mapped;
}
