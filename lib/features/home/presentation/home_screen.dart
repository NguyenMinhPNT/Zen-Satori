import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/assets/app_assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/enso_button.dart';
import '../../../core/widgets/zen_app_scaffold.dart';
import '../../../core/database/app_database.dart';
import '../../projects/presentation/project_cubit.dart';
import '../../projects/presentation/widgets/project_form_sheet.dart';
import '../../timer/domain/session_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ZenAppScaffold(
      currentIndex: 0,
      child: BlocBuilder<ProjectCubit, ProjectState>(
        builder: (context, state) {
          final selectedProject = state.selectedProject;
          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 110),
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Image.asset(AppAssets.trien, fit: BoxFit.contain),
                ),
              ),
              _ProjectSelector(state: state),
              const SizedBox(height: 38),
              Text(
                selectedProject == null
                    ? 'Create a Project to Begin'
                    : 'Ready to Get to Work?',
                textAlign: TextAlign.center,
                style: kaushan(size: 33),
              ),
              const SizedBox(height: 22),
              Center(
                child: EnsoButton(
                  enabled: selectedProject != null,
                  onPressed: selectedProject == null
                      ? null
                      : () => context.go('/timer'),
                ),
              ),
              const SizedBox(height: 16),
              if (selectedProject == null)
                Center(
                  child: SizedBox(
                    width: 180,
                    child: FilledButton.icon(
                      onPressed: () => showProjectFormSheet(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Project'),
                    ),
                  ),
                )
              else
                Text(
                  'Ready to Get to Work?',
                  textAlign: TextAlign.center,
                  style: kaushan(size: 27),
                ),
              const SizedBox(height: 36),
              _HomeStats(project: selectedProject),
            ],
          );
        },
      ),
    );
  }
}

class _ProjectSelector extends StatelessWidget {
  const _ProjectSelector({required this.state});

  final ProjectState state;

  @override
  Widget build(BuildContext context) {
    final ongoingProjects = state.ongoingProjects;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.paper.withValues(alpha: 0.82),
        border: Border.all(color: AppTheme.inkSoft.withValues(alpha: 0.42)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ongoingProjects.isEmpty
            ? const SizedBox(
                height: 54,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Current Project: None'),
                ),
              )
            : DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: state.selectedProject?.id,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: [
                    for (final project in ongoingProjects)
                      DropdownMenuItem(
                        value: project.id,
                        child: Text('Current Project: ${project.title}'),
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
      stream: context.read<SessionRepository>().watchSessions(),
      builder: (context, snapshot) {
        final sessions = snapshot.data ?? const <FocusSession>[];
        final now = DateTime.now();
        final todayMinutes = sessions
            .where((session) => _isSameDay(session.startedAt, now))
            .fold<int>(0, (total, session) => total + session.workMinutes);
        final sevenDayMinutes = sessions
            .where((session) => now.difference(session.startedAt).inDays < 7)
            .fold<int>(0, (total, session) => total + session.workMinutes);
        final average = (sevenDayMinutes / 7).round();
        return Row(
          children: [
            Expanded(
              child: Text(
                'Today: ${_formatMinutes(todayMinutes)}\n'
                '7-Day Avg: ${_formatMinutes(average)}',
                style: const TextStyle(fontSize: 19, height: 1.38),
              ),
            ),
            Column(
              children: [
                Image.asset(AppAssets.lotus, width: 88),
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
    if (hours == 0) {
      return '${rest}m';
    }
    return '${hours}h ${rest}m';
  }
}
