import '../../../core/database/app_database.dart';

int workedMinutesBetween(DateTime startedAt, DateTime endedAt) {
  final seconds = endedAt.difference(startedAt).inSeconds;
  if (seconds <= 0) {
    return 0;
  }
  return (seconds / 60).ceil();
}

int workedMinutesForSession(FocusSession session) {
  return workedMinutesBetween(session.startedAt, session.endedAt);
}
