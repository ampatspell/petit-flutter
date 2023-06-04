import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:zug/zug.dart';

// part 'three.g.dart';

class DevelopmentThreeScreen extends StatelessWidget {
  const DevelopmentThreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Zug'),
      ),
      content: const ScreenContent(),
    );
  }
}

class ScreenContent extends StatelessWidget {
  const ScreenContent({super.key});

  FirebaseFirestore get firestore => it.get();

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // return MountingProvider(
    //   create: (context) => Project(projectRef: firestore.collection('projects').doc('8PkLJa7AKtcBRkjPoCrg')),
    //   builder: (context, child) {
    //     return Observer(builder: (context) {
    //       final project = context.watch<Project>();
    //       if (project.isLoaded) {
    //         return child!;
    //       }
    //       return const SizedBox.shrink();
    //     });
    //   },
    //   child: const Loaded(),
    // );
  }
}

// class Loaded extends StatelessWidget {
//   const Loaded({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // final project = context.watch<Project>();
//     return const Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         FilledButton(
//           child: Text('Toggle'),
//           onPressed: project.toggleReference,
//         ),
//         Gap(10),
//         const ProjectDetails(),
//         const Gap(10),
//         const Nodes(),
//         const Gap(10),
//         const Mounted(),
//         const Gap(10),
//         const Subscriptions(),
//       ],
//     );
//   }
// }
//
// class ProjectDetails extends StatelessWidget {
//   const ProjectDetails({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Observer(builder: (context) {
//       final project = context.watch<Project>();
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           DefaultFluentTextStyle(
//             resolve: (typography) => typography.subtitle,
//             child: const Text('Project:'),
//           ),
//           const Gap(5),
//           Text('id: ${project.doc?.doc.id}'),
//           Text('Name: ${project.doc?.name}'),
//         ],
//       );
//     });
//   }
// }
//
// class Nodes extends StatelessWidget {
//   const Nodes({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Observer(builder: (context) {
//       final project = context.watch<Project>();
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           DefaultFluentTextStyle(
//             resolve: (typography) => typography.subtitle,
//             child: const Text('Nodes:'),
//           ),
//           const Gap(5),
//           for (final model in project.nodes) Text(model.toString()),
//           if (project.nodes.isEmpty) const Text('No nodes'),
//         ],
//       );
//     });
//   }
// }
//
// class Mounted extends StatelessWidget {
//   const Mounted({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Observer(builder: (context) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           DefaultFluentTextStyle(
//             resolve: (typography) => typography.subtitle,
//             child: const Text('Mounted:'),
//           ),
//           const Gap(5),
//           for (final model in mounted) Text(model.toString()),
//         ],
//       );
//     });
//   }
// }
//
// class Subscriptions extends StatelessWidget {
//   const Subscriptions({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Observer(builder: (context) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           DefaultFluentTextStyle(
//             resolve: (typography) => typography.subtitle,
//             child: const Text('Subscriptions:'),
//           ),
//           const Gap(5),
//           for (final model in subscriptions) Text(model.toString()),
//         ],
//       );
//     });
//   }
// }

// class Project extends _Project with _$Project {
//   Project({required super.projectRef});
//
//   @override
//   String toString() {
//     return 'Project{id: ${projectRef.id}}';
//   }
// }
//
// abstract class _Project with Store, Mountable {
//   _Project({
//     required this.projectRef,
//   });
//
//   @observable
//   MapDocumentReference projectRef;
//
//   @action
//   void toggleReference() {
//     if (projectRef.id == '8PkLJa7AKtcBRkjPoCrg') {
//       projectRef = projectRef.parent.doc('Mvv2Q6iv7CwHNsftfhYW');
//     } else {
//       projectRef = projectRef.parent.doc('8PkLJa7AKtcBRkjPoCrg');
//     }
//   }
//
//   @override
//   Iterable<Mountable> get mountable => [_doc, _nodes];
//
//   bool get isLoaded => _doc.isLoaded && _nodes.isLoaded;
//
//   late final ModelReference<ProjectDoc> _doc = ModelReference(
//     name: 'project_doc',
//     reference: () => projectRef,
//     create: (doc) => ProjectDoc(doc: doc),
//   );
//
//   ProjectDoc? get doc => _doc.content;
//
//   late final ModelsQuery<ProjectNodeDoc> _nodes = ModelsQuery(
//     name: 'project_nodes',
//     query: () => projectRef.collection('nodes'),
//     create: (doc) => ProjectNodeDoc(doc: doc),
//   );
//
//   List<ProjectNodeDoc> get nodes => _nodes.content;
// }
