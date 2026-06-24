import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/database/app_database.dart';
import '../domain/activity_type.dart';
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

  List<Project> get ongoingProjects {
    return projects.where((project) {
      return ProjectStatus.fromLabel(project.status) == ProjectStatus.ongoing;
    }).toList();
  }

  Project? get selectedProject {
    for (final project in ongoingProjects) {
      if (project.id == selectedProjectId) {
        return project;
      }
    }
    return ongoingProjects.isEmpty ? null : ongoingProjects.first;
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
    final ongoingProjects = projects.where((project) {
      return ProjectStatus.fromLabel(project.status) == ProjectStatus.ongoing;
    }).toList();
    final selectedExists = ongoingProjects.any((project) {
      return project.id == state.selectedProjectId;
    });
    final selectedProjectId = selectedExists
        ? state.selectedProjectId
        : ongoingProjects.isEmpty
        ? null
        : ongoingProjects.first.id;
    emit(
      state.copyWith(
        projects: projects,
        selectedProjectId: selectedProjectId,
        clearSelectedProject: selectedProjectId == null,
        isLoading: false,
      ),
    );
  }

  void selectProject(int projectId) {
    final isOngoingProject = state.ongoingProjects.any((project) {
      return project.id == projectId;
    });
    if (!isOngoingProject) {
      return;
    }
    emit(state.copyWith(selectedProjectId: projectId));
  }

  void setQuery(String query) {
    emit(state.copyWith(query: query));
  }

  Future<void> createProject({
    required String title,
    ActivityType type = ActivityType.project,
    String? detail,
    DateTime? startDate,
    DateTime? deadline,
    int? targetMinutes,
    int? frequencyCount,
    ActivityFrequencyPeriod? frequencyPeriod,
  }) async {
    final id = await _repository.createProject(
      title: title,
      type: type,
      detail: detail,
      startDate: startDate,
      deadline: deadline,
      targetMinutes: targetMinutes,
      frequencyCount: frequencyCount,
      frequencyPeriod: frequencyPeriod,
    );
    emit(state.copyWith(selectedProjectId: id));
  }

  Future<void> updateProject({
    required int id,
    required String title,
    required ActivityType type,
    required ProjectStatus status,
    String? detail,
    DateTime? startDate,
    DateTime? deadline,
    int? targetMinutes,
    int? frequencyCount,
    ActivityFrequencyPeriod? frequencyPeriod,
  }) {
    return _repository.updateProject(
      id: id,
      title: title,
      type: type,
      status: status,
      detail: detail,
      startDate: startDate,
      deadline: deadline,
      targetMinutes: targetMinutes,
      frequencyCount: frequencyCount,
      frequencyPeriod: frequencyPeriod,
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
