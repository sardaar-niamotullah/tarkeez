import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void sessionTaskCallback() {
  FlutterForegroundTask.setTaskHandler(SessionTaskHandler());
}

/// Runs in the service's own isolate. It only forwards button presses.
class SessionTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}

  @override
  void onNotificationButtonPressed(String id) =>
      FlutterForegroundTask.sendDataToMain(id);
}