import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petit_editor/src/providers/projects.dart';

import '../../blocks/riverpod/confirmation.dart';
import '../../blocks/riverpod/loaded_scope/loaded_scope.dart';
import '../../models/project_node.dart';
import '../../providers/project.dart';
import '../router.dart';

class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadedScope(
      parent: this,
      loaders: (context, ref) => [
        overrideProvider(projectDocProvider).withLoadedValue(ref.watch(projectDocStreamProvider)),
        overrideProvider(projectNodeDocsProvider).withLoadedValue(ref.watch(projectNodeDocsStreamProvider)),
        overrideProvider(projectWorkspaceDocsProvider).withLoadedValue(ref.watch(projectWorkspaceDocsStreamProvider)),
      ],
      child: const ProjectScreenContent(),
    );
  }
}

class ProjectScreenContent extends ConsumerWidget {
  const ProjectScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(projectDocProvider.select((value) => value.name));
    final delete = ref.watch(projectDocDeleteProvider);
    return ScaffoldPage(
      header: PageHeader(
        title: Text(name),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            buildDeleteCommandBarButton(
              context,
              message: 'Are you sure you want to delete this product?',
              action: delete,
              onCommit: (context, action) {
                ProjectsRoute().go(context);
                action();
              },
            ),
          ],
        ),
      ),
      content: const ProjectScreenScaffoldContent(),
    );
  }
}

class ProjectScreenScaffoldContent extends ConsumerWidget {
  const ProjectScreenScaffoldContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        ProjectNodes(),
        Expanded(
          child: ProjectWorkspaces(),
        ),
      ],
    );
  }
}

class ProjectNodes extends ConsumerWidget {
  const ProjectNodes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: const BoxConstraints.expand(width: 250),
      child: const ProjectNodesListView(),
    );
  }
}

class ProjectNodesListView extends ConsumerWidget {
  const ProjectNodesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(projectNodeDocsProvider.select((value) => value.length));
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        final node = ref.watch(projectNodeDocsProvider.select((value) => value[index]));
        return LoadedScope(
          loaders: (context, ref) => [
            overrideProvider(projectNodeDocProvider).withValue(node),
          ],
          child: const ProjectNodeListTile(),
        );
      },
    );
  }
}

class ProjectNodeListTile extends ConsumerWidget {
  const ProjectNodeListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(projectNodeDocProvider.select((value) => value.reference.id));
    final type = ref.watch(projectNodeDocProvider.select((value) => value.type));

    return ListTile.selectable(
      title: Text(id),
      subtitle: Text(type),
      selected: ref.watch(projectDocProvider.select((value) => value.node)) == id,
      onPressed: () {
        ref.read(projectDocProvider).updateNodeId(id);
      },
    );
  }
}

class ProjectWorkspaces extends ConsumerWidget {
  const ProjectWorkspaces({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaces = ref.watch(projectWorkspaceDocsProvider);
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.red.withAlpha(10),
      child: Text(workspaces.map((e) => e.toString()).join('\n\n')),
    );
  }
}
