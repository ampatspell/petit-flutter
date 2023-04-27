import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petit_editor/src/theme.dart';

class NewProjectForm extends StatelessWidget {
  NewProjectForm({super.key});

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void commit() {
      var state = _form.currentState;
      if (!state!.validate()) {
        return;
      }
      state.save();
    }

    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            cursorHeight: 18,
            cursorWidth: 2,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Project name',
            ),
            validator: (value) {
              return 'Nothing';
            },
            autofocus: true,
          ),
          AppGaps.gap10,
          ElevatedButton(
            onPressed: () => commit(),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
