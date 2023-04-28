import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import '../screen/screen.dart';

class ProjectScreen extends StatelessWidget {
  final String projectId;

  const ProjectScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text("Project"),
      ),
      children: [
        ContentArea(builder: (context, scrollController) {
          return Center(
            child: Text(projectId),
          );
        }),
      ],
    );
  }
}
