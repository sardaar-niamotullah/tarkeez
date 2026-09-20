import 'package:tarkeez/features/sessions/data/models/session_model.dart';

abstract final class DummySession {
  static SessionModel session = SessionModel(
    startedAt: DateTime(2025, 1, 1, 1, 30),
    endedAt: DateTime(2025, 1, 1, 2, 40),
  );
}
