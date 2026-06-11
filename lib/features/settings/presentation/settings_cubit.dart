import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/app_preferences.dart';
import '../domain/focus_mode.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.soundEnabled,
    required this.vibrateEnabled,
    required this.focusMode,
    required this.scheduleRemindersEnabled,
  });

  final bool soundEnabled;
  final bool vibrateEnabled;
  final FocusMode focusMode;
  final bool scheduleRemindersEnabled;

  bool get pomodoroModeEnabled => focusMode == FocusMode.pomodoro;
  bool get flowtimeModeEnabled => focusMode == FocusMode.flowtime;

  SettingsState copyWith({
    bool? soundEnabled,
    bool? vibrateEnabled,
    FocusMode? focusMode,
    bool? scheduleRemindersEnabled,
  }) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrateEnabled: vibrateEnabled ?? this.vibrateEnabled,
      focusMode: focusMode ?? this.focusMode,
      scheduleRemindersEnabled:
          scheduleRemindersEnabled ?? this.scheduleRemindersEnabled,
    );
  }

  @override
  List<Object> get props => [
    soundEnabled,
    vibrateEnabled,
    focusMode,
    scheduleRemindersEnabled,
  ];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._preferences)
    : super(
        SettingsState(
          soundEnabled: _preferences.soundEnabled,
          vibrateEnabled: _preferences.vibrateEnabled,
          focusMode: _preferences.focusMode,
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

  Future<void> setFocusMode(FocusMode value) async {
    await _preferences.setFocusMode(value);
    emit(state.copyWith(focusMode: value));
  }

  Future<void> toggleFlowtimeMode(bool value) {
    return setFocusMode(value ? FocusMode.flowtime : FocusMode.none);
  }

  Future<void> togglePomodoroMode(bool value) {
    return setFocusMode(value ? FocusMode.pomodoro : FocusMode.none);
  }

  Future<void> setScheduleRemindersEnabled(bool value) async {
    await _preferences.setScheduleRemindersEnabled(value);
    emit(state.copyWith(scheduleRemindersEnabled: value));
  }
}
