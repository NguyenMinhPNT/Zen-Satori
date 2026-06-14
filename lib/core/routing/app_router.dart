import 'package:go_router/go_router.dart';

import '../../features/achievements/presentation/achievements_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/home_tab.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';
import '../../features/timer/presentation/timer_entry_screen.dart';

GoRouter createRouter({String initialLocation = '/splash'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final tab = HomeTab.fromRouteValue(state.uri.queryParameters['tab']);
          return HomeScreen(tab: tab);
        },
      ),
      GoRoute(
        path: '/timer',
        builder: (context, state) {
          final originTab = HomeTab.fromRouteValue(
            state.uri.queryParameters['origin'],
          );
          return TimerEntryScreen(originTab: originTab);
        },
      ),
      GoRoute(path: '/projects', redirect: (_, _) => HomeTab.projects.location),
      GoRoute(path: '/stats', builder: (context, state) => const StatsScreen()),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
