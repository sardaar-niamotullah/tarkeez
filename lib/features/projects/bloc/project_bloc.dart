import 'package:bloc/bloc.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/projects/data/repositories/project_repository.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository _repository;

  ProjectBloc(this._repository) : super(ProjectInitial()) {
    on<CreateProjectsRequested>(_onCreateProjectsRequested);
    on<FetchProjectsRequested>(_onFetchProjectsRequested);
    on<UpdateProjectsRequested>(_onUpdateProjectsRequested);
    on<DeleteProjectsRequested>(_onDeleteProjectsRequested);
  }

  // ── Private helpers ─────────────────────────────────────────────────────
  /// Re-fetches from scratch after a mutation (create / update / delete).
  /// Does not emit ProjectLoading — callers decide whether the list
  /// should visibly reset while refreshing.
  Future<void> _refreshProjects(
    Emitter<ProjectState> emit, {
    bool created = false,
    bool updated = false,
    bool deleted = false,
    bool isInitialLoad = false,
  }) async {
    final previousProjects = state is ProjectLoaded
        ? (state as ProjectLoaded).projects
        : null;
    emit(
      ProjectLoading(projects: previousProjects, isInitialLoad: isInitialLoad),
    );
    final result = await _repository.fetchProjects();
    result.fold(
      onSuccess: (projects) => emit(
        ProjectLoaded(
          projects,
          isCreated: created,
          isUpdated: updated,
          isDeleted: deleted,
        ),
      ),
      onFailure: (error) => emit(ProjectFailure(error.message)),
    );
  }

  // ── Event handlers ──────────────────────────────────────────────────────
  Future<void> _onCreateProjectsRequested(
    CreateProjectsRequested event,
    Emitter<ProjectState> emit,
  ) async {
    final result = await _repository.createProject(
      name: event.name,
      colorId: event.colorId,
    );
    await result.fold(
      onSuccess: (_) => _refreshProjects(emit, created: true),
      onFailure: (error) async => emit(ProjectFailure(error.message)),
    );
  }

  Future<void> _onFetchProjectsRequested(
    FetchProjectsRequested event,
    Emitter<ProjectState> emit,
  ) async => await _refreshProjects(emit, isInitialLoad: true);

  Future<void> _onUpdateProjectsRequested(
    UpdateProjectsRequested event,
    Emitter<ProjectState> emit,
  ) async {
    final result = await _repository.updateProject(event.project);
    await result.fold(
      onSuccess: (_) => _refreshProjects(emit, updated: true),
      onFailure: (error) async => emit(ProjectFailure(error.message)),
    );
  }

  Future<void> _onDeleteProjectsRequested(
    DeleteProjectsRequested event,
    Emitter<ProjectState> emit,
  ) async {
    final deleteResult = await _repository.deleteProject(event.project);
    await deleteResult.fold(
      onSuccess: (_) => _refreshProjects(emit, deleted: true),
      onFailure: (error) async => emit(ProjectFailure(error.message)),
    );
  }
}
