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

  bool get hasBegun => _readBool(hasBegunKey, false);
  bool get soundEnabled => _readBool(soundEnabledKey, true);
  bool get vibrateEnabled => _readBool(vibrateEnabledKey, true);
  FocusMode get focusMode {
    return FocusMode.fromStorage(_readString(focusModeKey));
  }

  bool get scheduleRemindersEnabled {
    return _readBool(scheduleRemindersEnabledKey, false);
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

  bool _readBool(String key, bool fallback) {
    try {
      final value = _prefs.get(key);
      if (value is bool) {
        return value;
      }
    } catch (_) {
      // Fall through to the default when cached data is corrupted.
    }
    return fallback;
  }

  String? _readString(String key) {
    try {
      final value = _prefs.get(key);
      if (value is String) {
        return value;
      }
    } catch (_) {
      // Fall through to null when cached data is corrupted.
    }
    return null;
  }
}
