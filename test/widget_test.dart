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
    expect(find.text('Tap here to Begin'), findsOneWidget);
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
    expect(find.byType(EnsoButton), findsOneWidget);
    await _disposeHarness(tester);
  });

  testWidgets('Drawer opens from top-level pages', (tester) async {
    final routes = <String, String>{
      '/home?tab=flowtime': 'Create a Project to Begin',
      '/achievements': 'Path to Satori',
      '/stats': 'Insights',
      '/settings': 'Sounds (Zen Bell)',
    };

    for (final entry in routes.entries) {
      final harness = await _createHarness(initialLocation: entry.key);
      await tester.pumpWidget(harness.app);
      await _pumpFrames(tester);

      expect(find.text(entry.value), findsOneWidget);
      await tester.tap(find.byIcon(Icons.menu_rounded).first);
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Achievements'), findsWidgets);
      expect(find.text('Stats'), findsWidgets);
      expect(find.text('Settings'), findsWidgets);

      await _disposeHarness(tester);
    }
  });

  testWidgets('Drawer Home resets active home tab to Flowtime', (tester) async {
    final harness = await _createHarness(initialLocation: '/home?tab=zen');
    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    expect(
      find.text('Zen practice content will arrive in a later update.'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.menu_rounded).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.byType(EnsoButton), findsOneWidget);
    expect(
      find.text('Zen practice content will arrive in a later update.'),
      findsNothing,
    );
    await _disposeHarness(tester);
  });

  testWidgets('Bottom navigation switches among home tabs', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    final harness = await _createHarness();
    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();
    expect(find.text('Search'), findsOneWidget);

    await tester.tap(find.text('Pomodoro'));
    await tester.pumpAndSettle();
    expect(find.text('Pomodoro Mode'), findsOneWidget);

    await tester.tap(find.text('Guru AI'));
    await tester.pumpAndSettle();
    expect(
      find.text('Guided AI focus support is coming soon.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Zen'));
    await tester.pumpAndSettle();
    expect(
      find.text('Zen practice content will arrive in a later update.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Flowtime'));
    await tester.pumpAndSettle();
    expect(find.byType(EnsoButton), findsOneWidget);
    await _disposeHarness(tester);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Flowtime tab start launches Flowtime timer and sets mode', (
    tester,
  ) async {
    final harness = await _createHarness();
    await harness.projectRepository.createProject(
      title: 'Morning Practice',
      targetMinutes: 120,
    );

    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    await tester.tap(find.byType(EnsoButton));
    await _pumpFrames(tester);

    expect(harness.preferences.focusMode, FocusMode.flowtime);
    expect(find.text('Session Journal'), findsOneWidget);
    await _disposeHarness(tester);
  });

  testWidgets('Pomodoro tab start launches Pomodoro timer and sets mode', (
    tester,
  ) async {
    final harness = await _createHarness();
    await harness.projectRepository.createProject(
      title: 'Morning Practice',
      targetMinutes: 120,
    );

    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    await tester.tap(find.text('Pomodoro'));
    await _pumpFrames(tester);
    await tester.tap(find.byType(EnsoButton));
    await _pumpFrames(tester);

    expect(harness.preferences.focusMode, FocusMode.pomodoro);
    expect(find.text('25:00'), findsOneWidget);
    await _disposeHarness(tester);
  });

  testWidgets('Ending Pomodoro returns to the originating home tab', (
    tester,
  ) async {
    final harness = await _createHarness();
    await harness.projectRepository.createProject(
      title: 'Morning Practice',
      targetMinutes: 120,
    );

    await tester.pumpWidget(harness.app);
    await _pumpFrames(tester);

    await tester.tap(find.text('Pomodoro'));
    await _pumpFrames(tester);
    await tester.tap(find.byType(EnsoButton));
    await _pumpFrames(tester);

    await tester.tap(find.text('End'));
    await _pumpFrames(tester);
    await tester.tap(find.text('Give Up'));
    await _pumpFrames(tester);

    expect(find.text('Pomodoro Mode'), findsOneWidget);
    await _disposeHarness(tester);
  });

  testWidgets(
    'Settings keeps remaining toggles and removes focus mode toggles',
    (tester) async {
      final harness = await _createHarness();
      await tester.pumpWidget(harness.app);
      await _pumpFrames(tester);

      await tester.tap(find.byIcon(Icons.menu_rounded).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Sounds (Zen Bell)'), findsOneWidget);
      expect(find.text('Vibrate'), findsOneWidget);
      expect(find.text('Schedule Reminders'), findsOneWidget);
      expect(find.text('Flowtime Mode'), findsNothing);
      expect(find.text('Pomodoro Mode'), findsNothing);

      await tester.tap(find.text('Vibrate'));
      await _pumpFrames(tester);
      expect(harness.preferences.vibrateEnabled, isFalse);
      await _disposeHarness(tester);
    },
  );

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
