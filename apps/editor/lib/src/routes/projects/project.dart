import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../blocks/riverpod/confirmation.dart';
import '../../blocks/riverpod/provider_scope_overrides.dart';
import '../../providers/project.dart';
import '../router.dart';

class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('1 build project');

    return ProviderScopeOverrides(
      parent: this,
      overrides: (context, ref) => [
        overrideProvider(projectDocProvider).withAsyncValue(ref.watch(projectDocStreamProvider)),
        overrideProvider(projectNodeDocsProvider).withAsyncValue(ref.watch(projectNodeDocsStreamProvider)),
        overrideProvider(projectWorkspaceDocsProvider).withAsyncValue(ref.watch(projectWorkspaceDocsStreamProvider)),
      ],
      child: const ProjectScreenContent(),
    );
  }
}

class Loaded extends ConsumerWidget {
  const Loaded({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectDocStreamProvider.select((value) => value.requireValue.name));
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Loaded'),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project),
        ],
      ),
    );
  }
}

class ProjectScreenContent extends ConsumerWidget {
  const ProjectScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('2 build project content');
    // final project = ref.watch(loadedProjectProvider);
    // final nodes = ref.watch(loadedProjectNodesProvider);
    // final workspaces = ref.watch(loadedProjectWorkspacesProvider);
    final name = ref.watch(projectDocProvider.select((value) => value.name));
    final delete = ref.watch(projectDocDeleteProvider);

    return ScaffoldPage.withPadding(
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
    print('3 build project scaffold content');
    return const ProjectWorkspaces();
  }
}

class ProjectWorkspaces extends ConsumerWidget {
  const ProjectWorkspaces({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('4 build project workspaces');

    final docs = ref.watch(projectWorkspaceDocsProvider);

    final tabs = docs.map((workspace) {
      final name = workspace.name;
      return Tab(
        text: Text(name),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilledButton(
                child: const Text('Touch'),
                onPressed: () {
                  workspace.touch();
                },
              ),
            ],
          ),
        ),
        // closeIcon: FluentIcons.close_pane,
        onClosed: () {
          workspace.delete();
        },
      );
    }).toList(growable: false);

    // final currentIndex = ref.watch(loadedProjectWorkspacesModelProvider.select((value) {
    //   return value.selectedIndex;
    // }));

    const currentIndex = 0;

    return TabView(
      currentIndex: currentIndex,
      tabs: tabs,
      closeButtonVisibility: CloseButtonVisibilityMode.onHover,
      onChanged: (index) {
        // ref.read(loadedProjectWorkspacesModelProvider).selectIndex(index);
      },
      onNewPressed: () {
        ref.read(projectWorkspacesProvider).add(name: 'Untitled');
      },
    );
  }
}
