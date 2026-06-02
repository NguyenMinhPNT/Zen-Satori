import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class SessionRepository {
  SessionRepository(this._database);

  final AppDatabase _database;

  Future<int> createCompletedWorkSession({
    required int projectId,
    required DateTime startedAt,
    required DateTime endedAt,
    int workMinutes = 25,
    int relaxMinutes = 0,
  }) {
    return _database
        .into(_database.focusSessions)
        .insert(
          FocusSessionsCompanion.insert(
            projectId: projectId,
            startedAt: startedAt,
            endedAt: endedAt,
            workMinutes: workMinutes,
            relaxMinutes: relaxMinutes,
            completed: true,
          ),
        );
  }

  Stream<List<FocusSession>> watchSessions() {
    final query = _database.select(_database.focusSessions)
      ..orderBy([(session) => OrderingTerm.desc(session.startedAt)]);
    return query.watch();
  }

  Future<List<FocusSession>> getSessions() {
    final query = _database.select(_database.focusSessions)
      ..orderBy([(session) => OrderingTerm.desc(session.startedAt)]);
    return query.get();
  }
}
