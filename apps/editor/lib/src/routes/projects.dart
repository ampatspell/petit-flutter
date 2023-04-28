import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:petit_editor/src/routes/router.dart';
import 'package:petit_editor/src/routes/screen/fluent.dart';

import '../blocks/projects/list.dart';

class ProjectsScreen extends HookWidget {
  const ProjectsScreen({super.key});

  Widget buildAppBarActions(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Padding(
        padding: const EdgeInsetsDirectional.only(end: 8.0),
        child: ToggleSwitch(
          content: const Text('Dark Mode'),
          checked: FluentTheme.of(context).brightness.isDark,
          onChanged: (v) {},
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return const FluentTools(
      child: ScaffoldPage(
        header: PageHeader(
          title: Text('Projects'),
        ),
        content: ProjectsScreenContent(),
      ),
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
