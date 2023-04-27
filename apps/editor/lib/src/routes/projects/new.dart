import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../blocks/projects/new_form.dart';

class NewProjectScreen extends HookWidget {
  const NewProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text("New project"),
      ),
      children: [
        ContentArea(builder: (context, scrollController) {
          return const NewProjectForm();
        }),
      ],
    );
  }
}
