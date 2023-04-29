import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:petit_editor/src/routes/router.dart';
import 'package:petit_editor/src/stores/firestore/project.dart';

class ProjectScreen extends HookWidget {
  final DocumentReference<ProjectData> reference;

  const ProjectScreen({
    super.key,
    required this.reference,
  });

  @override
  Widget build(BuildContext context) {
    final stream = useStream(reference.snapshots());
    final snapshot = stream.data;
    final data = snapshot?.data();

    return ScaffoldPage(
      header: PageHeader(
        title: Text(data?.name ?? 'Loading…'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.remove),
              label: const Text('Delete'),
              onPressed: () {
                deleteWithConfirmation(context);
              },
            )
          ],
        ),
      ),
      content: const Center(child: Text("Project")),
    );
  }

  void deleteWithConfirmation(BuildContext context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContentDialog(
        title: const Text('Delete this project?'),
        actions: [
          Button(
            child: const Text('Delete'),
            onPressed: () {
              context.pop();
              delete(context);
            },
          ),
          FilledButton(
            child: const Text('Cancel'),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  void delete(BuildContext context) async {
    ProjectsRoute().go(context);
    await reference.delete();
  }
}
