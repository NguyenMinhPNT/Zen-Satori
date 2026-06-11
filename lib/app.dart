import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/database/app_database.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/projects/domain/project_repository.dart';
import 'features/projects/presentation/project_cubit.dart';
import 'features/settings/domain/app_preferences.dart';
import 'features/settings/presentation/settings_cubit.dart';
import 'features/timer/presentation/flowtime_cubit.dart';
import 'features/timer/domain/session_repository.dart';
import 'features/timer/presentation/timer_cubit.dart';

class ZenSatoriApp extends StatelessWidget {
  const ZenSatoriApp({
    super.key,
    required this.database,
    required this.preferences,
    this.initialLocation = '/splash',
  });

  final AppDatabase database;
  final AppPreferences preferences;
  final String initialLocation;

  @override
  Widget build(BuildContext context) {
    final projectRepository = ProjectRepository(database);
    final sessionRepository = SessionRepository(database);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: database),
        RepositoryProvider.value(value: preferences),
        RepositoryProvider.value(value: projectRepository),
        RepositoryProvider.value(value: sessionRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ProjectCubit(projectRepository)),
          BlocProvider(create: (_) => SettingsCubit(preferences)),
          BlocProvider(create: (_) => PomodoroTimerCubit(sessionRepository)),
          BlocProvider(create: (_) => FlowtimeCubit(sessionRepository)),
        ],
        child: MaterialApp.router(
          title: 'Zen Satori',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          routerConfig: createRouter(initialLocation: initialLocation),
        ),
      ),
    );
  }
}
