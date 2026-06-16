import 'package:flutter/material.dart';

import '../../features/projects/domain/project_status.dart';
import '../theme/app_theme.dart';

class ProjectStatusChip extends StatelessWidget {
  const ProjectStatusChip({super.key, required this.status});

  final ProjectStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    final color = switch (status) {
      ProjectStatus.ongoing => colors.sage,
      ProjectStatus.suspended => colors.amber,
      ProjectStatus.finished => colors.mist,
      ProjectStatus.cancel => colors.clay,
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
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: colors.ink,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
