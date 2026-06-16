import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import 'session_metrics.dart';
import 'session_models.dart';

class SessionRepository {
  SessionRepository(this._database);

  final AppDatabase _database;

  Future<int> createCompletedFocusBlock({
    required int projectId,
    required DateTime startedAt,
    required DateTime endedAt,
    required FocusSessionMode mode,
    int relaxMinutes = 0,
    List<SessionInterruptionDraft> interruptions = const [],
  }) {
    final workMinutes = workedMinutesBetween(startedAt, endedAt);
    return _database.transaction(() async {
      final sessionId = await _database
          .into(_database.focusSessions)
          .insert(
            FocusSessionsCompanion.insert(
              projectId: projectId,
              startedAt: startedAt,
              endedAt: endedAt,
              workMinutes: workMinutes,
              relaxMinutes: relaxMinutes,
              mode: Value(mode.storageValue),
              completed: true,
            ),
          );

      if (interruptions.isNotEmpty) {
        await _database.batch((batch) {
          batch.insertAll(_database.sessionInterruptions, [
            for (final interruption in interruptions)
              SessionInterruptionsCompanion.insert(
                focusSessionId: sessionId,
                type: interruption.type.storageValue,
                label: interruption.label,
                note: Value(interruption.note),
                startedAt: interruption.startedAt,
                endedAt: interruption.endedAt,
              ),
          ]);
        });
      }

      return sessionId;
    });
  }

  Stream<List<FocusSession>> watchSessions() {
    final query = _database.select(_database.focusSessions)
      ..orderBy([(session) => OrderingTerm.desc(session.startedAt)]);
    return query.watch();
  }

  Stream<List<FocusSession>> watchSessionsForProject(int projectId) {
    final query = _database.select(_database.focusSessions)
      ..where((session) => session.projectId.equals(projectId))
      ..orderBy([(session) => OrderingTerm.desc(session.startedAt)]);
    return query.watch();
  }

  Future<List<FocusSession>> getSessions() {
    final query = _database.select(_database.focusSessions)
      ..orderBy([(session) => OrderingTerm.desc(session.startedAt)]);
    return query.get();
  }

  Future<List<SessionInterruption>> getInterruptionsForSession(int sessionId) {
    final query = _database.select(_database.sessionInterruptions)
      ..where((interruption) => interruption.focusSessionId.equals(sessionId))
      ..orderBy([(interruption) => OrderingTerm.asc(interruption.startedAt)]);
    return query.get();
  }
}
