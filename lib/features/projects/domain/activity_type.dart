enum ActivityType {
  project('project', 'Project'),
  routine('routine', 'Routine');

  const ActivityType(this.storageValue, this.label);

  final String storageValue;
  final String label;

  static ActivityType fromStorage(String? value) {
    return ActivityType.values.firstWhere(
      (type) =>
          type.storageValue.toLowerCase() == value?.toLowerCase() ||
          type.name.toLowerCase() == value?.toLowerCase(),
      orElse: () => ActivityType.project,
    );
  }
}

enum ActivityFrequencyPeriod {
  day('day', 'Day'),
  week('week', 'Week'),
  month('month', 'Month');

  const ActivityFrequencyPeriod(this.storageValue, this.label);

  final String storageValue;
  final String label;

  static ActivityFrequencyPeriod? fromStorage(String? value) {
    for (final period in ActivityFrequencyPeriod.values) {
      if (period.storageValue.toLowerCase() == value?.toLowerCase() ||
          period.name.toLowerCase() == value?.toLowerCase()) {
        return period;
      }
    }
    return null;
  }
}
