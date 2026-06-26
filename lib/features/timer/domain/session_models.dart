enum FocusSessionMode {
  pomodoro('pomodoro'),
  flowtime('flowtime');

  const FocusSessionMode(this.storageValue);

  final String storageValue;

  static FocusSessionMode fromStorage(String? value) {
    for (final mode in FocusSessionMode.values) {
      if (mode.storageValue == value) {
        return mode;
      }
    }
    return FocusSessionMode.pomodoro;
  }
}

enum SessionInterruptionType {
  distraction('distraction'),
  interruption('interruption'),
  internal('internal'),
  external('external');

  const SessionInterruptionType(this.storageValue);

  final String storageValue;

  String get label {
    switch (this) {
      case SessionInterruptionType.distraction:
        return 'Distraction';
      case SessionInterruptionType.interruption:
        return 'Interruption';
      case SessionInterruptionType.internal:
        return 'Internal';
      case SessionInterruptionType.external:
        return 'External';
    }
  }

  static SessionInterruptionType fromStorage(String? value) {
    for (final type in SessionInterruptionType.values) {
      if (type.storageValue == value) {
        return type;
      }
    }
    return SessionInterruptionType.interruption;
  }
}

class SessionInterruptionDraft {
  const SessionInterruptionDraft({
    required this.type,
    required this.label,
    required this.startedAt,
    required this.endedAt,
  });

  final SessionInterruptionType type;
  final String label;
  final DateTime startedAt;
  final DateTime endedAt;
}
