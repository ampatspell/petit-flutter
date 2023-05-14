import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        overrideProvider(projectDocProvider).withLoadedValue(ref.watch(projectDocStreamProvider)),
        overrideProvider(projectNodeDocsProvider).withLoadedValue(ref.watch(projectNodeDocsStreamProvider)),
        overrideProvider(projectWorkspaceDocsProvider).withLoadedValue(ref.watch(projectWorkspaceDocsStreamProvider)),
      ],
      child: const ProjectScreenScaffold(),
    );
  }
}
