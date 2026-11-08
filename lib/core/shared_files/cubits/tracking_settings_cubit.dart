import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/core/shared_files/enums/user_settings_enums.dart';

class TrackingSettings extends Equatable {
  const new({this.mode = .linear, this.pomodoroMinutes = 25});

  final TrackingMode mode;
  final int pomodoroMinutes;

  bool get isPomodoro => mode == TrackingMode.pomodoro;

  @override
  List<Object?> get props => [mode, pomodoroMinutes];
}

class TrackingSettingsCubit extends Cubit<TrackingSettings> {
  new() : super(const TrackingSettings());

  final _dao = getIt<LocalDatabase>().userSettingsDao;

  /// Loads the active account's tracking mode (after sign-in or an account switch).
  Future<void> load() async {
    final settings = await _dao.getSettings();
    if (isClosed) return;
    emit(
      TrackingSettings(
        mode: settings.trackingMode,
        pomodoroMinutes: state.pomodoroMinutes,
      ),
    );
  }

  Future<void> setMode(TrackingMode mode) async {
    emit(TrackingSettings(mode: mode, pomodoroMinutes: state.pomodoroMinutes));
    await _dao.setTrackingMode(mode);
  }

  void setPomodoroMinutes(int minutes) =>
      emit(TrackingSettings(mode: state.mode, pomodoroMinutes: minutes));
}