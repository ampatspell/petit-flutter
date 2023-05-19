import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app/router.dart';
import '../../providers/project/project.dart';
import '../../providers/project/workspaces.dart';
import '../base/scope_overrides/scope_overrides.dart';
import 'screen/scaffold.dart';

class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({
    super.key,
    required this.projectId,
  });

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScopeOverrides(
      parent: this,
      overrides: (context, ref) => [
        overrideProvider(projectIdProvider).withValue(projectId),
      ],
      child: ScopeOverrides(
        parent: this,
        onDeleted: () => ProjectsRoute().go(context),
        overrides: (context, ref) => [
          overrideProvider(projectModelProvider).withListenable(projectModelStreamProvider),
          overrideProvider(workspaceModelsProvider).withListenable(workspaceModelsStreamProvider),
        ],
        child: const ProjectScreenScaffold(),
      ),
    );
  }
}
