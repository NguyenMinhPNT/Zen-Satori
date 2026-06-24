import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/assets/app_assets.dart';
import '../../../core/database/app_database.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/enso_button.dart';
import '../../../core/widgets/zen_app_scaffold.dart';
import '../../projects/presentation/project_cubit.dart';
import '../../projects/presentation/projects_screen.dart';
import '../../projects/presentation/widgets/project_form_sheet.dart';
import '../../settings/domain/focus_mode.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../timer/domain/session_metrics.dart';
import '../../timer/domain/session_repository.dart';
import 'home_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.tab});

  final HomeTab tab;

  Future<void> _handleStartSession(
    BuildContext context,
    FocusMode focusMode,
  ) async {
    final selectedProject = context.read<ProjectCubit>().state.selectedProject;
    if (selectedProject == null) {
      return;
    }
    await context.read<SettingsCubit>().setFocusMode(focusMode);
    if (!context.mounted) {
      return;
    }
    context.go('/timer?origin=${tab.routeValue}');
  }

  @override
  Widget build(BuildContext context) {
    return ZenAppScaffold(
      drawer: const AppDrawer(currentSection: AppDrawerSection.home),
      bottomNavigationBar: _HomeBottomNavigation(currentTab: tab),
      child: Column(
        children: [
          _HomeTopBar(tab: tab),
          Expanded(
            child: _HomeTabBody(tab: tab, onStartSession: _handleStartSession),
          ),
        ],
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({required this.tab});

  final HomeTab tab;

  @override
  Widget build(BuildContext context) {
    final title = switch (tab) {
      HomeTab.projects => 'Activity',
      HomeTab.pomodoro => 'Pomodoro',
      HomeTab.guruAi => 'Guru AI',
      HomeTab.flowtime => 'Home',
      HomeTab.zen => 'Zen',
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 20, 8),
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                tooltip: 'Open menu',
                onPressed: Scaffold.of(context).openDrawer,
                icon: const Icon(Icons.menu_rounded, size: 34),
              );
            },
          ),
          const Spacer(),
          if (tab == HomeTab.projects ||
              tab == HomeTab.guruAi ||
              tab == HomeTab.zen)
            Text(title, style: kaushan(size: 28))
          else
            const SizedBox.shrink(),
          if (tab == HomeTab.projects ||
              tab == HomeTab.guruAi ||
              tab == HomeTab.zen)
            const Spacer()
          else
            const Spacer(),
          Image.asset(AppAssets.trien, width: 48, fit: BoxFit.contain),
        ],
      ),
    );
  }
}

class _HomeTabBody extends StatelessWidget {
  const _HomeTabBody({required this.tab, required this.onStartSession});

  final HomeTab tab;
  final Future<void> Function(BuildContext, FocusMode) onStartSession;

  @override
  Widget build(BuildContext context) {
    switch (tab) {
      case HomeTab.projects:
        return const ProjectsTabContent();
      case HomeTab.pomodoro:
        return _FocusDashboard(
          title: 'Ready to Focus?',
          modeLabel: 'Pomodoro Mode',
          onStartSession: () => onStartSession(context, FocusMode.pomodoro),
        );
      case HomeTab.guruAi:
        return const _PlaceholderTab(
          assetPath: AppAssets.guruAiNavIcon,
          title: 'Guru AI',
          message: 'Guided AI focus support is coming soon.',
        );
      case HomeTab.flowtime:
        return _FocusDashboard(
          title: 'Ready to Get to Work?',
          modeLabel: 'Flowtime Mode',
          onStartSession: () => onStartSession(context, FocusMode.flowtime),
        );
      case HomeTab.zen:
        return const _PlaceholderTab(
          assetPath: AppAssets.zenIcon,
          title: 'Zen',
          message: 'Zen practice content will arrive in a later update.',
        );
    }
  }
}

class _FocusDashboard extends StatelessWidget {
  const _FocusDashboard({
    required this.title,
    required this.modeLabel,
    required this.onStartSession,
  });

  final String title;
  final String modeLabel;
  final VoidCallback onStartSession;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        final selectedProject = state.selectedProject;
        final colors = AppTheme.of(context);
        return LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 520;
            final buttonSize = compact ? 150.0 : 210.0;
            final titleSize = compact ? 24.0 : 31.0;
            final modeSize = compact ? 22.0 : 29.0;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 18,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ProjectSelector(state: state),
                    SizedBox(height: compact ? 12 : 28),
                    Text(
                      selectedProject == null
                          ? 'Create an Activity to Begin'
                          : title,
                      textAlign: TextAlign.center,
                      style: kaushan(size: titleSize),
                    ),
                    SizedBox(height: compact ? 10 : 16),
                    Center(
                      child: EnsoButton(
                        size: buttonSize,
                        enabled: selectedProject != null,
                        onPressed: selectedProject == null
                            ? null
                            : onStartSession,
                      ),
                    ),
                    SizedBox(height: compact ? 8 : 12),
                    Text(
                      modeLabel,
                      textAlign: TextAlign.center,
                      style: kaushan(
                        size: modeSize,
                        color: selectedProject == null
                            ? colors.ink.withValues(alpha: 0.45)
                            : colors.ink,
                      ),
                    ),
                    SizedBox(height: compact ? 8 : 14),
                    if (selectedProject == null)
                      Center(
                        child: SizedBox(
                          width: 190,
                          child: FilledButton.icon(
                            onPressed: () => showProjectFormSheet(context),
                            icon: const Icon(Icons.add),
                            label: const Text('Create Activity'),
                          ),
                        ),
                      )
                    else
                      SizedBox(height: compact ? 4 : 8),
                    SizedBox(height: compact ? 12 : 22),
                    _HomeStats(project: selectedProject),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.assetPath,
    required this.title,
    required this.message,
  });

  final String assetPath;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  assetPath,
                  width: constraints.maxHeight < 420 ? 72 : 92,
                  height: constraints.maxHeight < 420 ? 72 : 92,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                Text(title, style: kaushan(size: 34)),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, height: 1.35),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProjectSelector extends StatelessWidget {
  const _ProjectSelector({required this.state});

  final ProjectState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    final ongoingProjects = state.ongoingProjects;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.paper.withValues(alpha: 0.88),
        border: Border.all(color: colors.inkSoft.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.ink.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ongoingProjects.isEmpty
            ? const SizedBox(
                height: 64,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Current Activity: None',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            : DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: state.selectedProject?.id,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(16),
                  icon: const Icon(Icons.arrow_drop_down, size: 32),
                  items: [
                    for (final project in ongoingProjects)
                      DropdownMenuItem(
                        value: project.id,
                        child: Text(
                          'Current Activity: ${project.title}',
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (id) {
                    if (id != null) {
                      context.read<ProjectCubit>().selectProject(id);
                    }
                  },
                ),
              ),
      ),
    );
  }
}

