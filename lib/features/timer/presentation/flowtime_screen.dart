import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../home/presentation/home_tab.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/zen_header.dart';
import '../../projects/presentation/project_cubit.dart';
import '../domain/session_models.dart';
import 'flowtime_cubit.dart';

const _mutedTerracotta = Color(0xFFC27A73);
const _sageGreen = Color(0xFFA2B59F);
const _warmBeige = Color(0xFFE5D3B3);

class FlowtimerScreen extends StatefulWidget {
  const FlowtimerScreen({super.key, required this.originTab});

  final HomeTab originTab;

  @override
  State<FlowtimerScreen> createState() => _FlowtimerScreenState();
}

class _FlowtimerScreenState extends State<FlowtimerScreen>
    with WidgetsBindingObserver {
  bool _started = false;
  late final FlowtimeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<FlowtimeCubit>();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final project = context.read<ProjectCubit>().state.selectedProject;
      _cubit.setDisplayTickerActive(true);
      final canAutoStart =
          _cubit.state.phase == FlowtimePhase.idle ||
          _cubit.state.phase == FlowtimePhase.finished;
      if (mounted && project != null && !_started && canAutoStart) {
        _started = true;
        _cubit.startFocus(
          project.id,
          preserveHistory: _cubit.state.phase != FlowtimePhase.finished,
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _cubit.setDisplayTickerActive(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _cubit.setDisplayTickerActive(false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cubit.setDisplayTickerActive(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Scaffold(
      backgroundColor: colors.paper,
      body: SafeArea(
        child: BlocBuilder<FlowtimeCubit, FlowtimeState>(
          builder: (context, state) {
            final project = context.read<ProjectCubit>().state.selectedProject;
            if (project == null) {
              return Column(
                children: [
                  const ZenHeader(title: 'Flowtime', showBack: false),
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
                  ),
                ],
              );
            }

            return Column(
              children: [
                const ZenHeader(title: 'Flowtime', showBack: false),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 34),
                    children: [
                      _FlowHeroCard(projectTitle: project.title, state: state),
                      const SizedBox(height: 18),
                      if (state.suggestedBreakMinutes > 0)
                        _BreakSuggestionCard(state: state),
                      if (state.activeInterruption != null) ...[
                        const SizedBox(height: 18),
                        _ActiveInterruptionCard(
                          interruption: state.activeInterruption!,
                        ),
                      ],
                      if (state.currentBlockInterruptions.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        _CurrentInterruptionsCard(
                          interruptions: state.currentBlockInterruptions,
                        ),
                      ],
                      const SizedBox(height: 18),
                      _FlowActions(state: state, originTab: widget.originTab),
                      const SizedBox(height: 28),
                      _SessionJournal(blocks: state.completedBlocks),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FlowHeroCard extends StatelessWidget {
  const _FlowHeroCard({required this.projectTitle, required this.state});

  final String projectTitle;
  final FlowtimeState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(colors.paperWarm, colors.paper, 0.15) ??
                colors.paperWarm,
            Color.lerp(colors.paper, colors.mist, 0.24) ?? colors.paper,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.ink.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: colors.ink.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: colors.ink,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    state.phaseLabel,
                    style: TextStyle(
                      color: colors.paper,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  projectTitle,
                  style: TextStyle(
                    color: colors.inkSoft,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              state.displayTime,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: state.displayTime.length > 5 ? 66 : 78,
                fontWeight: FontWeight.w500,
                letterSpacing: -2.6,
                height: 0.9,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _subtitleForState(state),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: colors.inkSoft,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _subtitleForState(FlowtimeState state) {
    switch (state.phase) {
      case FlowtimePhase.idle:
        return 'Settle into one task and begin when ready.';
      case FlowtimePhase.focusing:
        return 'Stay with one task until you reach a natural pause.';
      case FlowtimePhase.focusPaused:
        return 'Paused without ending the block.';
      case FlowtimePhase.breakSuggested:
        return 'You completed a block. Take the suggested rest or begin again.';
      case FlowtimePhase.breakRunning:
        return 'Let the break breathe before the next deep block.';
      case FlowtimePhase.breakPaused:
        return 'Your suggested rest is paused.';
      case FlowtimePhase.finished:
        return 'Close out here or begin another flow block.';
    }
  }
}

class _BreakSuggestionCard extends StatelessWidget {
  const _BreakSuggestionCard({required this.state});

  final FlowtimeState state;

  @override
  Widget build(BuildContext context) {
    final breakText = '${state.suggestedBreakMinutes} min break';
    final colors = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.sage.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.sage.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colors.paper,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.spa_outlined),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggested: $breakText',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Flowtime legend: <=25m = 5m, <=50m = 8m, <=90m = 10m, >90m = 15m.',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.inkSoft,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveInterruptionCard extends StatelessWidget {
  const _ActiveInterruptionCard({required this.interruption});

  final FlowtimeInterruption interruption;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.amber.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.amber.withValues(alpha: 0.34)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.notifications_active_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active interruption: ${interruption.label}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    interruption.type.label,
                    style: TextStyle(color: colors.inkSoft),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentInterruptionsCard extends StatelessWidget {
  const _CurrentInterruptionsCard({required this.interruptions});

  final List<FlowtimeInterruption> interruptions;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.paperWarm,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.ink.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current block interruptions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            for (final interruption in interruptions)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${interruption.type.label}: ${interruption.label}',
                  style: const TextStyle(height: 1.3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FlowActions extends StatelessWidget {
  const _FlowActions({required this.state, required this.originTab});

  final FlowtimeState state;
  final HomeTab originTab;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FlowtimeCubit>();
    final actions = <Widget>[
      if (state.phase == FlowtimePhase.focusing ||
          state.phase == FlowtimePhase.focusPaused)
        _FlowActionButton(
          child: FilledButton.icon(
            onPressed: cubit.stopFocusAndSuggestBreak,
            icon: const Icon(Icons.local_cafe_outlined),
            label: const Text('Take a Break'),
          ),
        ),
      if (state.phase == FlowtimePhase.focusing ||
          state.phase == FlowtimePhase.breakRunning)
        _FlowActionButton(
          child: FilledButton.icon(
            onPressed: cubit.pause,
            icon: const Icon(Icons.pause),
            label: const Text('Pause'),
            style: FilledButton.styleFrom(
              backgroundColor: _sageGreen,
              foregroundColor: Colors.black,
            ),
          ),
        ),
      if (state.phase == FlowtimePhase.focusPaused ||
          state.phase == FlowtimePhase.breakPaused)
        _FlowActionButton(
          child: OutlinedButton.icon(
            onPressed: cubit.resume,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Resume'),
          ),
        ),
      if (state.phase == FlowtimePhase.breakSuggested)
        _FlowActionButton(
          child: FilledButton.icon(
            onPressed: cubit.startBreak,
            icon: const Icon(Icons.self_improvement_outlined),
            label: Text('Start ${state.suggestedBreakMinutes}m Break'),
          ),
        ),
      if (state.isBreakPhase || state.phase == FlowtimePhase.finished)
        _FlowActionButton(
          child: FilledButton.icon(
            onPressed: cubit.startNextFocus,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next Block'),
          ),
        ),
      if (state.phase == FlowtimePhase.focusing ||
          state.phase == FlowtimePhase.focusPaused)
        _FlowActionButton(
          child: FilledButton.icon(
            onPressed: () => _handleInterruption(context),
            icon: Icon(
              state.activeInterruption == null
                  ? Icons.eco_outlined
                  : Icons.notifications_off_outlined,
            ),
            label: Text(
              state.activeInterruption == null
                  ? 'Log Interruption'
                  : 'End Interruption',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: _warmBeige,
              foregroundColor: Colors.black,
            ),
          ),
        ),
      if (state.phase != FlowtimePhase.idle)
        _FlowActionButton(
          child: FilledButton.icon(
            onPressed: () => _confirmEndSession(context),
            icon: const Icon(Icons.close),
            label: const Text('End Session'),
            style: FilledButton.styleFrom(
              backgroundColor: _mutedTerracotta,
              foregroundColor: Colors.black,
            ),
          ),
        ),
    ];

    return Column(
      children: [
        for (var index = 0; index < actions.length; index += 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: actions[index]),
              const SizedBox(width: 12),
              Expanded(
                child: index + 1 < actions.length
                    ? actions[index + 1]
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          if (index + 2 < actions.length) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Future<void> _handleInterruption(BuildContext context) async {
    final cubit = context.read<FlowtimeCubit>();
    if (state.activeInterruption != null) {
      cubit.endActiveInterruption();
      return;
    }
    final draft = await showModalBottomSheet<_InterruptionDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.of(context).paper,
      builder: (_) => const _InterruptionSheet(),
    );
    if (draft != null && context.mounted) {
      cubit.startInterruption(
        type: draft.type,
        label: draft.label,
        note: draft.note,
      );
    }
  }

  Future<void> _confirmEndSession(BuildContext context) async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('End Flowtime session?'),
          content: Text(
            state.phase == FlowtimePhase.focusing ||
                    state.phase == FlowtimePhase.focusPaused
                ? 'The current unfinished focus block will not be saved.'
                : 'This will close the current Flowtime session.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('End Session'),
            ),
          ],
        );
      },
    );

    if (shouldEnd == true && context.mounted) {
      context.read<FlowtimeCubit>().finishSession();
      context.go(originTab.location);
    }
  }
}

class _FlowActionButton extends StatelessWidget {
  const _FlowActionButton({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return SizedBox(
      height: 64,
      child: Theme(
        data: Theme.of(context).copyWith(
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(64),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              side: BorderSide(
                color: colors.ink.withValues(alpha: 0.08),
                width: 1,
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(64),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              side: BorderSide(
                color: colors.ink.withValues(alpha: 0.14),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colors.ink.withValues(alpha: 0.035),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SessionJournal extends StatelessWidget {
  const _SessionJournal({required this.blocks});

  final List<FlowtimeCompletedBlock> blocks;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.paperWarm.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.ink.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Session Journal',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Completed blocks and interruptions stay visible here while the session is open.',
              style: TextStyle(color: colors.inkSoft, height: 1.35),
            ),
            const SizedBox(height: 16),
            if (blocks.isEmpty)
              Text(
                'No completed blocks yet.',
                style: TextStyle(color: colors.inkSoft),
              )
            else
              for (final block in blocks.reversed) ...[
                _JournalBlockCard(block: block),
                const SizedBox(height: 12),
              ],
          ],
        ),
      ),
    );
  }
}

class _JournalBlockCard extends StatelessWidget {
  const _JournalBlockCard({required this.block});

  final FlowtimeCompletedBlock block;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.paper,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.ink.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${block.workedMinutes}m focus • ${block.suggestedBreakMinutes}m rest',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              '${_formatTime(block.startedAt)} - ${_formatTime(block.endedAt)}',
              style: TextStyle(color: colors.inkSoft),
            ),
            const SizedBox(height: 10),
            if (block.interruptions.isEmpty)
              Text(
                'No interruptions logged.',
                style: TextStyle(color: colors.inkSoft),
              )
            else
              for (final interruption in block.interruptions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '${interruption.type.label}: ${interruption.label}'
                    '${interruption.note?.isNotEmpty == true ? ' - ${interruption.note}' : ''}',
                    style: const TextStyle(height: 1.35),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _InterruptionDraft {
  const _InterruptionDraft({
    required this.type,
    required this.label,
    this.note,
  });

  final SessionInterruptionType type;
  final String label;
  final String? note;
}

class _InterruptionSheet extends StatefulWidget {
  const _InterruptionSheet();

  @override
  State<_InterruptionSheet> createState() => _InterruptionSheetState();
}

class _InterruptionSheetState extends State<_InterruptionSheet> {
  final _labelController = TextEditingController();
  final _noteController = TextEditingController();
  SessionInterruptionType _type = SessionInterruptionType.external;

  @override
  void dispose() {
    _labelController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log Interruption', style: kaushan(size: 28)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            children: [
              ChoiceChip(
                label: const Text('External'),
                selected: _type == SessionInterruptionType.external,
                onSelected: (_) {
                  setState(() => _type = SessionInterruptionType.external);
                },
              ),
              ChoiceChip(
                label: const Text('Internal'),
                selected: _type == SessionInterruptionType.internal,
                onSelected: (_) {
                  setState(() => _type = SessionInterruptionType.internal);
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _labelController,
            decoration: const InputDecoration(
              labelText: 'Short label',
              hintText: 'Slack ping, urge to check email, phone call...',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Note (optional)'),
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () {
                final label = _labelController.text.trim();
                if (label.isEmpty) {
                  return;
                }
                Navigator.of(context).pop(
                  _InterruptionDraft(
                    type: _type,
                    label: label,
                    note: _noteController.text.trim().isEmpty
                        ? null
                        : _noteController.text.trim(),
                  ),
                );
              },
              child: const Text('Start Logging'),
            ),
          ),
        ],
      ),
    );
  }
}
