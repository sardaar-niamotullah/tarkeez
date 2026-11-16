import 'package:flutter/foundation.dart';

abstract final class AppLogger {
  static void info(String message) {
    if (kDebugMode) debugPrint('📃  [INFO] $message');
  }

  static void warning(String message) {
    if (kDebugMode) debugPrint('⚠️  [WARN] $message');
  }

  static void error(String message, [Object? exception]) {
    if (kDebugMode) {
      debugPrint('⛔ [ERROR] $message');
      if (exception != null) debugPrint('   ↳ $exception');
    }
  }
}
