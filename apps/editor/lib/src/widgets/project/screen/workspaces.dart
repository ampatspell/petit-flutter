import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/workspace.dart';
import '../../../providers/project/workspaces.dart';
import '../../base/models_list_view.dart';

class ProjectWorkspacesListView extends ConsumerWidget {
  const ProjectWorkspacesListView({
    super.key,
    required this.onSelect,
  });

  final ValueChanged<WorkspaceModel> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaces = ref.watch(workspaceModelsProvider);
    return ModelsListView(
      models: workspaces,
      placeholder: const Text('No workspaces created yet'),
      itemBuilder: (context, workspace) {
        return ListTile.selectable(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(workspace.name),
          ),
          onPressed: () => onSelect(workspace),
        );
      },
    );
  }
}
