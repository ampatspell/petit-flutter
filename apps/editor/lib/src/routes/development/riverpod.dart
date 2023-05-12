import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petit_editor/src/models/project.dart';

import '../../blocks/riverpod/async_value.dart';
import '../../blocks/riverpod/provider_scope_overrides.dart';
import '../../providers/project.dart';
import '../../providers/projects.dart';

class DevelopmentRiverpodScreen extends HookConsumerWidget {
  const DevelopmentRiverpodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Riverpod'),
      ),
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
    return ProviderScopeOverrides(
      overrides: (context, ref) => [
        overrideProvider(projectReferenceProvider).withValue(project.reference),
      ],
      child: const ProjectWidget(),
    );
  }
}

class ProjectWidget extends ConsumerWidget {
  const ProjectWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build top');

    return ProviderScopeOverrides(
      overrides: (context, ref) => [
        overrideProvider(loadedProjectProvider).withAsyncValue(ref.watch(projectProvider)),
        overrideProvider(loadedProjectNodesProvider).withAsyncValue(ref.watch(projectNodesProvider)),
        overrideProvider(loadedProjectWorkspacesProvider).withAsyncValue(ref.watch(projectWorkspacesProvider)),
      ],
      child: const ScopedWidget(),
    );
  }
}

class ScopedWidget extends ConsumerWidget {
  const ScopedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build scoped');
    final project = ref.watch(loadedProjectProvider);
    final nodes = ref.watch(loadedProjectNodesProvider);
    final workspaces = ref.watch(loadedProjectWorkspacesProvider);
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
