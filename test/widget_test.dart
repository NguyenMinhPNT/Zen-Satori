import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_satori/app.dart';
import 'package:zen_satori/core/database/app_database.dart';
import 'package:zen_satori/features/projects/domain/project_repository.dart';
import 'package:zen_satori/features/settings/domain/app_preferences.dart';
import 'package:zen_satori/features/timer/domain/session_repository.dart';
import 'package:zen_satori/features/timer/presentation/timer_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('Splash routes to Home on Tap to Begin', (tester) async {
    final harness = await _createHarness();
    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    expect(find.text('Zen Satori'), findsOneWidget);

    await tester.tap(find.text('Tap to Begin'));
    await _pumpFrames(tester);

    expect(find.text('Current Project: None'), findsOneWidget);
    await _disposeHarness(tester, harness);
  });

  testWidgets('Home disables Start Session until a project exists', (
    tester,
  ) async {
    final harness = await _createHarness();
    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    await tester.tap(find.text('Tap to Begin'));
    await _pumpFrames(tester);

    expect(find.text('Create a Project to Begin'), findsOneWidget);
    expect(find.text('START\nSESSION'), findsOneWidget);
    await _disposeHarness(tester, harness);
  });

  testWidgets('Creating a project enables Start Session and opens Timer', (
    tester,
  ) async {
    final harness = await _createHarness();
    await harness.projectRepository.createProject(
      title: 'Morning Practice',
      targetMinutes: 120,
    );

    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);
    await tester.tap(find.text('Tap to Begin'));
    await _pumpFrames(tester);

    expect(find.text('Current Project: Morning Practice'), findsOneWidget);

    await tester.tap(find.text('START\nSESSION'));
    await _pumpFrames(tester);

    expect(find.text('Countdown'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
    await _disposeHarness(tester, harness);
  });

  testWidgets('Settings toggles persist through SharedPreferences', (
    tester,
  ) async {
    final harness = await _createHarness();
    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);
    await tester.tap(find.text('Tap to Begin'));
    await _pumpFrames(tester);

    await tester.tap(find.text('Settings'));
    await _pumpFrames(tester);
    await tester.tap(find.text('Sounds (Zen Bell)'));
    await _pumpFrames(tester);

    expect(harness.preferences.soundEnabled, isFalse);
    await _disposeHarness(tester, harness);
  });

  test('Timer waits for user action before relax starts', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final projectId = await ProjectRepository(
      database,
    ).createProject(title: 'Practice', targetMinutes: 60);
    final cubit = TimerCubit(SessionRepository(database));

    cubit.startWork(projectId);
    await cubit.elapseSeconds(TimerCubit.workSeconds);

    expect(cubit.state.phase, TimerPhase.workCompleteAwaitingRelax);
    expect(cubit.state.displayTime, '00:00');

    final sessions = await SessionRepository(database).getSessions();
    expect(sessions, hasLength(1));

    cubit.startRelax();
    expect(cubit.state.phase, TimerPhase.relaxRunning);
    expect(cubit.state.displayTime, '05:00');

    await cubit.close();
    await database.close();
  });
}

class _Harness {
  const _Harness({
    required this.app,
    required this.database,
    required this.projectRepository,
    required this.preferences,
  });

  final Widget app;
  final AppDatabase database;
  final ProjectRepository projectRepository;
  final AppPreferences preferences;
}

Future<_Harness> _createHarness() async {
  SharedPreferences.setMockInitialValues({});
  final database = AppDatabase(NativeDatabase.memory());
  final preferences = AppPreferences(await SharedPreferences.getInstance());
  return _Harness(
    app: ZenSatoriApp(database: database, preferences: preferences),
    database: database,
    projectRepository: ProjectRepository(database),
    preferences: preferences,
  );
}

Future<void> _disposeHarness(WidgetTester tester, _Harness harness) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
  await tester.pump(const Duration(milliseconds: 1));
}

Future<void> _pumpFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 120));
  await tester.pump();
}