class _HomeStats extends StatelessWidget {
  const _HomeStats({required this.project});

  final Project? project;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FocusSession>>(
      stream: project == null
          ? null
          : context.read<SessionRepository>().watchSessionsForProject(
              project!.id,
            ),
      builder: (context, snapshot) {
        final sessions = project == null
            ? const <FocusSession>[]
            : snapshot.data ?? const <FocusSession>[];
        final now = DateTime.now();
        final todayMinutes = sessions
            .where((session) => _isSameDay(session.startedAt, now))
            .fold<int>(0, (total, session) {
              return total + workedMinutesForSession(session);
            });
        final sevenDayMinutes = sessions
            .where((session) => now.difference(session.startedAt).inDays < 7)
            .fold<int>(0, (total, session) {
              return total + workedMinutesForSession(session);
            });
        final average = (sevenDayMinutes / 7).round();
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'Today: ${_formatMinutes(todayMinutes)}\n'
                '7-Day Avg: ${_formatMinutes(average)}',
                style: const TextStyle(fontSize: 19, height: 1.55),
              ),
            ),
            Column(
              children: [
                Image.asset(AppAssets.lotus, width: 92),
                Text(
                  project == null ? 'Rank: Seed' : 'Rank: Lotus Seed',
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final rest = minutes % 60;
    final paddedMinutes = rest.toString().padLeft(2, '0');
    return '${hours}h${paddedMinutes}m';
  }
}

class _HomeBottomNavigation extends StatelessWidget {
  const _HomeBottomNavigation({required this.currentTab});

  final HomeTab currentTab;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    const scale = 0.765;
    const items = [
      _HomeNavItem.icon(HomeTab.projects, Icons.menu_book_rounded),
      _HomeNavItem.asset(HomeTab.pomodoro, AppAssets.pomodoroNavIcon),
      _HomeNavItem.asset(HomeTab.guruAi, AppAssets.guruAiNavIcon),
      _HomeNavItem.asset(HomeTab.flowtime, AppAssets.ensoCircle),
      _HomeNavItem.asset(HomeTab.zen, AppAssets.zenIcon),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(8 * scale, 0, 8 * scale, 12 * scale),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.lerp(colors.paper, colors.paperWarm, 0.35) ?? colors.paper,
              Color.lerp(colors.paperWarm, colors.mist, 0.75) ??
                  colors.paperWarm,
            ],
          ),
          borderRadius: BorderRadius.circular(34 * scale),
          border: Border.all(color: colors.ink.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: colors.ink.withValues(alpha: 0.12),
              blurRadius: 22 * scale,
              offset: Offset(0, 10 * scale),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              10 * scale,
              12 * scale,
              10 * scale,
              8 * scale,
            ),
            child: Row(
              children: [
                for (final item in items)
                  Expanded(
                    child: _BottomNavButton(
                      item: item,
                      selected: item.tab == currentTab,
                      onTap: () => context.go(item.tab.location),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _HomeNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    const scale = 0.765;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24 * scale),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4 * scale),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.assetPath != null)
              Image.asset(
                item.assetPath!,
                width: (item.tab == HomeTab.flowtime ? 46 : 42) * scale,
                height: (item.tab == HomeTab.flowtime ? 46 : 42) * scale,
                fit: BoxFit.contain,
              )
            else
              Icon(
                item.iconData,
                size: (item.tab == HomeTab.flowtime ? 46 : 42) * scale,
              ),
            SizedBox(height: 6 * scale),
            Text(
              item.tab.label,
              style: TextStyle(
                fontSize: 13 * scale,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8 * scale),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: selected ? 1 : 0,
              child: Container(
                width: 56 * scale,
                height: 5 * scale,
                decoration: BoxDecoration(
                  color: colors.ink,
                  borderRadius: BorderRadius.circular(999 * scale),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeNavItem {
  const _HomeNavItem.asset(this.tab, this.assetPath) : iconData = null;
  const _HomeNavItem.icon(this.tab, this.iconData) : assetPath = null;

  final HomeTab tab;
  final String? assetPath;
  final IconData? iconData;
}
