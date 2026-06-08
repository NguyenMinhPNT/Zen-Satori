import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
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
    String? detail,
    DateTime? startDate,
    DateTime? deadline,
    int? targetMinutes,
  }) {
    final now = DateTime.now();
    return _database
        .into(_database.projects)
        .insert(
          ProjectsCompanion(
            title: Value(title.trim()),
            targetMinutes: Value(targetMinutes ?? 0),
            status: Value(ProjectStatus.ongoing.label),
            detail: Value(detail),
            startDate: Value(startDate),
            deadline: Value(deadline),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> updateProject({
    required int id,
    required String title,
    required ProjectStatus status,
    String? detail,
    DateTime? startDate,
    DateTime? deadline,
  }) {
    return (_database.update(
      _database.projects,
    )..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(
        title: Value(title.trim()),
        status: Value(status.label),
        detail: Value(detail),
        startDate: Value(startDate),
        deadline: Value(deadline),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteProject(int id) {
    return (_database.delete(
      _database.projects,
    )..where((p) => p.id.equals(id))).go();
  }
}
