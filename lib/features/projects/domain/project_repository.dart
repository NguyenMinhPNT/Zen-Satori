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
    required int targetMinutes,
    ProjectStatus status = ProjectStatus.ongoing,
  }) {
    final now = DateTime.now();
    return _database
        .into(_database.projects)
        .insert(
          ProjectsCompanion.insert(
            title: title.trim(),
            targetMinutes: targetMinutes,
            status: status.label,
            createdAt: now,
            updatedAt: now,
          ),
        );
  }
}
