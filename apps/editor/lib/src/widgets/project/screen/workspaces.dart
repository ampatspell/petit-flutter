import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../app/router.dart';
import '../../../mobx/mobx.dart';
import '../../base/models_list_view.dart';

class ProjectWorkspacesListView extends StatelessWidget {
  const ProjectWorkspacesListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ModelsListView<Workspaces, WorkspaceDoc>(
      models: (model) => model.docs,
      placeholder: const Text('No workspaces created yet'),
      item: Observer(builder: (context) {
        final workspace = context.watch<WorkspaceDoc>();
        return ListTile.selectable(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(workspace.name),
          ),
          onPressed: () {
            final project = context.read<Project>();
            ProjectWorkspaceRoute(
              projectId: project.id,
              workspaceId: workspace.id,
            ).go(context);
          },
        );
      }),
    );
  }
}
