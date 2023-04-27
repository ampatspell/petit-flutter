import 'package:flutter/material.dart';

import '../blocks/projects/list.dart';
import 'router.dart';
import 'screen/screen.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      expandBody: true,
      accessories: [
        IconButton(
          onPressed: () => NewProjectRoute().go(context),
          icon: const Icon(Icons.add),
        ),
      ],
      body: ProjectsList(
        onSelect: (projectRef) {
          print('on select');
          ProjectRoute(projectId: projectRef.id).go(context);
        },
      ),
    );
  }
}
