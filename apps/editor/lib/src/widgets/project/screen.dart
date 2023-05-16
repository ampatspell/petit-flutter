import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/project/nodes.dart';
import '../../providers/project/project.dart';
import '../../providers/project/workspaces.dart';
import '../base/scope_overrides/scope_overrides.dart';

class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScopeOverrides(
      parent: this,
      overrides: (context, ref) => [
        overrideProvider(projectModelProvider).withLoadedValue(
          ref.watch(projectModelStreamProvider),
        ),
        overrideProvider(projectStateModelProvider).withLoadedValue(
          ref.watch(projectStateModelStreamProvider),
        ),
        overrideProvider(projectNodeModelsProvider).withLoadedValue(
          ref.watch(projectNodeModelsStreamProvider),
        ),
        overrideProvider(projectWorkspaceModelsProvider).withLoadedValue(
          ref.watch(projectWorkspaceModelsStreamProvider),
        )
      ],
      child: Consumer(
        builder: (context, ref, child) {
          return Text([
            ref.watch(projectModelProvider),
            ref.watch(projectStateModelProvider),
            ref.watch(projectNodeModelsProvider),
            ref.watch(projectWorkspaceModelsProvider),
          ].join('\n\n'));
        },
      ),
      // child: const ProjectScreenScaffold(),
    );
  }
}
