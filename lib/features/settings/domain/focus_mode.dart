enum FocusMode {
  none('none'),
  pomodoro('pomodoro'),
  flowtime('flowtime');

  const FocusMode(this.storageValue);

  final String storageValue;

  bool get isPomodoro => this == FocusMode.pomodoro;
  bool get isFlowtime => this == FocusMode.flowtime;

  String get label {
    switch (this) {
      case FocusMode.none:
        return 'None';
      case FocusMode.pomodoro:
        return 'Pomodoro';
      case FocusMode.flowtime:
        return 'Flowtime';
    }
  }

  static FocusMode fromStorage(String? value) {
    for (final mode in FocusMode.values) {
      if (mode.storageValue == value) {
        return mode;
      }
    }
    return FocusMode.none;
  }
}
