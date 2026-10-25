part of 'sync_bloc.dart';

sealed class SyncEvent {
  const new();
}

/// The Sync button.
final class SyncButtonPressed extends SyncEvent {
  const new();
}

/// The "delete history" action.
final class HistoryResetRequested extends SyncEvent {
  const new();
}

final class SyncStatusChanged extends SyncEvent {
  const new(this.status);

  final SyncStatus status;
}