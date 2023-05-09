import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProjectScreen extends HookWidget {
  // final DocumentReference<FirestoreData> reference;

  const ProjectScreen({
    super.key,
    // required this.reference,
  });

  // FirebaseFirestore get firestore => it.get();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Project'),
      ),
      content: const SizedBox.shrink(),
    );

    // return WithLoadedModel(
    //   model: model,
    //   builder: (context, project) => Observer(builder: (context) {
    //     return ScaffoldPage.withPadding(
    //       header: PageHeader(
    //         title: Text(project.name ?? 'Untitled project'),
    //         commandBar: CommandBar(
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           primaryItems: [
    //             CommandBarButton(
    //               icon: const Icon(FluentIcons.remove),
    //               label: const Text('Delete'),
    //               onPressed: () => delete(context, project),
    //             )
    //           ],
    //         ),
    //       ),
    //       content: Text(model.asString),
    //     );
    //   }),
    // );
  }

// void delete(BuildContext context, Project project) async {
//   await deleteWithConfirmation(
//     context,
//     message: 'Are you sure you want to delete this project?',
//     onDelete: (context) async {
//       ProjectsRoute().go(context);
//       await project.delete();
//     },
//   );
// }
}
