import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:petit_editor/src/blocks/projects/list.dart';

import 'router.dart';

class ProjectsScreen extends HookWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text("Projects"),
        actions: [
          ToolBarIconButton(
            label: 'Add project',
            icon: const MacosIcon(Icons.add),
            showLabel: false,
            onPressed: () => NewProjectRoute().go(context),
          ),
        ],
      ),
      children: [
        ContentArea(builder: (context, scrollController) {
          return ProjectsList(
            onSelect: (ref) {
              print(ref);
            },
          );
        }),
      ],
    );
  }
}
