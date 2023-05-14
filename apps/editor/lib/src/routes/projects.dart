import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../blocks/riverpod/loaded_scope/loaded_scope.dart';
import '../blocks/riverpod/order.dart';
import '../blocks/riverpod/projects/list.dart';
import '../providers/projects.dart';
import 'router.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(projectDocsOrderProvider);
    final reset = ref.watch(resetProjectsProvider);

    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Projects'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            buildOrderCommandBarButton(order, () => ref.read(projectDocsOrderProvider.notifier).toggle()),
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
      content: LoadedScope(
        parent: this,
        loaders: (context, ref) => [
          overrideProvider(projectDocsProvider).withLoadedValue(ref.watch(projectDocsStreamProvider)),
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
