part of 'daily_rollup_bloc.dart';

sealed class DailyRollupEvent {}

class FetchDailyRollupRequested extends DailyRollupEvent {}

class RefreshDailyRollupRequested extends DailyRollupEvent {
  new({this.days = 5});
  final int days;
}

/// Fired every tick (e.g. once/sec) while a session timer is running.
class DailyRollupLiveTicked extends DailyRollupEvent {
  new(this.timerStartedAt);
  final DateTime timerStartedAt;
}

/// Fired when a running timer is cancelled/discarded (no session saved).
class DailyRollupLiveStopped extends DailyRollupEvent {}

/// Sync changed the local sessions (a pull or a history reset): read the rollups again.
class DailyRollupSynced extends DailyRollupEvent {}
