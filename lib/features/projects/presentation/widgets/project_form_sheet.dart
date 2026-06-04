import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/project_status.dart';
import '../project_cubit.dart';

Future<void> showProjectFormSheet(BuildContext context, {Project? project}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<ProjectCubit>(),
        child: _ProjectFormSheet(project: project),
      );
    },
  );
}

class _ProjectFormSheet extends StatefulWidget {
  const _ProjectFormSheet({this.project});

  final Project? project;

  @override
  State<_ProjectFormSheet> createState() => _ProjectFormSheetState();
}

class _ProjectFormSheetState extends State<_ProjectFormSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _hoursController;
  late ProjectStatus _status;

  bool get _isEditing => widget.project != null;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _titleController = TextEditingController(text: p?.title ?? '');
    _hoursController = TextEditingController(
      text: p != null ? (p.targetMinutes ~/ 60).toString() : '1',
    );
    _status = p != null
        ? ProjectStatus.fromLabel(p.status)
        : ProjectStatus.ongoing;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final hours = int.tryParse(_hoursController.text.trim()) ?? 0;
    if (title.isEmpty || hours <= 0) return;

    final cubit = context.read<ProjectCubit>();
    if (_isEditing) {
      await cubit.updateProject(
        id: widget.project!.id,
        title: title,
        targetHours: hours,
        status: _status,
      );
    } else {
      await cubit.createProject(
        title: title,
        targetHours: hours,
        status: _status,
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text(
          'Delete "${widget.project!.title}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<ProjectCubit>().deleteProject(widget.project!.id);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _isEditing ? 'Edit Project' : 'New Project',
            textAlign: TextAlign.center,
            style: kaushan(),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _titleController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Project title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _hoursController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Target hours',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ProjectStatus>(
            initialValue: _status,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final status in ProjectStatus.values)
                DropdownMenuItem(value: status, child: Text(status.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _status = value);
            },
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: _submit,
            child: Text(_isEditing ? 'Update Project' : 'Create Project'),
          ),
          if (_isEditing) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _confirmDelete,
              style: TextButton.styleFrom(foregroundColor: AppTheme.clay),
              child: const Text('Delete Project'),
            ),
          ],
        ],
      ),
    );
  }
}
