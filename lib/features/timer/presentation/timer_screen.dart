import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/assets/app_assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/zen_header.dart';
import '../../projects/presentation/project_cubit.dart';
import 'timer_cubit.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final project = context.read<ProjectCubit>().state.selectedProject;
      if (mounted && project != null && !_started) {
        _started = true;
        context.read<TimerCubit>().startWork(project.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: SafeArea(
        child: BlocBuilder<TimerCubit, TimerState>(
          builder: (context, state) {
            final hasProject =
                context.read<ProjectCubit>().state.selectedProject != null;
            return Column(
              children: [
                ZenHeader(
                  title: 'Countdown',
                  trailing: const SizedBox.shrink(),
                ),
                const SizedBox(height: 18),
                if (!hasProject)
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'No Project Selected',
                              style: kaushan(size: 30),
                            ),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: () => context.go('/projects'),
                              child: const Text('Create Project'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 34),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(AppAssets.ensoCircle, width: 285),
                              Text(
                                state.displayTime,
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Text(
                            _phaseLabel(state.phase),
                            style: kaushan(size: 26),
                          ),
                          const SizedBox(height: 18),
                          _TimerActions(state: state),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _phaseLabel(TimerPhase phase) {
    return switch (phase) {
      TimerPhase.workRunning => 'Deep Work',
      TimerPhase.workPaused => 'Paused',
      TimerPhase.workCompleteAwaitingRelax => 'Work Complete',
      TimerPhase.relaxRunning => 'Relax',
      TimerPhase.relaxPaused => 'Relax Paused',
      TimerPhase.sessionFinished => 'Session Finished',
      TimerPhase.idle => 'Preparing',
    };
  }
}

class _TimerActions extends StatelessWidget {
  const _TimerActions({required this.state});

  final TimerState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TimerCubit>();
    if (state.phase == TimerPhase.workCompleteAwaitingRelax) {
      return FilledButton(
        onPressed: cubit.startRelax,
        child: const Text('Start 5-Min Relax'),
      );
    }
    if (state.phase == TimerPhase.sessionFinished) {
      return FilledButton(
        onPressed: () {
          cubit.reset();
          context.go('/home');
        },
        child: const Text('Return Home'),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: state.isRunning ? cubit.pause : cubit.resume,
          icon: Icon(state.isRunning ? Icons.pause : Icons.play_arrow),
          label: Text(state.isRunning ? 'Pause' : 'Resume'),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: () {
            cubit.reset();
            context.go('/home');
          },
          icon: const Icon(Icons.close),
          label: const Text('End'),
        ),
      ],
    );
  }
}
