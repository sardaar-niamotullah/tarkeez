enum SyncPhase { idle, syncing, succeeded, failed, offline, resetting, resetDone }

class SyncStatus {
  const new(this.phase, {this.isManual = false, this.message});

  final SyncPhase phase;

  /// True when the user asked for it (Sync button, delete history).
  /// The UI shows errors only for these.
  final bool isManual;

  final String? message;

  bool get isBusy => phase == SyncPhase.syncing || phase == SyncPhase.resetting;
}