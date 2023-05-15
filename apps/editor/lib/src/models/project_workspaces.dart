import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'project_workspace.dart';
import 'references.dart';
import 'typedefs.dart';

part 'project_workspaces.freezed.dart';

@freezed
class ProjectWorkspacesRepository with _$ProjectWorkspacesRepository {
  const factory ProjectWorkspacesRepository({
    required FirestoreReferences references,
    required MapDocumentReference projectRef,
  }) = _ProjectWorkspacesRepository;

  const ProjectWorkspacesRepository._();

  MapCollectionReference get collection => references.projectWorkspacesCollection(projectRef);

  ProjectWorkspaceModel _asModel(MapDocumentSnapshot snapshot) {
    return ProjectWorkspaceModel(
      doc: references.asDoc(snapshot),
    );
  }

  List<ProjectWorkspaceModel> _asModels(MapQuerySnapshot event) {
    return event.docs.map(_asModel).toList(growable: false);
  }

  Stream<List<ProjectWorkspaceModel>> all() {
    return collection.snapshots(includeMetadataChanges: true).map(_asModels);
  }

  Future<MapDocumentReference> add({required String name}) async {
    final ref = collection.doc();
    await ref.set({
      'name': name,
    });
    return ref;
  }
}
