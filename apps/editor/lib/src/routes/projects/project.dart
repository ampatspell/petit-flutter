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
    return ProviderScopeOverrides(
      parent: this,
      overrides: (context, ref) => [
        overrideProvider(loadedProjectProvider).withAsyncValue(ref.watch(projectProvider)),
        overrideProvider(loadedProjectNodesProvider).withAsyncValue(ref.watch(projectNodesProvider)),
        overrideProvider(loadedProjectWorkspacesProvider).withAsyncValue(ref.watch(projectWorkspacesProvider)),
      ],
      child: const ProjectScreenContent(),
    );
  }
}

class ProjectScreenContent extends ConsumerWidget {
  const ProjectScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(loadedProjectProvider);
    final nodes = ref.watch(loadedProjectNodesProvider);
    final workspaces = ref.watch(loadedProjectWorkspacesProvider);
    final delete = ref.watch(projectDeleteProvider);

    return ScaffoldPage.withPadding(
      header: PageHeader(
        title: const Text('Project'),
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
      content: Text([
        project,
        nodes,
        workspaces,
      ].join('\n\n')),
    );
  }
}
