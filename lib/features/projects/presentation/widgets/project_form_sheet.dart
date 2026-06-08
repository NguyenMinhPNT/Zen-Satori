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
  late final TextEditingController _detailController;
  late final TextEditingController _dateController;
  DateTime? _startDate;
  DateTime? _deadline;
  late ProjectStatus _status;

  bool get _isEditing => widget.project != null;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _titleController = TextEditingController(text: p?.title ?? '');
    _detailController = TextEditingController(text: p?.detail ?? '');
    _startDate = p?.startDate;
    _deadline = p?.deadline;
    _status = p != null
        ? ProjectStatus.fromLabel(p.status)
        : ProjectStatus.ongoing;
    _dateController = TextEditingController(
      text: _formatDateRange(_startDate, _deadline),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start != null && end != null) {
      return '${_formatDate(start)} → ${_formatDate(end)}';
    }
    if (start != null) return _formatDate(start);
    if (end != null) return _formatDate(end);
    return '';
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _startDate != null && _deadline != null
          ? DateTimeRange(start: _startDate!, end: _deadline!)
          : null,
    );
    if (range != null) {
      setState(() {
        _startDate = range.start;
        _deadline = range.end;
        _dateController.text = _formatDateRange(_startDate, _deadline);
      });
    }
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final detail = _detailController.text.trim().isEmpty
        ? null
        : _detailController.text.trim();

    final cubit = context.read<ProjectCubit>();
    if (_isEditing) {
      await cubit.updateProject(
        id: widget.project!.id,
        title: title,
        status: _status,
        detail: detail,
        startDate: _startDate,
        deadline: _deadline,
      );
    } else {
      await cubit.createProject(
        title: title,
        detail: detail,
        startDate: _startDate,
        deadline: _deadline,
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
            controller: _detailController,
            textInputAction: TextInputAction.newline,
            maxLines: 3,
            minLines: 1,
            decoration: const InputDecoration(
              labelText: 'Detail Project',
              border: OutlineInputBorder(),
            ),
          ),
          if (_isEditing) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<ProjectStatus>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: ProjectStatus.values.map((status) {
                return DropdownMenuItem<ProjectStatus>(
                  value: status,
                  child: Text(status.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _status = value;
                });
              },
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _dateController,
            readOnly: true,
            onTap: _pickDateRange,
            decoration: InputDecoration(
              labelText: 'Date',
              border: const OutlineInputBorder(),
              hintText: 'Start date → Deadline',
              suffixIcon: _startDate != null || _deadline != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() {
                        _startDate = null;
                        _deadline = null;
                        _dateController.clear();
                      }),
                    )
                  : const Icon(Icons.calendar_today),
            ),
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
