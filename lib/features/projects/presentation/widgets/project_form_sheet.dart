import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/activity_type.dart';
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
  late final TextEditingController _nameController;
  late final TextEditingController _deadlineController;
  late final TextEditingController _targetHoursController;
  late ActivityType _type;
  late ProjectStatus _status;
  DateTime? _deadline;

  bool get _isEditing => widget.project != null;

  @override
  void initState() {
    super.initState();
    final project = widget.project;
    _nameController = TextEditingController(text: project?.title ?? '');
    _deadline = project?.deadline;
    _deadlineController = TextEditingController(text: _formatDate(_deadline));
    _targetHoursController = TextEditingController(
      text: _formatTargetHours(project?.targetMinutes ?? 0),
    );
    _type = ActivityType.fromStorage(project?.activityType);
    _status = project != null
        ? ProjectStatus.fromLabel(project.status)
        : ProjectStatus.ongoing;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _deadlineController.dispose();
    _targetHoursController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  String _formatTargetHours(int targetMinutes) {
    if (targetMinutes <= 0) {
      return '';
    }
    final hours = targetMinutes / 60;
    final text = hours == hours.roundToDouble()
        ? hours.toStringAsFixed(0)
        : hours.toStringAsFixed(1);
    return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: _deadline ?? DateTime.now(),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _deadline = picked;
      _deadlineController.text = _formatDate(picked);
    });
  }

  void _showValidationMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    final title = _nameController.text.trim();
    if (title.isEmpty) {
      _showValidationMessage('Name is required.');
      return;
    }

    final targetHoursText = _targetHoursController.text.trim();

    double? targetHours;
    if (targetHoursText.isNotEmpty) {
      targetHours = double.tryParse(targetHoursText.replaceAll(',', '.'));
      if (targetHours == null || targetHours <= 0) {
        _showValidationMessage('Target Hours must be a positive number.');
        return;
      }
    }

    final cubit = context.read<ProjectCubit>();
    if (_isEditing) {
      await cubit.updateProject(
        id: widget.project!.id,
        title: title,
        type: _type,
        status: _status,
        deadline: _deadline,
        targetMinutes: targetHours == null ? null : (targetHours * 60).round(),
        frequencyCount: null,
        frequencyPeriod: null,
      );
    } else {
      await cubit.createProject(
        title: title,
        type: _type,
        deadline: _deadline,
        targetMinutes: targetHours == null ? null : (targetHours * 60).round(),
        frequencyCount: null,
        frequencyPeriod: null,
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Activity'),
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
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEditing ? 'Edit Activity' : 'Create Activity',
              textAlign: TextAlign.center,
              style: kaushan(),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: _type == ActivityType.project
                    ? 'e.g. Neom, Blueco'
                    : 'e.g. Read book',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Type',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _ActivityTypeSelector(
              selectedType: _type,
              onChanged: (type) {
                setState(() {
                  _type = type;
                });
              },
            ),
            if (_isEditing) ...[
              const SizedBox(height: 16),
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
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _status = value;
                  });
                },
              ),
            ],
            const SizedBox(height: 16),
            if (_type == ActivityType.project) ...[
              TextField(
                controller: _deadlineController,
                readOnly: true,
                onTap: _pickDeadline,
                decoration: InputDecoration(
                  labelText: 'Deadline',
                  hintText: 'Choose a date',
                  border: const OutlineInputBorder(),
                  suffixIcon: _deadline != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                            _deadline = null;
                            _deadlineController.clear();
                          }),
                        )
                      : const Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _targetHoursController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Target Hours',
                  hintText: 'Optional',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _submit,
              child: Text(_isEditing ? 'Update Activity' : 'Create Activity'),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: _confirmDelete,
                style: TextButton.styleFrom(foregroundColor: colors.clay),
                child: const Text('Delete Activity'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActivityTypeSelector extends StatelessWidget {
  const _ActivityTypeSelector({
    required this.selectedType,
    required this.onChanged,
  });

  final ActivityType selectedType;
  final ValueChanged<ActivityType> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.paperWarm.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.ink.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            for (final type in ActivityType.values)
              Expanded(
                child: _ActivityTypeOption(
                  type: type,
                  selected: selectedType == type,
                  onTap: () => onChanged(type),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTypeOption extends StatelessWidget {
  const _ActivityTypeOption({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final ActivityType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: selected ? colors.ink : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              type.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? colors.paper : colors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
