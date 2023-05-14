import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/project.dart';
import '../../../app/router.dart';
import '../../base/confirmation.dart';
import 'workspaces_command_bar_item.dart';
import 'content.dart';

class ProjectScreenScaffold extends ConsumerWidget {
  const ProjectScreenScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(projectDocProvider.select((value) => value.name));
    final delete = ref.watch(projectDocDeleteProvider);
    return ScaffoldPage(
      header: PageHeader(
        title: Text(name),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            WorkspacesCommandBarItem(
              workspaces: ref.watch(projectWorkspaceDocsProvider),
              selected: ref.watch(projectWorkspaceDocProvider),
              onSelect: (workspace) => ref.read(projectDocProvider).updateWorkspaceId(workspace?.doc.id),
            ),
          ],
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
      content: const ProjectScreenScaffoldContent(),
    );
  }
}
