import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/utils.dart';
import '../../../models/project_workspace.dart';
import '../../../providers/base.dart';
import '../../../providers/project/workspaces.dart';
import '../../base/scope_overrides/scope_overrides.dart';

part 'workspaces.g.dart';

@Riverpod(dependencies: [])
ProjectWorkspaceModel projectWorkspaceModel(ProjectWorkspaceModelRef ref) => throw OverrideProviderException();

class ProjectWorkspacesListView extends ConsumerWidget {
  const ProjectWorkspacesListView({
    super.key,
    required this.onSelect,
  });

  final void Function(ProjectWorkspaceModel model)? onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(projectWorkspaceModelsProvider.select((value) => value.length));
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        final workspace = ref.watch(projectWorkspaceModelsProvider.select((value) => value[index]));
        // FIXME: this is quite useless here. onSelect makes tile non const anyway (and this list view)
        return ScopeOverrides(
          overrides: (context, ref) => [
            overrideProvider(projectWorkspaceModelProvider).withValue(workspace),
          ],
          child: ProjectWorkspaceListTile(onSelect: onSelect),
        );
      },
    );
  }
}

class ProjectWorkspaceListTile extends ConsumerWidget {
  const ProjectWorkspaceListTile({
    super.key,
    required this.onSelect,
  });

  final void Function(ProjectWorkspaceModel model)? onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(projectWorkspaceModelProvider.select((value) => value.name));
    return ListTile.selectable(
      title: Text(name),
      onPressed: (onSelect != null).ifTrue(() {
        onSelect!(ref.read(projectWorkspaceModelProvider));
      }),
    );
  }
}
