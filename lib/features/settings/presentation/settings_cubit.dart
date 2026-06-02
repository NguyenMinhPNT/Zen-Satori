import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/app_preferences.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.soundEnabled,
    required this.vibrateEnabled,
    required this.casualModeEnabled,
    required this.scheduleRemindersEnabled,
  });

  final bool soundEnabled;
  final bool vibrateEnabled;
  final bool casualModeEnabled;
  final bool scheduleRemindersEnabled;

  SettingsState copyWith({
    bool? soundEnabled,
    bool? vibrateEnabled,
    bool? casualModeEnabled,
    bool? scheduleRemindersEnabled,
  }) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrateEnabled: vibrateEnabled ?? this.vibrateEnabled,
      casualModeEnabled: casualModeEnabled ?? this.casualModeEnabled,
      scheduleRemindersEnabled:
          scheduleRemindersEnabled ?? this.scheduleRemindersEnabled,
    );
  }

  @override
  List<Object> get props => [
    soundEnabled,
    vibrateEnabled,
    casualModeEnabled,
    scheduleRemindersEnabled,
  ];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._preferences)
    : super(
        SettingsState(
          soundEnabled: _preferences.soundEnabled,
          vibrateEnabled: _preferences.vibrateEnabled,
          casualModeEnabled: _preferences.casualModeEnabled,
          scheduleRemindersEnabled: _preferences.scheduleRemindersEnabled,
        ),
      );

  final AppPreferences _preferences;

  Future<void> setSoundEnabled(bool value) async {
    await _preferences.setSoundEnabled(value);
    emit(state.copyWith(soundEnabled: value));
  }

  Future<void> setVibrateEnabled(bool value) async {
    await _preferences.setVibrateEnabled(value);
    emit(state.copyWith(vibrateEnabled: value));
  }

  Future<void> setCasualModeEnabled(bool value) async {
    await _preferences.setCasualModeEnabled(value);
    emit(state.copyWith(casualModeEnabled: value));
  }

  Future<void> setScheduleRemindersEnabled(bool value) async {
    await _preferences.setScheduleRemindersEnabled(value);
    emit(state.copyWith(scheduleRemindersEnabled: value));
  }
}
