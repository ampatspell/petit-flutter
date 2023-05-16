import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/project_workspace.dart';
import '../../../providers/base.dart';
import '../../../providers/project/workspaces.dart';
import '../../base/scope_overrides/scope_overrides.dart';

part 'workspaces.g.dart';

@Riverpod(dependencies: [])
ProjectWorkspaceModel workspaceModel(WorkspaceModelRef ref) => throw OverrideProviderException();

class ProjectWorkspacesListView extends ConsumerWidget {
  const ProjectWorkspacesListView({
    super.key,
    required this.onSelect,
  });

  final void Function(ProjectWorkspaceModel model) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(workspaceModelsProvider.select((value) => value.length));
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        final workspace = ref.watch(workspaceModelsProvider.select((value) => value[index]));
        // FIXME: this is quite useless here
        return ScopeOverrides(
          overrides: (context, ref) => [
            overrideProvider(workspaceModelProvider).withValue(workspace),
          ],
          child: const _Tile(),
        );
      },
    );
  }
}

class _Tile extends ConsumerWidget {
  const _Tile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(workspaceModelProvider.select((value) => value.name));
    return ListTile.selectable(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(name),
      ),
      onPressed: () {
        final list = context.findAncestorWidgetOfExactType<ProjectWorkspacesListView>()!;
        list.onSelect(ref.read(workspaceModelProvider));
      },
    );
  }
}
