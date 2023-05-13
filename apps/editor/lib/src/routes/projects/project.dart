import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../blocks/riverpod/delete_confirmation.dart';
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
            CommandBarButton(
              icon: const Icon(FluentIcons.remove),
              label: const Text('Delete'),
              onPressed: _deleteWithConfirmation(context, delete),
            )
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

  VoidCallback? _deleteWithConfirmation(BuildContext context, VoidCallback? delete) {
    if (delete == null) {
      return null;
    }
    return () async {
      await deleteWithConfirmation(
        context,
        message: 'Are you sure you want to delete this project?',
        onDelete: (context) {
          ProjectsRoute().go(context);
          delete();
        },
      );
    };
  }
}
