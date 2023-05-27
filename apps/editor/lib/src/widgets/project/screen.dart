import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/project/project.dart';
import '../../providers/project/workspaces.dart';
import '../base/async_values_loader.dart';
import 'screen/scaffold.dart';

class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({
    super.key,
    required this.projectId,
  });

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        projectIdProvider.overrideWithValue(projectId),
      ],
      child: AsyncValuesLoader(
        providers: [
          projectModelStreamProvider,
          workspaceModelsStreamProvider,
        ],
        child: const ProjectScreenScaffold(),
      ),
    );
  }
}
