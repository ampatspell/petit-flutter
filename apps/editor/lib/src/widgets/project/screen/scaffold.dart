import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../app/router.dart';
import '../../../providers/project/delete.dart';
import '../../../providers/project/project.dart';
import '../../base/confirmation.dart';
import '../workspaces.dart';

class ProjectScreenScaffold extends ConsumerWidget {
  const ProjectScreenScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(projectModelProvider.select((value) => value.name));
    final delete = ref.watch(projectModelDeleteProvider);
    return ScaffoldPage(
      header: PageHeader(
        padding: 15,
        title: Text(name),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [],
          secondaryItems: [
            buildDeleteCommandBarButton(
              context,
              label: 'Delete project',
              message: 'Delete project?',
              action: delete,
              onCommit: (context, action) {
                ProjectsRoute().go(context);
                action();
              },
            ),
          ],
        ),
      ),
      content: ProjectWorkspacesListView(
        onSelect: (model) {
          ProjectWorkspaceRoute(
            projectId: ref.read(projectModelProvider).doc.id,
            workspaceId: model.doc.id,
          ).go(context);
        },
      ),
    );
  }
}
