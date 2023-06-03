import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../mobx/mobx.dart';
import '../../base/confirmation.dart';

class ProjectScreenScaffold extends StatelessWidget {
  const ProjectScreenScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final project = context.watch<Project>();
    return ScaffoldPage(
      header: PageHeader(
        title: Observer(
          builder: (context) {
            return Text(project.name);
          },
        ),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [],
          secondaryItems: [
            buildDeleteCommandBarButton(
              context,
              label: 'Delete project',
              message: 'Delete project?',
              onAction: (context) {
                context.pop();
                project.delete();
              },
            ),
          ],
        ),
      ),
      content: const Text('hello'),
      // content: ProjectWorkspacesListView(
      //   onSelect: (model) {
      //     ProjectWorkspaceRoute(
      //       projectId: ref.read(projectIdProvider),
      //       workspaceId: model.doc.id,
      //     ).go(context);
      //   },
      // ),
    );
  }
}
