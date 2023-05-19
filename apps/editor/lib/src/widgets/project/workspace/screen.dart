import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/project/nodes.dart';
import '../../../providers/project/project.dart';
import '../../../providers/project/workspace/items.dart';
import '../../../providers/project/workspace/workspace.dart';
import '../../base/scope_overrides/scope_overrides.dart';

class WorkspaceScreen extends ConsumerWidget {
  const WorkspaceScreen({
    super.key,
    required this.projectId,
    required this.workspaceId,
  });

  final String projectId;
  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScopeOverrides(
      overrides: (context, ref) => [
        overrideProvider(projectIdProvider).withValue(projectId),
        overrideProvider(workspaceIdProvider).withValue(workspaceId),
      ],
      child: ScopeOverrides(
        overrides: (context, ref) => [
          overrideProvider(projectModelProvider).withListenable(projectModelStreamProvider),
          overrideProvider(projectStateModelProvider).withListenable(projectStateModelStreamProvider),
          overrideProvider(workspaceModelProvider).withListenable(workspaceModelStreamProvider),
          overrideProvider(workspaceStateModelProvider).withListenable(workspaceStateModelStreamProvider),
          overrideProvider(projectNodeModelsProvider).withListenable(projectNodeModelsStreamProvider),
          overrideProvider(workspaceItemModelsProvider).withListenable(workspaceItemModelsStreamProvider),
        ],
        child: const WorkspaceScreenContent(),
      ),
    );
  }
}

class WorkspaceScreenContent extends ConsumerWidget {
  const WorkspaceScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build');

    final project = ref.watch(projectModelProvider);
    final projectState = ref.watch(projectStateModelProvider);
    final workspace = ref.watch(workspaceModelProvider);
    final workspaceState = ref.watch(workspaceStateModelProvider);
    final nodes = ref.watch(projectNodeModelsProvider);
    final items = ref.watch(workspaceItemModelsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Workspace'),
        const Gap(10),
        Text(project.toString()),
        const Gap(10),
        Text(projectState.toString()),
        const Gap(10),
        Text(workspace.toString()),
        const Gap(10),
        Text(workspaceState.toString()),
        const Gap(10),
        Text(nodes.toString()),
        const Gap(10),
        Text(items.toString()),
      ],
    );

    // final project = ref.watch(projectModelStreamProvider);
    // return project.when(
    //   skipLoadingOnReload: true,
    //   skipLoadingOnRefresh: true,
    //   data: (data) {
    //     return Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const Text('Workspace'),
    //         const Gap(10),
    //         Text(project.toString()),
    //         const Gap(10),
    //         // Text(projectState.toString()),
    //       ],
    //     );
    //   },
    //   error: (error, stackTrace) => Text(error.toString()),
    //   loading: () => Text('Loading $project'),
    // );
    // final projectState = ref.watch(projectStateModelProvider);
  }
}
