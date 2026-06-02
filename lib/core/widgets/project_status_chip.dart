import 'package:flutter/material.dart';

import '../../features/projects/domain/project_status.dart';
import '../theme/app_theme.dart';

class ProjectStatusChip extends StatelessWidget {
  const ProjectStatusChip({super.key, required this.status});

  final ProjectStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      ProjectStatus.ongoing => AppTheme.sage,
      ProjectStatus.suspended => AppTheme.amber,
      ProjectStatus.finished => AppTheme.mist,
      ProjectStatus.cancel => AppTheme.clay,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        child: Text(
          status.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
