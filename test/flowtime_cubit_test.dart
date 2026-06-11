import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zen_satori/core/database/app_database.dart';
import 'package:zen_satori/features/projects/domain/project_repository.dart';
import 'package:zen_satori/features/timer/domain/session_models.dart';
import 'package:zen_satori/features/timer/domain/session_repository.dart';
import 'package:zen_satori/features/timer/presentation/flowtime_cubit.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('Flowtime saves a completed block and its interruptions', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = SessionRepository(database);
    final projectId = await ProjectRepository(
      database,
    ).createProject(title: 'Write', targetMinutes: 90);
    final clock = _MutableClock(DateTime(2026, 6, 12, 9));
    final cubit = FlowtimeCubit(repository, now: clock.call);

    cubit.startFocus(projectId);
    clock.advance(const Duration(minutes: 30));
    cubit.startInterruption(
      type: SessionInterruptionType.external,
      label: 'Slack ping',
    );
    clock.advance(const Duration(minutes: 5));
    cubit.endActiveInterruption();
    clock.advance(const Duration(minutes: 10));
    await cubit.stopFocusAndSuggestBreak();

    expect(cubit.state.phase, FlowtimePhase.breakSuggested);
    expect(cubit.state.suggestedBreakMinutes, 8);
    expect(cubit.state.completedBlocks, hasLength(1));

    final sessions = await repository.getSessions();
    expect(sessions, hasLength(1));
    expect(sessions.single.mode, FocusSessionMode.flowtime.storageValue);
    expect(sessions.single.startedAt, DateTime(2026, 6, 12, 9));
    expect(sessions.single.endedAt, DateTime(2026, 6, 12, 9, 45));
    expect(sessions.single.relaxMinutes, 8);

    final interruptions = await repository.getInterruptionsForSession(
      sessions.single.id,
    );
    expect(interruptions, hasLength(1));
    expect(
      interruptions.single.type,
      SessionInterruptionType.external.storageValue,
    );
    expect(interruptions.single.label, 'Slack ping');

    await cubit.close();
    await database.close();
  });

  test('Flowtime break suggestion follows the chosen legend', () {
    expect(suggestBreakMinutes(25), 5);
    expect(suggestBreakMinutes(26), 8);
    expect(suggestBreakMinutes(50), 8);
    expect(suggestBreakMinutes(51), 10);
    expect(suggestBreakMinutes(90), 10);
    expect(suggestBreakMinutes(91), 15);
  });

  test('Flowtime pause and resume preserve elapsed focus time', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = SessionRepository(database);
    final projectId = await ProjectRepository(
      database,
    ).createProject(title: 'Read', targetMinutes: 60);
    final clock = _MutableClock(DateTime(2026, 6, 12, 10));
    final cubit = FlowtimeCubit(repository, now: clock.call);

    cubit.startFocus(projectId);
    clock.advance(const Duration(minutes: 20));
    cubit.pause();
    expect(cubit.state.focusElapsedSeconds, 20 * 60);

    clock.advance(const Duration(minutes: 15));
    expect(cubit.state.focusElapsedSeconds, 20 * 60);

    cubit.resume();
    clock.advance(const Duration(minutes: 5));
    cubit.pause();
    expect(cubit.state.focusElapsedSeconds, 25 * 60);

    await cubit.close();
    await database.close();
  });

  test(
    'Flowtime recomputes elapsed and break completion after resume',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final repository = SessionRepository(database);
      final projectId = await ProjectRepository(
        database,
      ).createProject(title: 'Plan', targetMinutes: 120);
      final clock = _MutableClock(DateTime(2026, 6, 12, 8));
      final cubit = FlowtimeCubit(repository, now: clock.call);

      cubit.startFocus(projectId);
      cubit.setDisplayTickerActive(false);

      clock.advance(const Duration(minutes: 50));
      cubit.setDisplayTickerActive(true);
      expect(cubit.state.focusElapsedSeconds, 50 * 60);

      await cubit.stopFocusAndSuggestBreak();
      expect(cubit.state.suggestedBreakMinutes, 8);

      cubit.startBreak();
      cubit.setDisplayTickerActive(false);
      clock.advance(const Duration(minutes: 9));
      cubit.setDisplayTickerActive(true);

      expect(cubit.state.phase, FlowtimePhase.finished);

      await cubit.close();
      await database.close();
    },
  );
}

class _MutableClock {
  _MutableClock(this.value);

  DateTime value;

  DateTime call() => value;

  void advance(Duration duration) {
    value = value.add(duration);
  }
}
