import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/buttons/tracking_mode_switch_button.dart'
    show TrackingType;

class TrackingSettings extends Equatable {
  const new({this.mode = TrackingType.linear, this.pomodoroMinutes = 25});

  final TrackingType mode;
  final int pomodoroMinutes;

  bool get isPomodoro => mode == TrackingType.pomodoro;

  @override
  List<Object?> get props => [mode, pomodoroMinutes];
}

class TrackingSettingsCubit extends Cubit<TrackingSettings> {
  new() : super(const TrackingSettings());

  void setMode(TrackingType mode) => emit(
    TrackingSettings(mode: mode, pomodoroMinutes: state.pomodoroMinutes),
  );

  void setPomodoroMinutes(int minutes) =>
      emit(TrackingSettings(mode: state.mode, pomodoroMinutes: minutes));
}
