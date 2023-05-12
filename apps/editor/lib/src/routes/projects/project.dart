import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../blocks/riverpod/async_value.dart';
import '../../blocks/riverpod/delete_confirmation.dart';
import '../../providers/project.dart';
import '../router.dart';

class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectProvider);
    final delete = ref.watch(projectDeleteProvider);

    return ScaffoldPage.withPadding(
      header: PageHeader(
        title: const Text('Project'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.remove),
              label: const Text('Delete'),
              onPressed: withConfirmation(context, delete),
            )
          ],
        ),
      ),
      content: AsyncValueWidget(
        value: project,
        builder: (context, value) {
          return Text(value.toString());
        },
      ),
    );
  }

  VoidCallback? withConfirmation(BuildContext context, VoidCallback? delete) {
    if (delete == null) {
      return null;
    }
    return () async {
      await deleteWithConfirmation(
        context,
        message: 'Are you sure you want to delete this project?',
        onDelete: (context) {
          ProjectsRoute().go(context);
          delete();
        },
      );
    };
  }
}
