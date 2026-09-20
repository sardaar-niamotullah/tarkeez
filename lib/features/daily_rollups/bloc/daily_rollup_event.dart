part of 'daily_rollup_bloc.dart';

sealed class DailyRollupEvent {}

class FetchDailyRollupRequested extends DailyRollupEvent {}

class RefreshDailyRollupRequested extends DailyRollupEvent {
  RefreshDailyRollupRequested({this.days = 5});
  final int days;
}

/// Fired every tick (e.g. once/sec) while a session timer is running.
class DailyRollupLiveTicked extends DailyRollupEvent {
  DailyRollupLiveTicked(this.timerStartedAt);
  final DateTime timerStartedAt;
}

/// Fired when a running timer is cancelled/discarded (no session saved).
class DailyRollupLiveStopped extends DailyRollupEvent {}
