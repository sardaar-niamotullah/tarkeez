import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/services/connectivity_service.dart';
import 'package:tarkeez/core/sync/sync_engine.dart';
import 'package:tarkeez/core/sync/sync_status.dart';
import 'package:tarkeez/core/sync/sync_trigger.dart';

/// Decides when sync runs. There is no timer. It runs when:
///  - `pending_changes` has rows and the device is online
///  - the app starts (or the user signs in)
///  - the user taps the Sync button
/// Offline, nothing is attempted. Events that arrive during a run are merged
/// into one follow-up run.
class SyncService {
  new(this._engine, this._connectivity, this._supabase, this._database);

  final SyncEngine _engine;
  final ConnectivityService _connectivity;
  final SupabaseClient _supabase;
  final LocalDatabase _database;

  final _statuses = StreamController<SyncStatus>.broadcast();
  final _projectsChanged = StreamController<void>.broadcast();

  StreamSubscription<AuthState>? _authSub;
  StreamSubscription<bool>? _onlineSub;
  StreamSubscription<List<String>>? _pendingSub;

  SyncStatus _current = const SyncStatus(SyncPhase.idle);

  bool _running = false;
  bool _rerun = false;
  bool _rerunManual = false;

  /// App start happened offline: sync once the connection returns.
  bool _syncOnReconnect = false;

  /// Sync runs and history resets never overlap.
  Future<void> _lock = Future.value();

  Stream<SyncStatus> get statuses => _statuses.stream;

  /// Fires when a pull or a reset changed the project list on this device.
  Stream<void> get projectsChanged => _projectsChanged.stream;

  SyncStatus get current => _current;

  bool get _isSignedIn => _supabase.auth.currentUser != null;

  /// Call once after dependency injection.
  void start() {
    _authSub = _supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) _onSignedIn();
      if (data.event == AuthChangeEvent.signedOut) _onSignedOut();
    });

    _onlineSub = _connectivity.onlineChanges.listen((online) {
      if (online) unawaited(_onConnectionRestored());
    });

    if (_isSignedIn) _onSignedIn();
  }

  Future<void> dispose() async {
    await _authSub?.cancel();
    await _onlineSub?.cancel();
    await _pendingSub?.cancel();
    await _statuses.close();
    await _projectsChanged.close();
  }

  Future<void> requestSync(SyncTrigger trigger) async {
    if (!_isSignedIn) return;

    if (!await _connectivity.isOnline) {
      if (trigger == SyncTrigger.appStart) _syncOnReconnect = true;
      if (trigger.isManual) {
        _emit(const SyncStatus(SyncPhase.offline, isManual: true));
      }
      return;
    }

    if (_running) {
      _rerun = true;
      _rerunManual = _rerunManual || trigger.isManual;
      return;
    }

    _running = true;
    var manual = trigger.isManual;
    try {
      do {
        _rerun = false;
        _rerunManual = false;
        await _runOnce(manual: manual);
        manual = _rerunManual;
      } while (_rerun);
    } finally {
      _running = false;
    }
  }

  /// "Delete history": online only. For now it wipes projects.
  Future<void> resetHistory() async {
    if (!_isSignedIn) return;

    if (!await _connectivity.isOnline) {
      _emit(const SyncStatus(SyncPhase.offline, isManual: true));
      return;
    }

    _emit(const SyncStatus(SyncPhase.resetting, isManual: true));
    final result = await _exclusive(_engine.resetHistory);
    result.fold(
      onSuccess: (_) {
        _projectsChanged.add(null);
        _emit(const SyncStatus(SyncPhase.resetDone, isManual: true));
      },
      onFailure: (error) => _emit(
        SyncStatus(SyncPhase.failed, isManual: true, message: error.message),
      ),
    );
  }

  // INTERNALS

  Future<void> _runOnce({required bool manual}) async {
    _emit(SyncStatus(SyncPhase.syncing, isManual: manual));
    final result = await _exclusive(_engine.sync);
    result.fold(
      onSuccess: (outcome) {
        if (outcome.projectsChanged) _projectsChanged.add(null);
        _emit(SyncStatus(SyncPhase.succeeded, isManual: manual));
      },
      onFailure: (error) => _emit(
        SyncStatus(SyncPhase.failed, isManual: manual, message: error.message),
      ),
    );
  }

  void _onSignedIn() {
    _pendingSub?.cancel();
    _pendingSub = _database.pendingChangesDao.watchPendingIds().listen((ids) {
      if (ids.isNotEmpty) unawaited(requestSync(SyncTrigger.pendingChanges));
    });
    unawaited(requestSync(SyncTrigger.appStart));
  }

  void _onSignedOut() {
    _pendingSub?.cancel();
    _pendingSub = null;
    _syncOnReconnect = false;
  }

  Future<void> _onConnectionRestored() async {
    if (!_isSignedIn) return;

    final hasPending = await _database.pendingChangesDao.hasPending();
    if (!_syncOnReconnect && !hasPending) return;

    final trigger = _syncOnReconnect
        ? SyncTrigger.appStart
        : SyncTrigger.pendingChanges;
    _syncOnReconnect = false;
    await requestSync(trigger);
  }

  Future<T> _exclusive<T>(Future<T> Function() job) {
    final run = _lock.then((_) => job());
    _lock = run.then((_) {}, onError: (_) {});
    return run;
  }

  void _emit(SyncStatus status) {
    _current = status;
    if (!_statuses.isClosed) _statuses.add(status);
  }
}