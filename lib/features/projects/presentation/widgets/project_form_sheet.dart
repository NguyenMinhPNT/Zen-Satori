import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/project_status.dart';
import '../project_cubit.dart';

Future<void> showProjectFormSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<ProjectCubit>(),
        child: const _ProjectFormSheet(),
      );
    },
  );
}

class _ProjectFormSheet extends StatefulWidget {
  const _ProjectFormSheet();

  @override
  State<_ProjectFormSheet> createState() => _ProjectFormSheetState();
}

class _ProjectFormSheetState extends State<_ProjectFormSheet> {
  final _titleController = TextEditingController();
  final _hoursController = TextEditingController(text: '1');
  ProjectStatus _status = ProjectStatus.ongoing;

  @override
  void dispose() {
    _titleController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final hours = int.tryParse(_hoursController.text.trim()) ?? 0;
    if (title.isEmpty || hours <= 0) {
      return;
    }
    await context.read<ProjectCubit>().createProject(
      title: title,
      targetHours: hours,
      status: _status,
    );
    if (mounted) {
      Navigator.of(context).pop();
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
          Text('New Project', textAlign: TextAlign.center, style: kaushan()),
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
              if (value != null) {
                setState(() => _status = value);
              }
            },
          ),
          const SizedBox(height: 18),
          FilledButton(onPressed: _submit, child: const Text('Create Project')),
        ],
      ),
    );
  }
}
