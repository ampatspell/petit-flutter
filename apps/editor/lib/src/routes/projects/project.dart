import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:petit_editor/src/routes/router.dart';
import 'package:petit_zug/petit_zug.dart';

import '../../get_it.dart';
import '../../stores/project.dart';

class ProjectScreen extends HookWidget {
  final DocumentReference<FirestoreData> reference;

  const ProjectScreen({
    super.key,
    required this.reference,
  });

  FirebaseFirestore get firestore => it.get();

  @override
  Widget build(BuildContext context) {
    final model = useModel(
      reference: reference,
      model: (reference) => Project(reference),
    );

    return Observer(
      builder: (context) {
        final project = model.content;
        return ScaffoldPage.withPadding(
          header: PageHeader(
            title: Text(project?.name ?? 'Project'),
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
          content: Observer(
            builder: (context) {
              return Text(model.asString);
            },
          ),
        );
      },
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
