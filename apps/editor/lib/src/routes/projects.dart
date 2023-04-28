import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:petit_editor/src/routes/router.dart';
import 'package:petit_editor/src/routes/screen/fluent.dart';

import '../blocks/projects/list.dart';

class ProjectsScreen extends HookWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FluentScreen(
      selected: 0,
      body: const ProjectsScreenContent(),
    );
  }
}

class ProjectsScreenContent extends HookWidget {
  const ProjectsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ProjectsList(
      onSelect: (ref) {
        ProjectRoute(projectId: ref.id).go(context);
      },
    );
  }
}
