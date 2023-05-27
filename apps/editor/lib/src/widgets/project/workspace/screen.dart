import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/project/nodes.dart';
import '../../../providers/project/project.dart';
import '../../../providers/project/workspace/items.dart';
import '../../../providers/project/workspace/workspace.dart';
import '../../base/async_values_loader.dart';
import 'editor/editor.dart';
import 'inspector/inspector.dart';

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
    return ProviderScope(
      overrides: [
        projectIdProvider.overrideWithValue(projectId),
        workspaceIdProvider.overrideWithValue(workspaceId),
      ],
      child: AsyncValuesLoader(
        providers: [
          projectModelStreamProvider,
          projectStateModelStreamProvider,
          workspaceModelStreamProvider,
          workspaceStateModelStreamProvider,
          nodeModelsStreamProvider,
          workspaceItemModelsStreamProvider,
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
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: WorkspaceEditor()),
        WorkspaceInspector(),
      ],
    );
  }
}
