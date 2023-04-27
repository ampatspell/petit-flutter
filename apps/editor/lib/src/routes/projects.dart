import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import 'router.dart';

class ProjectsScreen extends StatelessWidget {
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
          return Text("Hello");
        }),
      ],
    );

    //   body: ProjectsList(
    //     onSelect: (projectRef) {
    //       print('on select');
    //       ProjectRoute(projectId: projectRef.id).go(context);
    //     },
    //   ),
    // );
  }
}
