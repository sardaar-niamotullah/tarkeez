import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tarkeez/core/shared_files/buttons/tracking_mode_switch_button.dart'
//     show TrackingType;

enum TrackingMode { linear, pomodoro }

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

  void setMode(TrackingMode mode) => emit(
    TrackingSettings(mode: mode, pomodoroMinutes: state.pomodoroMinutes),
  );

  void setPomodoroMinutes(int minutes) =>
      emit(TrackingSettings(mode: state.mode, pomodoroMinutes: minutes));
}
