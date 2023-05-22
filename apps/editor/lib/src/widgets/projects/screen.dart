import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app/router.dart';
import '../../providers/projects/projects.dart';
import '../../providers/projects/reset.dart';
import '../base/async_values_loader.dart';
import '../base/order.dart';
import 'list.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(projectModelsOrderProvider);
    final reset = ref.watch(resetProjectsProvider);

    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Projects'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            buildOrderCommandBarButton(order, () => ref.read(projectModelsOrderProvider.notifier).toggle()),
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: const Text('New'),
              onPressed: () {
                NewProjectRoute().go(context);
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
      content: AsyncValuesLoader(
        providers: [
          projectModelsStreamProvider,
        ],
        child: ProjectsList(
          onSelect: (project) {
            ProjectRoute(projectId: project.doc.id).go(context);
          },
        ),
      ),
    );
  }
}
