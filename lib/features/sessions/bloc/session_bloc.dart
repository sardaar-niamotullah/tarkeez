import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/extensions/period_range_extension.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/sessions/data/models/session_model.dart';
import 'package:tarkeez/features/sessions/data/repositories/session_repository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  new(this._repository, Stream<void> syncedSessions) : super(SessionInitial()) {
    on<EntrySessionRequested>(_onEntrySessionRequested);
    on<FetchSessionsForPeriodRequested>(
      _onFetchSessionsForPeriodRequested,
      transformer: restartable(),
    );
    on<DeleteSessionRequested>(_onDeleteSessionRequested);
    on<SessionsSynced>(_onSessionsSynced, transformer: restartable());

    _syncSub = syncedSessions.listen((_) => add(SessionsSynced()));
  }

  final SessionRepository _repository;
  late final StreamSubscription<void> _syncSub;

  PeriodRange _period = PeriodRange.last7Days;

  // ── Private helpers ─────────────────────────────────────────────────────
  List<SessionModel> get _currentSessions => state is SessionLoaded
      ? (state as SessionLoaded).sessions
      : const <SessionModel>[];

  Future<Result<List<SessionModel>>> _fetchForCurrentPeriod() {
    final range = _period.dateRange();
    if (range == null) return _repository.fetchAllSessions();
    final (start, end) = range;
    return _repository.fetchSessionsInDateRange(
      startedAt: start,
      endedAt: DateTime(end.year, end.month, end.day + 1),
    );
  }

  Future<void> _refreshSessions(
    Emitter<SessionState> emit, {
    bool entered = false,
    bool deleted = false,
    bool isInitialLoad = false,
  }) async {
    final previousSessions = state is SessionLoaded
        ? (state as SessionLoaded).sessions
        : null;

    emit(
      SessionLoading(
        sessions: isInitialLoad ? const [] : (previousSessions ?? const []),
        isInitialLoad: isInitialLoad,
      ),
    );

    final result = await _fetchForCurrentPeriod();

    result.fold(
      onSuccess: (sessions) =>
          emit(SessionLoaded(sessions, isEntered: entered, isDeleted: deleted)),
      onFailure: (error) => emit(
        SessionFailure(error.message, sessions: previousSessions ?? const []),
      ),
    );
  }

  // ── Event handlers ──────────────────────────────────────────────────────

  Future<void> _onEntrySessionRequested(
    EntrySessionRequested event,
    Emitter<SessionState> emit,
  ) async {
    // One row for the whole session. The database triggers split it at midnight.
    final result = await _repository.entrySession(
      startedAt: event.startedAt,
      endedAt: event.endedAt,
      project: event.project,
    );

    await result.fold(
      onSuccess: (_) => _refreshSessions(emit, entered: true),
      onFailure: (error) async =>
          emit(SessionFailure(error.message, sessions: _currentSessions)),
    );
  }

  Future<void> _onFetchSessionsForPeriodRequested(
    FetchSessionsForPeriodRequested event,
    Emitter<SessionState> emit,
  ) async {
    _period = event.period;
    await _refreshSessions(emit, isInitialLoad: true);
  }

  Future<void> _onDeleteSessionRequested(
    DeleteSessionRequested event,
    Emitter<SessionState> emit,
  ) async {
    final result = await _repository.deleteSession(event.session);

    await result.fold(
      onSuccess: (_) => _refreshSessions(emit, deleted: true),
      onFailure: (error) async =>
          emit(SessionFailure(error.message, sessions: _currentSessions)),
    );
  }

  /// Silent refresh: no loading state, so the list does not flicker.
  Future<void> _onSessionsSynced(
    SessionsSynced event,
    Emitter<SessionState> emit,
  ) async {
    final result = await _fetchForCurrentPeriod();
    result.fold(
      onSuccess: (sessions) => emit(SessionLoaded.plain(sessions)),
      onFailure: (_) {},
    );
  }

  @override
  Future<void> close() {
    _syncSub.cancel();
    return super.close();
  }
}