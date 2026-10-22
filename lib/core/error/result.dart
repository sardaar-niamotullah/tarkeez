import 'package:tarkeez/core/error/app_exception.dart';
import 'package:tarkeez/core/logger/app_logger.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T get value => (this as Success<T>).data;
  AppException get exception => (this as Failure<T>).error;

  Result<R> map<R>(R Function(T data) transform) => switch (this) {
    Success(:final data) => Success(transform(data)),
    Failure(:final error) => Failure(error),
  };

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppException error) onFailure,
  }) => switch (this) {
    Success(:final data) => onSuccess(data),
    Failure(:final error) => onFailure(error),
  };
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final AppException error;
  const Failure(this.error);

  factory Failure.logged(AppException error) {
    AppLogger.error('[Generic]: ${error.message}');
    return Failure(error);
  }
}
