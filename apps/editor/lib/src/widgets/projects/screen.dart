import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:zug/zug.dart';

import '../../app/router.dart';
import '../../mobx/mobx.dart';
import '../base/order.dart';
import '../loading.dart';
import 'list.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MountingProvider(
      create: (context) => Projects(),
      child: const ProjectsScreenContent(),
    );
  }
}

class ProjectsScreenContent extends StatelessWidget {
  const ProjectsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<Projects>();
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Projects'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            buildOrderCommandBarButton(
              order: () => projects.order,
              onPressed: projects.toggleOrder,
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: const Text('New'),
              onPressed: () => NewProjectRoute().go(context),
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.reset),
              label: const Text('Reset'),
              onPressed: projects.reset,
            ),
          ],
        ),
      ),
      content: const Load<Projects>(
        child: ProjectsList(),
      ),
    );
  }
}
