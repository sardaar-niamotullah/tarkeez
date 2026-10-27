import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/services/sync_service.dart';
import 'package:tarkeez/core/shared_files/enums/sync_trigger.dart';
import 'package:tarkeez/core/sync/sync_status.dart';

part 'sync_event.dart';
part 'sync_state.dart';

/// UI side of sync. The work is done by `SyncService`; this only forwards
/// button events and mirrors the service status.
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  new(SyncService service)
    : _service = service,
      super(SyncState(service.current)) {
    on<SyncButtonPressed>(_onSyncButtonPressed);
    on<HistoryResetRequested>(_onHistoryResetRequested);
    on<SyncStatusChanged>(_onSyncStatusChanged);

    _statusSub = _service.statuses.listen(
      (status) => add(SyncStatusChanged(status)),
    );
  }

  final SyncService _service;
  late final StreamSubscription<SyncStatus> _statusSub;

  // Not awaited: progress comes back through the status stream, and awaiting
  // here would hold back the status events queued behind this one.
  void _onSyncButtonPressed(SyncButtonPressed event, Emitter<SyncState> emit) {
    unawaited(_service.requestSync(SyncTrigger.syncButton));
  }

  void _onHistoryResetRequested(
    HistoryResetRequested event,
    Emitter<SyncState> emit,
  ) {
    unawaited(_service.resetHistory());
  }

  void _onSyncStatusChanged(SyncStatusChanged event, Emitter<SyncState> emit) {
    emit(SyncState(event.status));
  }

  @override
  Future<void> close() {
    _statusSub.cancel();
    return super.close();
  }
}