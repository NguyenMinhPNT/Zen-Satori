import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/assets/app_assets.dart';
import '../../../core/database/app_database.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/project_status_chip.dart';
import '../../../core/widgets/zen_app_scaffold.dart';
import '../../../core/widgets/zen_header.dart';
import '../../timer/domain/session_metrics.dart';
import '../../timer/domain/session_repository.dart';
import '../domain/project_status.dart';
import 'project_cubit.dart';
import 'widgets/project_form_sheet.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ZenAppScaffold(
      drawer: const AppDrawer(currentSection: AppDrawerSection.home),
      child: Column(
        children: [
          ZenHeader(
            title: 'Activity',
            showBack: false,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: Scaffold.of(context).openDrawer,
                  icon: const Icon(Icons.menu_rounded, size: 30),
                );
              },
            ),
          ),
          const Expanded(child: ProjectsTabContent()),
        ],
      ),
    );
  }
}

class ProjectsTabContent extends StatelessWidget {
  const ProjectsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: TextField(
            onChanged: context.read<ProjectCubit>().setQuery,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search',
              filled: true,
              fillColor: colors.mist.withValues(alpha: 0.62),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              isDense: true,
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<ProjectCubit, ProjectState>(
            builder: (context, state) {
              final projects = state.filteredProjects;
              if (!state.isLoading && state.projects.isEmpty) {
                return _EmptyProjects(
                  onCreate: () => showProjectFormSheet(context),
                );
              }

              return StreamBuilder<List<FocusSession>>(
                stream: context.read<SessionRepository>().watchSessions(),
                builder: (context, snapshot) {
                  final sessions = snapshot.data ?? const <FocusSession>[];
                  final workMinutesByProject = <int, int>{};

                  for (final session in sessions) {
                    workMinutesByProject.update(
                      session.projectId,
                      (minutes) => minutes + workedMinutesForSession(session),
                      ifAbsent: () => workedMinutesForSession(session),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                    itemCount: projects.length + 1,
                    separatorBuilder: (_, index) {
                      if (index == projects.length - 1) {
                        return const SizedBox(height: 20);
                      }

                      return Divider(
                        height: 1,
                        color: colors.ink.withValues(alpha: 0.22),
                      );
                    },
                    itemBuilder: (context, index) {
                      if (index == projects.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 6),
                          child: Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: colors.paperWarm.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: colors.ink.withValues(alpha: 0.12),
                                ),
                              ),
                              child: IconButton(
                                tooltip: 'Add activity',
                                onPressed: () => showProjectFormSheet(context),
                                icon: const Icon(Icons.add, size: 30),
                              ),
                            ),
                          ),
                        );
                      }

                      final project = projects[index];
                      final totalMinutes =
                          workMinutesByProject[project.id] ?? 0;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Image.asset(AppAssets.bamboo, width: 54),
                        title: Text(
                          '${project.title} (${_formatWorkedTime(totalMinutes)})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ProjectStatusChip(
                              status: ProjectStatus.fromLabel(project.status),
                            ),
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            showProjectFormSheet(context, project: project),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

String _formatWorkedTime(int minutes) {
  final hours = minutes ~/ 60;
  final rest = minutes % 60;

  if (hours == 0) {
    return '${rest}m';
  }
  if (rest == 0) {
    return '${hours}h';
  }
  return '${hours}h ${rest}m';
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAssets.bamboo, width: 92),
                  const SizedBox(height: 10),
                  Text('No Activities Yet', style: kaushan(size: 30)),
                  const SizedBox(height: 10),
                  const Text(
                    'Create your first focus activity to unlock sessions and stats.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: onCreate,
                    icon: const Icon(Icons.add),
                    label: const Text('Create Activity'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
