import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petit_editor/src/models/project.dart';

import '../../blocks/riverpod/async_value.dart';
import '../../providers/projects.dart';
import '../../providers/selected_project.dart';

class DevelopmentRiverpodScreen extends HookConsumerWidget {
  const DevelopmentRiverpodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Riverpod'),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ProjectsWidget(),
        ],
      ),
    );
  }
}

class ProjectsWidget extends HookConsumerWidget {
  const ProjectsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(sortedProjectsProvider);
    return AsyncValueWidget(
      value: projects,
      builder: (context, projects) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProjectScope(project: projects[0]),
            const Gap(20),
            ProjectScope(project: projects[1]),
          ],
        );
      },
    );
  }
}

class ProjectScope extends StatelessWidget {
  final Project project;

  const ProjectScope({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        selectedProjectReferenceProvider.overrideWithValue(project.reference),
      ],
      child: const ProjectWidget(),
    );
  }
}

class ProjectWidget extends HookConsumerWidget {
  const ProjectWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(selectedProjectProvider);
    final nodes = ref.watch(selectedProjectNodesProvider);
    final workspaces = ref.watch(selectProjectWorkspacesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(project.toString()),
        const Gap(10),
        Text(nodes.toString()),
        const Gap(10),
        Text(workspaces.toString()),
      ],
    );
  }
}
