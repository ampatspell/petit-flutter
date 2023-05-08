import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petit_editor/src/blocks/riverpod/order.dart';

import '../blocks/riverpod/projects/list.dart';
import '../providers/projects.dart';

class ProjectsScreen extends HookConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(sortedProjectsOrderProvider);
    final isResetting = useState(false);

    VoidCallback? reset;
    if (!isResetting.value) {
      reset = () async {
        final repository = ref.read(projectsRepositoryProvider);
        try {
          isResetting.value = true;
          await repository.reset();
        } finally {
          if (context.mounted) {
            isResetting.value = false;
          }
        }
      };
    }

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
            CommandBarButton(
              icon: const Icon(FluentIcons.reset),
              label: const Text('Reset'),
              onPressed: reset,
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
