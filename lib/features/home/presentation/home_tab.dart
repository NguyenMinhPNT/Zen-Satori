enum HomeTab {
  projects('projects', 'Projects'),
  pomodoro('pomodoro', 'Pomodoro'),
  guruAi('guru-ai', 'Guru AI'),
  flowtime('flowtime', 'Flowtime'),
  zen('zen', 'Zen');

  const HomeTab(this.routeValue, this.label);

  final String routeValue;
  final String label;

  String get location => '/home?tab=$routeValue';

  static HomeTab fromRouteValue(String? value) {
    for (final tab in HomeTab.values) {
      if (tab.routeValue == value) {
        return tab;
      }
    }
    return HomeTab.flowtime;
  }
}
