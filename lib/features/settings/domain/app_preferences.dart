import 'package:shared_preferences/shared_preferences.dart';

import 'focus_mode.dart';

class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const hasBegunKey = 'hasBegun';
  static const soundEnabledKey = 'soundEnabled';
  static const vibrateEnabledKey = 'vibrateEnabled';
  static const focusModeKey = 'focusMode';
  static const scheduleRemindersEnabledKey = 'scheduleRemindersEnabled';

  bool get hasBegun => _prefs.getBool(hasBegunKey) ?? false;
  bool get soundEnabled => _prefs.getBool(soundEnabledKey) ?? true;
  bool get vibrateEnabled => _prefs.getBool(vibrateEnabledKey) ?? true;
  FocusMode get focusMode {
    return FocusMode.fromStorage(_prefs.getString(focusModeKey));
  }

  bool get scheduleRemindersEnabled {
    return _prefs.getBool(scheduleRemindersEnabledKey) ?? false;
  }

  Future<void> setHasBegun(bool value) => _prefs.setBool(hasBegunKey, value);
  Future<void> setSoundEnabled(bool value) {
    return _prefs.setBool(soundEnabledKey, value);
  }

  Future<void> setVibrateEnabled(bool value) {
    return _prefs.setBool(vibrateEnabledKey, value);
  }

  Future<void> setFocusMode(FocusMode value) {
    return _prefs.setString(focusModeKey, value.storageValue);
  }

  Future<void> setScheduleRemindersEnabled(bool value) {
    return _prefs.setBool(scheduleRemindersEnabledKey, value);
  }
}
