import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../projects/presentation/project_cubit.dart';
import '../../settings/domain/focus_mode.dart';
import '../../settings/presentation/settings_cubit.dart';
import 'flowtime_screen.dart';
import 'timer_screen.dart';

class TimerEntryScreen extends StatefulWidget {
  const TimerEntryScreen({super.key});

  @override
  State<TimerEntryScreen> createState() => _TimerEntryScreenState();
}

class _TimerEntryScreenState extends State<TimerEntryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedProject = context
          .read<ProjectCubit>()
          .state
          .selectedProject;
      final focusMode = context.read<SettingsCubit>().state.focusMode;
      if (selectedProject == null || focusMode == FocusMode.none) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedProject = context.read<ProjectCubit>().state.selectedProject;
    final focusMode = context.read<SettingsCubit>().state.focusMode;
    if (selectedProject == null || focusMode == FocusMode.none) {
      return const Scaffold(body: SizedBox.shrink());
    }
    switch (focusMode) {
      case FocusMode.pomodoro:
        return const PomodoroTimerScreen();
      case FocusMode.flowtime:
        return const FlowtimerScreen();
      case FocusMode.none:
        return const Scaffold(body: SizedBox.shrink());
    }
  }
}
