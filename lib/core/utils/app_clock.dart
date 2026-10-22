import 'package:flutter/foundation.dart';

class AppClock {
  AppClock._();

  static DateTime? _fakeStart;
  static DateTime? _realStartAtFakeSeed;
  static double _speed = 1;

  static bool get isFaked => _fakeStart != null;

  static void fakeCurrentTime(DateTime fakeNow, {double speed = 60}) {
    if (!kDebugMode) return;
    _fakeStart = fakeNow;
    _realStartAtFakeSeed = DateTime.now();
    _speed = speed;
  }

  static void reset() {
    _fakeStart = null;
    _realStartAtFakeSeed = null;
    _speed = 1;
  }

  static DateTime now() {
    final fakeStart = _fakeStart;
    final realStart = _realStartAtFakeSeed;
    if (fakeStart == null || realStart == null) return DateTime.now();

    final realElapsed = DateTime.now().difference(realStart);
    return fakeStart.add(realElapsed * _speed);
  }
}
