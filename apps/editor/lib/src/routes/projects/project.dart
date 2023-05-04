import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petit_editor/src/blocks/delete_confirmation.dart';
import 'package:petit_editor/src/routes/router.dart';
import 'package:petit_zug/petit_zug.dart';

import '../../blocks/with_model.dart';
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
    final model = useEntity(
      reference: reference,
      model: (reference, data) => Project(reference),
    );

    return WithLoadedModel(
      model: model,
      builder: (context, project) => Observer(builder: (context) {
        return ScaffoldPage.withPadding(
          header: PageHeader(
            title: Text(project.name ?? 'Untitled project'),
            commandBar: CommandBar(
              mainAxisAlignment: MainAxisAlignment.end,
              primaryItems: [
                CommandBarButton(
                  icon: const Icon(FluentIcons.remove),
                  label: const Text('Delete'),
                  onPressed: () => delete(context, project),
                )
              ],
            ),
          ),
          content: Text(model.asString),
        );
      }),
    );
  }

  void delete(BuildContext context, Project project) async {
    await deleteWithConfirmation(
      context,
      message: 'Are you sure you want to delete this project?',
      onDelete: (context) async {
        ProjectsRoute().go(context);
        await project.delete();
      },
    );
  }
}
