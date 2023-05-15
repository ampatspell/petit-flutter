import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/project_workspace.dart';
import '../../../../providers/base.dart';
import '../../../../providers/project.dart';
import '../../../base/loaded_scope/loaded_scope.dart';

part 'workspaces.g.dart';

@Riverpod(dependencies: [])
ProjectWorkspaceModel workspaceModel(WorkspaceModelRef ref) => throw OverrideProviderException();

class ProjectWorkspacesListView extends ConsumerWidget {
  const ProjectWorkspacesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(projectWorkspaceModelsProvider.select((value) => value.length));
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        final workspace = ref.watch(projectWorkspaceModelsProvider.select((value) => value[index]));
        return LoadedScope(
          loaders: (context, ref) => [
            overrideProvider(workspaceModelProvider).withValue(workspace),
          ],
          child: const ProjectWorkspaceListTile(),
        );
      },
    );
  }
}

class ProjectWorkspaceListTile extends ConsumerWidget {
  const ProjectWorkspaceListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(workspaceModelProvider.select((value) => value.doc.id));
    final name = ref.watch(workspaceModelProvider.select((value) => value.name));
    final selected = ref.watch(projectWorkspaceModelProvider.select((value) {
      return value?.doc.id == id;
    }));
    return ListTile.selectable(
      title: Text(name),
      selected: selected,
      onPressed: () {
        ref.read(projectModelProvider).updateWorkspaceId(id);
      },
    );
  }
}
