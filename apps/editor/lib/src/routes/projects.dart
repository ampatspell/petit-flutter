import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:petit_editor/src/routes/router.dart';

import '../blocks/projects/list.dart';

class ProjectsScreen extends HookWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = useState(OrderDirection.asc);
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Projects'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(
              icon: Icon(order.value.icon),
              onPressed: () {
                order.value = order.value.next;
              },
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: const Text('New'),
              onPressed: () {
                NewProjectRoute().go(context);
              },
            ),
          ],
        ),
      ),
      content: ProjectsList(
        order: order.value,
        onSelect: (ref) {
          ProjectRoute(projectId: ref.id).go(context);
        },
      ),
    );
  }
}
