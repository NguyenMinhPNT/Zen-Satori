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

  test(
    'Flowtime saves distractions and interruptions in one completed block',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final repository = SessionRepository(database);
      final projectId = await ProjectRepository(
        database,
      ).createProject(title: 'Write', targetMinutes: 90);
      final clock = _MutableClock(DateTime(2026, 6, 12, 9));
      final cubit = FlowtimeCubit(repository, now: clock.call);

      cubit.startFocus(projectId);
      clock.advance(const Duration(minutes: 12));
      cubit.logDistraction();
      expect(cubit.state.currentBlockInterruptions, hasLength(1));
      expect(
        cubit.state.currentBlockInterruptions.single.type,
        SessionInterruptionType.distraction,
      );

      clock.advance(const Duration(minutes: 30));
      cubit.startInterruption(label: 'Phone call');
      clock.advance(const Duration(minutes: 5));
      cubit.endActiveInterruption();
      clock.advance(const Duration(minutes: 10));
      await cubit.stopFocusAndSuggestBreak();

      expect(cubit.state.phase, FlowtimePhase.breakSuggested);
      expect(cubit.state.suggestedBreakMinutes, 10);
      expect(cubit.state.completedBlocks, hasLength(1));

      final sessions = await repository.getSessions();
      expect(sessions, hasLength(1));
      expect(sessions.single.mode, FocusSessionMode.flowtime.storageValue);
      expect(sessions.single.startedAt, DateTime(2026, 6, 12, 9));
      expect(sessions.single.endedAt, DateTime(2026, 6, 12, 9, 57));
      expect(sessions.single.relaxMinutes, 10);

      final interruptions = await repository.getInterruptionsForSession(
        sessions.single.id,
      );
      expect(interruptions, hasLength(2));
      final distraction = interruptions.firstWhere(
        (item) => item.type == SessionInterruptionType.distraction.storageValue,
      );
      expect(distraction.label, SessionInterruptionType.distraction.label);
      expect(distraction.startedAt, distraction.endedAt);

      final interruption = interruptions.firstWhere(
        (item) =>
            item.type == SessionInterruptionType.interruption.storageValue,
      );
      expect(
        interruption.type,
        SessionInterruptionType.interruption.storageValue,
      );
      expect(interruption.label, 'Phone call');
      expect(interruption.note, equals(null));

      await cubit.close();
      await database.close();
    },
  );

  test('SessionInterruptionType still parses legacy interruption values', () {
    expect(
      SessionInterruptionType.fromStorage('internal'),
      SessionInterruptionType.internal,
    );
    expect(
      SessionInterruptionType.fromStorage('external'),
      SessionInterruptionType.external,
    );
    expect(
      SessionInterruptionType.fromStorage('interruption'),
      SessionInterruptionType.interruption,
    );
  });

  test('Flowtime pause still works during break running', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = SessionRepository(database);
    final projectId = await ProjectRepository(
      database,
    ).createProject(title: 'Reset', targetMinutes: 45);
    final clock = _MutableClock(DateTime(2026, 6, 12, 14));
    final cubit = FlowtimeCubit(repository, now: clock.call);

    cubit.startFocus(projectId);
    clock.advance(const Duration(minutes: 35));
    await cubit.stopFocusAndSuggestBreak();

    cubit.startBreak();
    clock.advance(const Duration(minutes: 2));
    cubit.pause();

    expect(cubit.state.phase, FlowtimePhase.breakPaused);
    expect(cubit.state.breakRemainingSeconds, 6 * 60);

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
