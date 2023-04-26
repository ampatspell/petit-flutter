import 'package:flutter/material.dart';

import '../screen/screen.dart';

class ProjectScreen extends StatelessWidget {
  final String projectId;

  const ProjectScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return Screen(
      expandBody: true,
      body: Center(
        child: Text(projectId),
      ),
    );
  }
}
