// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
//
// import '../../../../providers/generic.dart';
// import '../../../base/loaded_scope/loaded_scope.dart';
//
// class ProjectNodesListView extends ConsumerWidget {
//   const ProjectNodesListView({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final count = ref.watch(projectNodeModelsProvider.select((value) => value.length));
//     return ListView.builder(
//       itemCount: count,
//       itemBuilder: (context, index) {
//         final node = ref.watch(projectNodeModelsProvider.select((value) => value[index]));
//         return LoadedScope(
//           loaders: (context, ref) => [
//             overrideProvider(projectNodeModelProvider).withValue(node),
//           ],
//           child: const ProjectNodeListTile(),
//         );
//       },
//     );
//   }
// }
//
// class ProjectNodeListTile extends ConsumerWidget {
//   const ProjectNodeListTile({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final id = ref.watch(projectNodeModelProvider.select((value) => value.doc.id));
//     final type = ref.watch(projectNodeModelProvider.select((value) => value.type));
//
//     return ListTile.selectable(
//       title: Text(id),
//       subtitle: Text(type),
//       selected: ref.watch(projectModelProvider.select((value) => value.node)) == id,
//       onPressed: () {
//         ref.read(projectModelProvider).updateNodeId(id);
//       },
//     );
//   }
// }
