import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_satori/features/settings/domain/app_preferences.dart';
import 'package:zen_satori/features/settings/domain/focus_mode.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('falls back to defaults when stored values have the wrong type', () async {
    SharedPreferences.setMockInitialValues({
      AppPreferences.soundEnabledKey: 'true',
      AppPreferences.vibrateEnabledKey: 123,
      AppPreferences.focusModeKey: 123,
      AppPreferences.scheduleRemindersEnabledKey: 'false',
    });

    final preferences = AppPreferences(await SharedPreferences.getInstance());

    expect(preferences.soundEnabled, isTrue);
    expect(preferences.vibrateEnabled, isTrue);
    expect(preferences.focusMode, FocusMode.none);
    expect(preferences.scheduleRemindersEnabled, isFalse);
  });

  test('reads valid stored values', () async {
    SharedPreferences.setMockInitialValues({
      AppPreferences.soundEnabledKey: false,
      AppPreferences.vibrateEnabledKey: true,
      AppPreferences.focusModeKey: FocusMode.flowtime.storageValue,
      AppPreferences.scheduleRemindersEnabledKey: true,
    });

    final preferences = AppPreferences(await SharedPreferences.getInstance());

    expect(preferences.soundEnabled, isFalse);
    expect(preferences.vibrateEnabled, isTrue);
    expect(preferences.focusMode, FocusMode.flowtime);
    expect(preferences.scheduleRemindersEnabled, isTrue);
  });
}
