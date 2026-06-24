import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import 'activity_type.dart';
import 'project_status.dart';

class ProjectRepository {
  ProjectRepository(this._database);

  final AppDatabase _database;

  Stream<List<Project>> watchProjects() {
    final query = _database.select(_database.projects)
      ..orderBy([(project) => OrderingTerm.desc(project.updatedAt)]);
    return query.watch();
  }

  Future<List<Project>> getProjects() {
    final query = _database.select(_database.projects)
      ..orderBy([(project) => OrderingTerm.desc(project.updatedAt)]);
    return query.get();
  }

  Future<int> createProject({
    required String title,
    ActivityType type = ActivityType.project,
    String? detail,
    DateTime? startDate,
    DateTime? deadline,
    int? targetMinutes,
    int? frequencyCount,
    ActivityFrequencyPeriod? frequencyPeriod,
  }) {
    final now = DateTime.now();
    final normalized = _normalizeActivityFields(
      type: type,
      deadline: deadline,
      targetMinutes: targetMinutes,
      frequencyCount: frequencyCount,
      frequencyPeriod: frequencyPeriod,
    );
    return _database
        .into(_database.projects)
        .insert(
          ProjectsCompanion(
            title: Value(title.trim()),
            activityType: Value(type.storageValue),
            targetMinutes: Value(normalized.targetMinutes),
            status: Value(ProjectStatus.ongoing.label),
            detail: Value(detail),
            startDate: Value(startDate),
            deadline: Value(normalized.deadline),
            frequencyCount: Value(normalized.frequencyCount),
            frequencyPeriod: Value(normalized.frequencyPeriod),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
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
    final normalized = _normalizeActivityFields(
      type: type,
      deadline: deadline,
      targetMinutes: targetMinutes,
      frequencyCount: frequencyCount,
      frequencyPeriod: frequencyPeriod,
    );
    return (_database.update(
      _database.projects,
    )..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(
        title: Value(title.trim()),
        activityType: Value(type.storageValue),
        targetMinutes: Value(normalized.targetMinutes),
        status: Value(status.label),
        detail: Value(detail),
        startDate: Value(startDate),
        deadline: Value(normalized.deadline),
        frequencyCount: Value(normalized.frequencyCount),
        frequencyPeriod: Value(normalized.frequencyPeriod),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteProject(int id) {
    return (_database.delete(
      _database.projects,
    )..where((p) => p.id.equals(id))).go();
  }

  _NormalizedActivityFields _normalizeActivityFields({
    required ActivityType type,
    DateTime? deadline,
    int? targetMinutes,
    int? frequencyCount,
    ActivityFrequencyPeriod? frequencyPeriod,
  }) {
    return switch (type) {
      ActivityType.project => _NormalizedActivityFields(
        deadline: deadline,
        targetMinutes: targetMinutes ?? 0,
        frequencyCount: null,
        frequencyPeriod: null,
      ),
      ActivityType.routine => _NormalizedActivityFields(
        deadline: null,
        targetMinutes: 0,
        frequencyCount: frequencyCount,
        frequencyPeriod: frequencyPeriod?.storageValue,
      ),
    };
  }
}

class _NormalizedActivityFields {
  const _NormalizedActivityFields({
    required this.deadline,
    required this.targetMinutes,
    required this.frequencyCount,
    required this.frequencyPeriod,
  });

  final DateTime? deadline;
  final int targetMinutes;
  final int? frequencyCount;
  final String? frequencyPeriod;
}
