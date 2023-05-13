// part 'loaded_project.freezed.dart';

// @freezed
// class LoadedProjectWorkspaces with _$LoadedProjectWorkspaces {
//   const factory LoadedProjectWorkspaces({
//     required List<ProjectWorkspace> docs,
//     required LoadedProject project,
//     required FirestoreReferences references,
//   }) = _LoadedProjectWorkspaces;
//
//   const LoadedProjectWorkspaces._();
//
//   MapCollectionReference get collection => references.projectWorkspacesCollection(project.doc.reference);
//
//   ProjectWorkspace? get selected {
//     final id = project.workspaceId;
//     return docs.firstWhereOrNull((element) => element.reference.id == id);
//   }
//
//   Future<void> select(ProjectWorkspace workspace) async {
//     await project.updateWorkspaceId(workspace.reference.id);
//   }
//
//   int get selectedIndex {
//     final workspace = selected;
//     if (workspace == null) {
//       return 0;
//     }
//     return docs.indexOf(workspace);
//   }
//
//   Future<void> selectIndex(int index) async {
//     final workspace = docs[index];
//     await select(workspace);
//   }
//
//   Future<void> delete(ProjectWorkspace workspace) async {
//     if (selected == workspace) {
//       await project.updateWorkspaceId(null);
//     }
//     await workspace.reference.delete();
//   }
//
//   Future<void> add({required String name}) async {
//     final ref = collection.doc();
//     await ref.set({'name': name});
//     await project.updateWorkspaceId(ref.id);
//   }
// }
//
// @freezed
// class LoadedProjectWorkspace with _$LoadedProjectWorkspace {
//   const factory LoadedProjectWorkspace({
//     required ProjectWorkspace workspace,
//   }) = _LoadedProjectWorkspace;
//
//   const LoadedProjectWorkspace._();
//
//   Future<void> touch() async {
//     await workspace.reference.set({'foo': 'bar'}, SetOptions(merge: true));
//   }
// }
