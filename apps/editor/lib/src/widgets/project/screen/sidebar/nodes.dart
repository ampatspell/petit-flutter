import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/project.dart';
import '../../../../providers/projects.dart';
import '../../../base/loaded_scope/loaded_scope.dart';

class ProjectNodesListView extends ConsumerWidget {
  const ProjectNodesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(projectNodeDocsProvider.select((value) => value.length));
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        final node = ref.watch(projectNodeDocsProvider.select((value) => value[index]));
        return LoadedScope(
          loaders: (context, ref) => [
            overrideProvider(projectNodeDocProvider).withValue(node),
          ],
          child: const ProjectNodeListTile(),
        );
      },
    );
  }
}

class ProjectNodeListTile extends ConsumerWidget {
  const ProjectNodeListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(projectNodeDocProvider.select((value) => value.doc.id));
    final type = ref.watch(projectNodeDocProvider.select((value) => value.type));

    return ListTile.selectable(
      title: Text(id),
      subtitle: Text(type),
      selected: ref.watch(projectDocProvider.select((value) => value.node)) == id,
      onPressed: () {
        ref.read(projectDocProvider).updateNodeId(id);
      },
    );
  }
}
