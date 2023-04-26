import 'package:flutter/material.dart';

import '../blocks/projects/list.dart';
import 'screen/screen.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      expandBody: true,
      accessories: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add),
        ),
      ],
      body: ProjectsList(
        onSelect: (projectRef) {
          print(projectRef);
        },
      ),
    );
  }
}
