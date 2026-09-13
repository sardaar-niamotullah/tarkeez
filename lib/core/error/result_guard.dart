import 'package:tarkeez/core/error/exception_mapper.dart';
import 'package:tarkeez/core/error/result.dart';

Future<Result<T>> resultGuard<T>(Future<T> Function() action) async {
  try {
    return Success(await action());
  } catch (e) {
    return Failure(mapException(e));
  }
}
