import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/assets/app_assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/project_status_chip.dart';
import '../../../core/widgets/zen_app_scaffold.dart';
import '../../../core/widgets/zen_header.dart';
import '../domain/project_status.dart';
import 'project_cubit.dart';
import 'widgets/project_form_sheet.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ZenAppScaffold(
      currentIndex: 1,
      child: Column(
        children: [
          ZenHeader(
            title: 'Projects',
            trailing: IconButton(
              tooltip: 'Add project',
              onPressed: () => showProjectFormSheet(context),
              icon: const Icon(Icons.add, size: 31),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: TextField(
              onChanged: context.read<ProjectCubit>().setQuery,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                filled: true,
                fillColor: AppTheme.mist.withValues(alpha: 0.62),
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
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 110),
                  itemCount: projects.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: AppTheme.ink.withValues(alpha: 0.22),
                  ),
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset(AppAssets.bamboo, width: 54),
                      title: Text(
                        '${project.title} (${project.targetMinutes ~/ 60}h)',
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
                      onTap: () => context.read<ProjectCubit>().selectProject(
                        project.id,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssets.bamboo, width: 92),
            const SizedBox(height: 10),
            Text('No Projects Yet', style: kaushan(size: 30)),
            const SizedBox(height: 10),
            const Text(
              'Create your first focus project to unlock sessions and stats.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Create Project'),
            ),
          ],
        ),
      ),
    );
  }
}
