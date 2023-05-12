import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petit_editor/src/blocks/riverpod/order.dart';
import 'package:petit_editor/src/blocks/riverpod/provider_scope_overrides.dart';

import '../blocks/riverpod/projects/list.dart';
import '../providers/projects.dart';
import 'router.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(sortedProjectsOrderProvider);
    final reset = ref.watch(resetProjectsProvider);

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
      content: ProviderScopeOverrides(
        overrides: (context, ref) => [
          overrideProvider(loadedSortedProjectsProvider).withAsyncValue(ref.watch(sortedProjectsProvider)),
        ],
        child: ProjectsList(
          onSelect: (project) {
            ProjectRoute(id: project.reference.id).go(context);
          },
        ),
      ),
    );
  }
}
