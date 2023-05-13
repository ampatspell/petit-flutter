import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    return ProviderScopeOverrides(
      overrides: (context, ref) => [
        overrideProvider(loadedSortedProjectsProvider).withAsyncValue(ref.watch(sortedProjectsProvider)),
      ],
      child: Consumer(
        builder: (context, ref, child) {
          final ids = ref.watch(loadedSortedProjectsProvider.select((value) {
            return value.map((e) {
              return e.reference.id;
            });
          }));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ids.map((id) {
              return ProviderScopeOverrides(
                overrides: (context, ref) => [
                  overrideProvider(projectIdProvider).withValue(id),
                ],
                child: const ProjectWidget(),
              );
            }).toList(growable: false),
          );
        },
      ),
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
        const ProjectTitleWidget(),
        const Gap(10),
        Text(project.toString()),
        const Gap(10),
        Text(nodes.toString()),
        const Gap(10),
        Text(workspaces.toString()),
      ],
    );
  }
}

class ProjectTitleWidget extends ConsumerWidget {
  const ProjectTitleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build title');
    final name = ref.watch(loadedProjectProvider.select((value) => value.name));
    return Text('Project: $name');
  }
}
