import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../app/router.dart';
import '../../../providers/project/delete.dart';
import '../../../providers/project/project.dart';
import '../../base/confirmation.dart';
import 'workspaces.dart';

class ProjectScreenScaffold extends ConsumerWidget {
  const ProjectScreenScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(projectModelProvider.select((value) => value.name));
    return ScaffoldPage(
      header: PageHeader(
        title: Text(name),
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
                ref.read(projectDeleteProvider);
              },
            ),
          ],
        ),
      ),
      content: ProjectWorkspacesListView(
        onSelect: (model) {
          ProjectWorkspaceRoute(
            projectId: ref.read(projectIdProvider),
            workspaceId: model.doc.id,
          ).go(context);
        },
      ),
    );
  }
}
