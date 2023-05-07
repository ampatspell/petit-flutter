import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petit_editor/src/blocks/riverpod/order.dart';

import '../blocks/riverpod/projects/list.dart';
import '../providers/projects.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(sortedProjectsOrderProvider);
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Projects'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            buildOrderCommandBarButton(order, () => ref.read(sortedProjectsOrderProvider.notifier).toggle()),
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: const Text('New'),
              onPressed: () {
                // NewProjectRoute().go(context);
              },
            ),
          ],
        ),
      ),
      content: ProjectsList(
        onSelect: (project) {
          print('$project');
        },
      ),
    );
  }
}
