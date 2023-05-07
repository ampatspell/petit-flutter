// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:gap/gap.dart';
// import 'package:petit_editor/src/stores/workspace.dart';
// import 'package:petit_zug/petit_zug.dart';
//
// import '../../get_it.dart';
//
// class DevelopmentWorkspaceScreen extends HookWidget {
//   const DevelopmentWorkspaceScreen({super.key});
//
//   FirebaseFirestore get firestore => it.get();
//
//   @override
//   Widget build(BuildContext context) {
//     final workspaceRef = firestore.doc('development/workspace');
//     final workspaceNodesRef = workspaceRef.collection('nodes');
//     final projectNodesRef = firestore.collection('development/project/nodes');
//
//     void reset() async {
//       await Future.wait((await projectNodesRef.get()).docs.map((snapshot) => snapshot.reference.delete()));
//       final box1 = projectNodesRef.doc();
//       await box1.set({
//         'type': 'box',
//         'color': Colors.red.value,
//         'width': 10,
//         'height': 10,
//       });
//       final box2 = projectNodesRef.doc();
//       await box2.set({
//         'type': 'box',
//         'color': Colors.red.withAlpha(50).value,
//         'width': 10,
//         'height': 10,
//       });
//
//       await workspaceRef.set({
//         'pixel': 20,
//       });
//
//       await Future.wait((await workspaceNodesRef.get()).docs.map((snapshot) => snapshot.reference.delete()));
//       await workspaceNodesRef.doc().set({
//         'x': 1,
//         'y': 1,
//         'pixel': 1,
//         'node': box1.id,
//       });
//       await workspaceNodesRef.doc().set({
//         'x': 12,
//         'y': 1,
//         'pixel': 2,
//         'node': box2.id,
//       });
//     }
//
//     return ScaffoldPage(
//       header: PageHeader(
//         title: const Text('Workspace'),
//         commandBar: CommandBar(
//           mainAxisAlignment: MainAxisAlignment.end,
//           primaryItems: [
//             CommandBarButton(
//               icon: const Icon(FluentIcons.refresh),
//               onPressed: () => reset(),
//             )
//           ],
//         ),
//       ),
//       content: Workspace(
//         workspaceRef: workspaceRef,
//         workspaceNodesRef: workspaceNodesRef,
//         projectNodesRef: projectNodesRef,
//         onWorkspaceMissing: (context, ref) => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Workspace ${ref.id} missing'),
//             const Gap(10),
//             FilledButton(child: const Text('Create'), onPressed: () => reset()),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class WorkspaceModel {
//   final FirestoreDocumentLoader<WorkspaceEntity> _workspace;
//   final FirestoreQueryLoader<WorkspaceNodeEntity> _workspaceNodes;
//   final FirestoreQueryLoader<ProjectNodeEntity> _projectNodes;
//
//   WorkspaceModel({
//     required FirestoreDocumentLoader<WorkspaceEntity> workspace,
//     required FirestoreQueryLoader<WorkspaceNodeEntity> workspaceNodes,
//     required FirestoreQueryLoader<ProjectNodeEntity> projectNodes,
//   })  : _workspace = workspace,
//         _workspaceNodes = workspaceNodes,
//         _projectNodes = projectNodes;
//
//   double get pixel => _workspace.content!.pixel.toDouble();
//
//   List<WorkspaceNodeEntity> get workspaceNodes => _workspaceNodes.content;
//
//   List<ProjectNodeEntity> get projectNodes => _projectNodes.content;
//
//   ProjectNodeEntity projectNodeById(String id) {
//     return projectNodes.firstWhere((element) => element.reference.id == id);
//   }
// }
//
// class Workspace extends HookWidget {
//   final DocumentReference<Map<String, dynamic>> workspaceRef;
//   final CollectionReference<Map<String, dynamic>> workspaceNodesRef;
//   final CollectionReference<Map<String, dynamic>> projectNodesRef;
//   final Widget Function(BuildContext context, DocumentReference workspaceRef) onWorkspaceMissing;
//
//   const Workspace({
//     super.key,
//     required this.workspaceRef,
//     required this.workspaceNodesRef,
//     required this.onWorkspaceMissing,
//     required this.projectNodesRef,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final workspace = useEntity(
//       reference: workspaceRef,
//       model: (reference, _) => WorkspaceEntity(reference),
//     );
//     final workspaceNodes = useEntities(
//       query: workspaceNodesRef,
//       model: (reference, _) => WorkspaceNodeEntity(reference),
//     );
//     final projectNodes = useEntities<ProjectNodeEntity>(
//       query: projectNodesRef,
//       model: (reference, data) {
//         final type = data['type'] as String;
//         if (type == 'box') {
//           return ProjectBoxNodeEntity(reference);
//         }
//         throw UnsupportedError(type);
//       },
//     );
//     return Observer(builder: (context) {
//       if (workspace.isLoading || workspaceNodes.isLoading || projectNodes.isLoading) {
//         return const Text('Loading…');
//       }
//       final content = workspace.content;
//       if (content == null || content.isDeleted) {
//         return onWorkspaceMissing(context, workspaceRef);
//       }
//
//       var model = WorkspaceModel(
//         workspace: workspace,
//         workspaceNodes: workspaceNodes,
//         projectNodes: projectNodes,
//       );
//
//       return WorkspaceContent(
//         model: model,
//       );
//     });
//   }
// }
//
// class WorkspaceContent extends StatelessWidget {
//   final WorkspaceModel model;
//
//   const WorkspaceContent({
//     super.key,
//     required this.model,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: const BoxConstraints.expand(),
//       color: Colors.white,
//       child: WorkspaceNodesStack(model: model),
//     );
//   }
// }
//
// class WorkspaceNodesStack extends StatelessWidget {
//   final WorkspaceModel model;
//
//   const WorkspaceNodesStack({
//     super.key,
//     required this.model,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Observer(builder: (context) {
//       return Stack(
//         fit: StackFit.expand,
//         children: _buildNodes(),
//       );
//     });
//   }
//
//   List<WorkspaceNode> _buildNodes() {
//     return model.workspaceNodes.map((node) {
//       return WorkspaceNode(node: node, workspace: model);
//     }).toList(growable: false);
//   }
// }
//
// class WorkspaceNode extends StatelessWidget {
//   final WorkspaceModel workspace;
//   final WorkspaceNodeEntity node;
//
//   const WorkspaceNode({
//     super.key,
//     required this.node,
//     required this.workspace,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (context) {
//       final position = node.positionForPixel(workspace.pixel);
//       final projectNode = workspace.projectNodeById(node.node);
//       final pixel = workspace.pixel * node.pixel;
//       final size = projectNode.sizeForPixel(pixel);
//       return Positioned(
//         top: position.dy,
//         left: position.dx,
//         child: buildConstrainedProjectNode(size, pixel, projectNode),
//       );
//     });
//   }
//
//   SizedBox buildConstrainedProjectNode(Size size, double pixel, ProjectNodeEntity projectNode) {
//     return SizedBox(
//       width: size.width,
//       height: size.height,
//       child: buildProjectNode(pixel, projectNode),
//     );
//   }
//
//   Widget buildProjectNode(double pixel, ProjectNodeEntity node) {
//     if (node is ProjectBoxNodeEntity) {
//       return ProjectBoxNode(pixel: pixel, entity: node);
//     }
//     throw UnsupportedError(node.toString());
//   }
// }
//
// class ProjectBoxNode extends StatelessWidget {
//   final double pixel;
//   final ProjectBoxNodeEntity entity;
//
//   const ProjectBoxNode({
//     super.key,
//     required this.pixel,
//     required this.entity,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: entity.color,
//       child: Padding(
//         padding: const EdgeInsets.all(5),
//         child: Text('$pixel\n${entity.toString()}'),
//       ),
//     );
//   }
// }
