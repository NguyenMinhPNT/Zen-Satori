import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/quotes/widgets/centered_quote_panel.dart';
import '../../home/presentation/home_tab.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/zen_header.dart';
import '../../projects/presentation/project_cubit.dart';
import 'timer_cubit.dart';

class PomodoroTimerScreen extends StatefulWidget {
  const PomodoroTimerScreen({super.key, required this.originTab});

  final HomeTab originTab;

  @override
  State<PomodoroTimerScreen> createState() => _PomodoroTimerScreenState();
}

class _PomodoroTimerScreenState extends State<PomodoroTimerScreen> {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _maybeStartTimer();
      }
    });
  }

  void _maybeStartTimer() {
    if (_started) {
      return;
    }
    final project = context.read<ProjectCubit>().state.selectedProject;
    if (project == null) {
      return;
    }
    _started = true;
    context.read<PomodoroTimerCubit>().startWork(
      project.id,
      locale: Localizations.maybeLocaleOf(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return BlocListener<ProjectCubit, ProjectState>(
      listenWhen: (previous, current) {
        return previous.selectedProject?.id != current.selectedProject?.id;
      },
      listener: (context, state) {
        _maybeStartTimer();
      },
      child: Scaffold(
        backgroundColor: colors.paper,
        body: SafeArea(
          child: BlocBuilder<PomodoroTimerCubit, PomodoroTimerState>(
            builder: (context, state) {
              final hasProject =
                  context.watch<ProjectCubit>().state.selectedProject != null;
              return Column(
                children: [
                  ZenHeader(
                    title: 'Pomodoro',
                    showBack: false,
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
                                onPressed: () =>
                                    context.go(HomeTab.projects.location),
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
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 34),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final timerFontSize = (constraints.maxWidth * 0.26)
                                .clamp(64.0, 112.0);
                            final quoteHeight = (constraints.maxHeight * 0.32)
                                .clamp(160.0, 230.0);
                            return Column(
                              children: [
                                SizedBox(
                                  height: quoteHeight,
                                  child: CenteredQuotePanel(
                                    quote: state.activeQuote,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Expanded(
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        state.displayTime,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: timerFontSize,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -1.5,
                                          height: 0.95,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                _PomodoroTimerActions(
                                  state: state,
                                  originTab: widget.originTab,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PomodoroTimerActions extends StatelessWidget {
  const _PomodoroTimerActions({required this.state, required this.originTab});

  final PomodoroTimerState state;
  final HomeTab originTab;

  Future<void> _confirmEndSession(BuildContext context) async {
    final shouldGiveUp = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Give up?'),
          content: const Text('Are you sure you want to give up this session?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Give Up'),
            ),
          ],
        );
      },
    );

    if (shouldGiveUp == true && context.mounted) {
      context.read<PomodoroTimerCubit>().reset();
      context.go(originTab.location);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PomodoroTimerCubit>();
    if (state.phase == PomodoroTimerPhase.workCompleteAwaitingRelax) {
      return FilledButton(
        onPressed: cubit.startRelax,
        child: const Text('Start 5-Min Relax'),
      );
    }
    if (state.phase == PomodoroTimerPhase.sessionFinished) {
      return FilledButton(
        onPressed: () {
          cubit.reset();
          context.go(originTab.location);
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
          onPressed: () => _confirmEndSession(context),
          icon: const Icon(Icons.close),
          label: const Text('End'),
        ),
      ],
    );
  }
}
