import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/time_logs/data/models/time_log_model.dart';
import 'package:tarkeez/features/time_logs/data/repositories/time_log_repository.dart';

part 'time_log_event.dart';
part 'time_log_state.dart';

class TimeLogBloc extends Bloc<TimeLogEvent, TimeLogState> {
  final TimeLogRepository _repository;

  TimeLogBloc(this._repository) : super(TimeLogInitial()) {
    on<EntryTimeLogRequested>(_onEntryTimeLogRequested);
    on<FetchTimeLogsRequested>(_onFetchTimeLogsRequested);
  }

  List<TimeLogModel> _currentTimeLogs() {
    final s = state;
    if (s is TimeLogLoaded) return s.timeLogs;
    if (s is TimeLogFailure) return s.timeLogs;
    if (s is TimeLogLoading) return s.timeLogs;
    return const [];
  }

  List<(DateTime, DateTime)> _splitByLocalDay(
    DateTime startedAt,
    DateTime endedAt,
  ) {
    final segments = <(DateTime, DateTime)>[];
    var segmentStart = startedAt;

    while (true) {
      final localStart = segmentStart.toLocal();
      final nextLocalMidnight = DateTime(
        localStart.year,
        localStart.month,
        localStart.day,
      ).add(const Duration(days: 1));
      if (!nextLocalMidnight.isBefore(endedAt.toLocal())) {
        segments.add((segmentStart, endedAt));
        break;
      }
      segments.add((segmentStart, nextLocalMidnight));
      segmentStart = nextLocalMidnight;
    }
    return segments;
  }

  Future<void> _onFetchTimeLogsRequested(
    FetchTimeLogsRequested event,
    Emitter<TimeLogState> emit,
  ) async {
    emit(TimeLogLoading(timeLogs: _currentTimeLogs()));
    final result = await _repository.fetchTimeLogs();
    result.fold(
      onSuccess: (timeLogs) => emit(TimeLogLoaded(timeLogs)),
      onFailure: (error) =>
          emit(TimeLogFailure(error.message, timeLogs: _currentTimeLogs())),
    );
  }

  Future<void> _onEntryTimeLogRequested(
    EntryTimeLogRequested event,
    Emitter<TimeLogState> emit,
  ) async {
    final segments = _splitByLocalDay(event.startedAt, event.endedAt);
    final optimisticLogs = segments
        .map(
          (s) => TimeLogModel(
            startedAt: s.$1,
            endedAt: s.$2,
            userId: '',
            projectId: event.project?.id,
          ),
        )
        .toList();

    emit(TimeLogLoaded([...optimisticLogs, ..._currentTimeLogs()]));

    for (final (segStart, segEnd) in segments) {
      final result = await _repository.entryTimeLog(
        startedAt: segStart,
        endedAt: segEnd,
        project: event.project,
      );
      final failed = result.fold(
        onSuccess: (_) => null,
        onFailure: (error) => error.message,
      );
      if (failed != null) {
        emit(TimeLogFailure(failed, timeLogs: _currentTimeLogs()));
        return;
      }
    }
  }
}
