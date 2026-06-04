import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/database/app_database.dart';
import '../domain/project_repository.dart';
import '../domain/project_status.dart';

class ProjectState extends Equatable {
  const ProjectState({
    this.projects = const [],
    this.selectedProjectId,
    this.query = '',
    this.isLoading = true,
  });

  final List<Project> projects;
  final int? selectedProjectId;
  final String query;
  final bool isLoading;

  Project? get selectedProject {
    for (final project in projects) {
      if (project.id == selectedProjectId) {
        return project;
      }
    }
    return projects.isEmpty ? null : projects.first;
  }

  List<Project> get filteredProjects {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) {
      return projects;
    }
    return projects
        .where((project) => project.title.toLowerCase().contains(term))
        .toList();
  }

  ProjectState copyWith({
    List<Project>? projects,
    int? selectedProjectId,
    bool clearSelectedProject = false,
    String? query,
    bool? isLoading,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      selectedProjectId: clearSelectedProject
          ? null
          : selectedProjectId ?? this.selectedProjectId,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [projects, selectedProjectId, query, isLoading];
}

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit(this._repository) : super(const ProjectState()) {
    _subscription = _repository.watchProjects().listen(_onProjectsChanged);
  }

  final ProjectRepository _repository;
  late final StreamSubscription<List<Project>> _subscription;

  void _onProjectsChanged(List<Project> projects) {
    final selectedExists = projects.any((project) {
      return project.id == state.selectedProjectId;
    });
    emit(
      state.copyWith(
        projects: projects,
        selectedProjectId: selectedExists ? state.selectedProjectId : null,
        clearSelectedProject: !selectedExists,
        isLoading: false,
      ),
    );
  }

  void selectProject(int projectId) {
    emit(state.copyWith(selectedProjectId: projectId));
  }

  void setQuery(String query) {
    emit(state.copyWith(query: query));
  }

  Future<void> createProject({
    required String title,
    required int targetHours,
    ProjectStatus status = ProjectStatus.ongoing,
  }) async {
    final id = await _repository.createProject(
      title: title,
      targetMinutes: targetHours * 60,
      status: status,
    );
    emit(state.copyWith(selectedProjectId: id));
  }

  Future<void> updateProject({
    required int id,
    required String title,
    required int targetHours,
    required ProjectStatus status,
  }) {
    return _repository.updateProject(
      id: id,
      title: title,
      targetMinutes: targetHours * 60,
      status: status,
    );
  }

  Future<void> deleteProject(int id) async {
    await _repository.deleteProject(id);
    if (state.selectedProjectId == id) {
      emit(state.copyWith(clearSelectedProject: true));
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
