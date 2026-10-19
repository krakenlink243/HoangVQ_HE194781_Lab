import 'package:flutter/material.dart';

import '../models/student.dart';

/// Values returned by [showStudentFormDialog].
typedef StudentFormResult = ({String name, String major, double gpa});

/// Reusable Add / Edit dialog (custom UI component – bonus).
/// Returns null when the user cancels.
Future<StudentFormResult?> showStudentFormDialog(
  BuildContext context, {
  Student? initial,
}) {
  return showDialog<StudentFormResult>(
    context: context,
    builder: (_) => _StudentFormDialog(initial: initial),
  );
}

class _StudentFormDialog extends StatefulWidget {
  final Student? initial;
  const _StudentFormDialog({this.initial});

  @override
  State<_StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<_StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.initial?.name,
  );
  late final _majorController = TextEditingController(
    text: widget.initial?.major,
  );
  late final _gpaController = TextEditingController(
    text: widget.initial?.gpa.toString(),
  );

  @override
  void dispose() {
    _nameController.dispose();
    _majorController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _validateGpa(String? v) {
    final gpa = double.tryParse((v ?? '').trim());
    if (gpa == null) return 'Enter a number';
    if (gpa < 0 || gpa > 4) return 'GPA must be between 0 and 4';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop<StudentFormResult>(context, (
      name: _nameController.text.trim(),
      major: _majorController.text.trim(),
      gpa: double.parse(_gpaController.text.trim()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return AlertDialog(
      title: Text(
        isEdit ? 'Edit student #${widget.initial!.id}' : 'Add student',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full name'),
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
              TextFormField(
                controller: _majorController,
                decoration: const InputDecoration(labelText: 'Major'),
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
              TextFormField(
                controller: _gpaController,
                decoration: const InputDecoration(labelText: 'GPA (0 – 4)'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: _validateGpa,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: Text(isEdit ? 'Save' : 'Add')),
      ],
    );
  }
}
