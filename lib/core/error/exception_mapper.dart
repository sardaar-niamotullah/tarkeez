import 'package:tarkeez/core/error/app_exception.dart';
import 'package:tarkeez/core/logger/app_logger.dart';
import 'package:http/http.dart' show ClientException;
import 'package:supabase_flutter/supabase_flutter.dart'
    as supabase
    show AuthException, AuthRetryableFetchException, PostgrestException;

AppException mapException(Object error) {
  final AppException mapped;
  if (error is supabase.AuthRetryableFetchException) {
    mapped = NetworkException();
  } else if (error is supabase.AuthException) {
    mapped = AppAuthException();
  } else if (error is supabase.PostgrestException) {
    mapped = error.code == '23505'
        ? const DuplicateEntryException()
        : const ServerException();
  } else if (error is ClientException) {
    mapped = NetworkException();
  } else if (error is FileSizeTooLargeException) {
    mapped = error;
  } else if (error is AppException) {
    mapped = error;
  } else {
    mapped = UnknownException();
  }
  AppLogger.error('[Generic]: ${mapped.message}');
  AppLogger.error('[Technical]: $error');
  return mapped;
}
