import 'package:flutter/material.dart';

import '../screen/fluent.dart';

class ProjectScreen extends StatelessWidget {
  final String projectId;

  const ProjectScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return const FluentScreen(
      selected: 0,
      body: Center(child: Text("Project")),
    );
  }
}
