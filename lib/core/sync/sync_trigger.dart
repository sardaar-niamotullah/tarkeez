enum SyncTrigger {
  /// `pending_changes` is not empty and the device is online.
  pendingChanges,

  /// App start, and a fresh sign-in (the start of a new session on this device).
  appStart,

  /// The user tapped the Sync button.
  syncButton;

  bool get isManual => this == syncButton;
}