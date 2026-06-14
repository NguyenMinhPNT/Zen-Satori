import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_satori/app.dart';
import 'package:zen_satori/core/database/app_database.dart';
import 'package:zen_satori/core/widgets/enso_button.dart';
import 'package:zen_satori/features/projects/domain/project_repository.dart';
import 'package:zen_satori/features/settings/domain/app_preferences.dart';
import 'package:zen_satori/features/settings/domain/focus_mode.dart';
import 'package:zen_satori/features/timer/domain/session_models.dart';
import 'package:zen_satori/features/timer/domain/session_repository.dart';
import 'package:zen_satori/features/timer/presentation/timer_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('Splash screen renders title and entry action', (tester) async {
    final harness = await _createHarness(initialLocation: '/splash');
    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    expect(find.text('Zen Satori'), findsOneWidget);
    expect(find.text('Deep Work Tracker'), findsOneWidget);
    expect(find.text('Tap to Begin'), findsOneWidget);
    await _disposeHarness(tester);
  });

  test('AppPreferences persists hasBegun flag', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = AppPreferences(await SharedPreferences.getInstance());

    expect(preferences.hasBegun, isFalse);

    await preferences.setHasBegun(true);

    expect(preferences.hasBegun, isTrue);
  });

  testWidgets('Home disables Start Session until a project exists', (
    tester,
  ) async {
    final harness = await _createHarness();
    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    expect(find.text('Create a Project to Begin'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    await _disposeHarness(tester);
  });

  testWidgets('Start Session warns when no mode is selected', (tester) async {
    final harness = await _createHarness();
    await harness.projectRepository.createProject(
      title: 'Morning Practice',
      targetMinutes: 120,
    );

    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    await tester.tap(find.byType(EnsoButton));
    await _pumpFrames(tester);

    expect(find.text('Choose a focus mode'), findsOneWidget);

    await tester.tap(find.text('Open Settings'));
    await _pumpFrames(tester);

    expect(find.text('Flowtime Mode'), findsOneWidget);
    await _disposeHarness(tester);
  });

  testWidgets('Settings focus mode toggles are mutually exclusive', (
    tester,
  ) async {
    final harness = await _createHarness();
    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    await tester.tap(find.text('Settings'));
    await _pumpFrames(tester);

    await tester.tap(find.text('Flowtime Mode'));
    await _pumpFrames(tester);
    expect(harness.preferences.focusMode, FocusMode.flowtime);

    await tester.tap(find.text('Pomodoro Mode'));
    await _pumpFrames(tester);
    expect(harness.preferences.focusMode, FocusMode.pomodoro);

    await tester.tap(find.text('Pomodoro Mode'));
    await _pumpFrames(tester);
    expect(harness.preferences.focusMode, FocusMode.none);
    await _disposeHarness(tester);
  });

  testWidgets('Pomodoro mode opens Pomodoro timer screen', (tester) async {
    final harness = await _createHarness(
      initialValues: {
        AppPreferences.focusModeKey: FocusMode.pomodoro.storageValue,
      },
    );
    await harness.projectRepository.createProject(
      title: 'Morning Practice',
      targetMinutes: 120,
    );

    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    await tester.tap(find.byType(EnsoButton));
    await _pumpFrames(tester);

    expect(find.text('Pomodoro'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
    await _disposeHarness(tester);
  });

  testWidgets('Flowtime mode opens Flowtime screen', (tester) async {
    final harness = await _createHarness(
      initialValues: {
        AppPreferences.focusModeKey: FocusMode.flowtime.storageValue,
      },
    );
    await harness.projectRepository.createProject(
      title: 'Morning Practice',
      targetMinutes: 120,
    );

    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    await tester.tap(find.byType(EnsoButton));
    await _pumpFrames(tester);

    expect(find.text('Flowtime'), findsOneWidget);
    expect(find.text('Session Journal'), findsOneWidget);
    await _disposeHarness(tester);
  });

  test('Pomodoro timer waits for user action before relax starts', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = SessionRepository(database);
    final projectId = await ProjectRepository(
      database,
    ).createProject(title: 'Practice', targetMinutes: 60);
    final cubit = PomodoroTimerCubit(repository);

    cubit.startWork(projectId);
    await cubit.elapseSeconds(PomodoroTimerCubit.workSeconds);

    expect(cubit.state.phase, PomodoroTimerPhase.workCompleteAwaitingRelax);
    expect(cubit.state.displayTime, '00:00');

    final sessions = await repository.getSessions();
    expect(sessions, hasLength(1));
    expect(sessions.single.mode, FocusSessionMode.pomodoro.storageValue);

    cubit.startRelax();
    expect(cubit.state.phase, PomodoroTimerPhase.relaxRunning);
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

Future<_Harness> _createHarness({
  Map<String, Object> initialValues = const {},
  String initialLocation = '/home',
}) async {
  SharedPreferences.setMockInitialValues(initialValues);
  final database = AppDatabase(NativeDatabase.memory());
  final preferences = AppPreferences(await SharedPreferences.getInstance());
  return _Harness(
    app: ZenSatoriApp(
      database: database,
      preferences: preferences,
      initialLocation: initialLocation,
    ),
    database: database,
    projectRepository: ProjectRepository(database),
    preferences: preferences,
  );
}

Future<void> _disposeHarness(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
  await tester.pump(const Duration(milliseconds: 1));
}

Future<void> _pumpFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 120));
  await tester.pump();
}
