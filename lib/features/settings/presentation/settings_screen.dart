import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/ink_switch.dart';
import '../../../core/widgets/zen_app_scaffold.dart';
import '../../../core/widgets/zen_header.dart';
import 'settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ZenAppScaffold(
      currentIndex: 4,
      child: Column(
        children: [
          const ZenHeader(title: 'Settings', showBack: false),
          Expanded(
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                final cubit = context.read<SettingsCubit>();
                return ListView(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 110),
                  children: [
                    _SettingRow(
                      label: 'Sounds (Zen Bell)',
                      value: state.soundEnabled,
                      onChanged: cubit.setSoundEnabled,
                    ),
                    _SettingRow(
                      label: 'Vibrate',
                      value: state.vibrateEnabled,
                      onChanged: cubit.setVibrateEnabled,
                    ),
                    _SettingRow(
                      label: 'Flowtime Mode',
                      value: state.flowtimeModeEnabled,
                      onChanged: cubit.toggleFlowtimeMode,
                    ),
                    _SettingRow(
                      label: 'Pomodoro Mode',
                      value: state.pomodoroModeEnabled,
                      onChanged: cubit.togglePomodoroMode,
                    ),
                    _SettingRow(
                      label: 'Schedule Reminders',
                      value: state.scheduleRemindersEnabled,
                      onChanged: cubit.setScheduleRemindersEnabled,
                    ),
                    const _BackupRow(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 21))),
            InkSwitch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _BackupRow extends StatelessWidget {
  const _BackupRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text('Backup & Restore', style: TextStyle(fontSize: 21)),
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
