import 'package:flutter/foundation.dart';

void syncLog(String message) {
  if (kDebugMode) debugPrint('🔄 sync: $message');
}