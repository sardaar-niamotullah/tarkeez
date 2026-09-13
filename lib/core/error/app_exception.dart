sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class NetworkException extends AppException {
  const NetworkException([
    super.message =
        'No internet connection. Please check your network and try again.',
  ]);
}

class AppAuthException extends AppException {
  const AppAuthException([
    super.message =
        'We couldn\'t sign you in. Please check your details and try again.',
  ]);
}

class ServerException extends AppException {
  const ServerException([
    super.message =
        'Something went wrong on our side. Please try again in a few moments.',
  ]);
}

class FileSizeTooLargeException extends AppException {
  const FileSizeTooLargeException([
    super.message = 'File is too large. Please choose a smaller file.',
  ]);
}

class KnownException extends AppException {
  const KnownException(super.message);
}

class DuplicateEntryException extends AppException {
  const DuplicateEntryException([
    super.message = 'A customer with this phone number already exists.',
  ]);
}

class UnknownException extends AppException {
  const UnknownException([
    super.message = 'Something unexpected happened. Please try again.',
  ]);
}
