enum ProjectStatus {
  ongoing('Ongoing'),
  suspended('Suspended'),
  finished('Finished'),
  cancel('Cancel');

  const ProjectStatus(this.label);

  final String label;

  static ProjectStatus fromLabel(String value) {
    return ProjectStatus.values.firstWhere(
      (status) =>
          status.label.toLowerCase() == value.toLowerCase() ||
          status.name.toLowerCase() == value.toLowerCase(),
      orElse: () => ProjectStatus.ongoing,
    );
  }
}
