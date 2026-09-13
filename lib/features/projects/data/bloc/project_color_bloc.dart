import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/utils/color_from_hex_code.dart';
import 'package:tarkeez/features/projects/data/models/project_color_model.dart';
import 'package:tarkeez/features/projects/data/repositories/project_color_repository.dart';

part 'project_color_event.dart';
part 'project_color_state.dart';

class ProjectColorBloc
    extends Bloc<FetchProjectColorsEvent, ProjectColorState> {
  final ProjectColorRepository _repository;

  ProjectColorBloc(this._repository) : super(ProjectColorInitial()) {
    on<FetchProjectColorsEvent>((event, emit) async {
      emit(ProjectColorLoading());
      final result = await _repository.fetchProjectColors();
      result.fold(
        onSuccess: (projectColors) => emit(ProjectColorLoaded(projectColors)),
        onFailure: (error) => emit(ProjectColorFailure(error.message)),
      );
    });
  }
}
