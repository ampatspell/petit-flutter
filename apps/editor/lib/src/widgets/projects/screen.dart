// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
//
// import '../../app/router.dart';
// import '../../providers/projects.dart';
// import '../base/loaded_scope/loaded_scope.dart';
// import '../base/order.dart';
// import 'list.dart';
//
// class ProjectsScreen extends ConsumerWidget {
//   const ProjectsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final order = ref.watch(projectModelsOrderProvider);
//     final reset = ref.watch(resetProjectsProvider);
//
//     return ScaffoldPage(
//       header: PageHeader(
//         title: const Text('Projects'),
//         commandBar: CommandBar(
//           mainAxisAlignment: MainAxisAlignment.end,
//           primaryItems: [
//             buildOrderCommandBarButton(order, () => ref.read(projectModelsOrderProvider.notifier).toggle()),
//             CommandBarButton(
//               icon: const Icon(FluentIcons.add),
//               label: const Text('New'),
//               onPressed: () {
//                 NewProjectRoute().go(context);
//               },
//             ),
//             CommandBarButton(
//               icon: const Icon(FluentIcons.reset),
//               label: const Text('Reset'),
//               onPressed: reset,
//             ),
//           ],
//         ),
//       ),
//       content: LoadedScope(
//         parent: this,
//         loaders: (context, ref) => [
//           overrideProvider(projectModelsProvider).withLoadedValue(ref.watch(projectModelsStreamProvider)),
//         ],
//         child: ProjectsList(
//           onSelect: (project) {
//             ProjectRoute(id: project.doc.id).go(context);
//           },
//         ),
//       ),
//     );
//   }
// }
