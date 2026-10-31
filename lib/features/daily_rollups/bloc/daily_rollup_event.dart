part of 'daily_rollup_bloc.dart';

sealed class DailyRollupEvent {}

class FetchDailyRollupRequested extends DailyRollupEvent {}

class RefreshDailyRollupRequested extends DailyRollupEvent {
  new({this.days = 5});
  final int days;
}

/// Fired while a session timer is running. Repeats within the same second are ignored.
class DailyRollupLiveTicked extends DailyRollupEvent {
  new(this.timerStartedAt);
  final DateTime timerStartedAt;
}

/// /// The running session ended (saved or failed): re-read the rollups and drop the live part together.
class DailyRollupLiveStopped extends DailyRollupEvent {}

/// Sync changed the local sessions (a pull or a history reset): read the rollups again.
class DailyRollupSynced extends DailyRollupEvent {}
