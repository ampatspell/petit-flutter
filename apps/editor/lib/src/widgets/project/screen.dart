import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/generic.dart';
import '../../providers/project.dart';
import '../base/loaded_scope/loaded_scope.dart';
import 'screen/scaffold.dart';

class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadedScope(
      parent: this,
      loaders: (context, ref) => [
        overrideProvider(projectModelProvider).withLoadedValue(
          ref.watch(projectModelStreamProvider),
        ),
        overrideProvider(projectStateModelProvider).withLoadedValue(
          ref.watch(projectStateModelStreamProvider),
        ),
        overrideProvider(projectNodeModelsProvider).withLoadedValue(
          ref.watch(projectNodeModelsStreamProvider),
        ),
        // overrideProvider(projectWorkspaceModelsProvider).withLoadedValue(
        //   ref.watch(projectWorkspaceModelsStreamProvider),
        // ),
      ],
      child: Consumer(
        builder: (context, ref, child) {
          return Text([
            ref.watch(projectModelProvider),
            ref.watch(projectStateModelProvider),
            ref.watch(projectNodeModelsProvider),
          ].join('\n\n'));
        },
      ),
      // child: const ProjectScreenScaffold(),
    );
  }
}
