import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../widgets/base/order.dart';
import 'project.dart';
import 'project_node.dart';
import 'project_workspace.dart';
import 'project_workspaces.dart';
import 'projects.dart';
import 'references.dart';
import 'typedefs.dart';

part 'repositories.freezed.dart';

@freezed
class ProjectsRepository with _$ProjectsRepository {
  const factory ProjectsRepository({
    required FirestoreReferences references,
  }) = _ProjectsRepository;

  const ProjectsRepository._();

  MapCollectionReference get collection => references.projects();

  ProjectModel _asModel(MapDocumentSnapshot snapshot) {
    return ProjectModel(
      doc: references.asDoc(snapshot),
    );
  }

  List<ProjectModel> _asModels(MapQuerySnapshot event) {
    return event.docs.map(_asModel).toList(growable: false);
  }

  Stream<List<ProjectModel>> all(OrderDirection order) {
    return collection
        .orderBy('name', descending: order.isDescending)
        .snapshots(includeMetadataChanges: true)
        .map(_asModels);
  }

  Stream<ProjectModel> byReference(MapDocumentReference projectRef) {
    return projectRef.snapshots(includeMetadataChanges: true).map(_asModel);
  }

  Future<MapDocumentReference> add(NewProjectModel data) async {
    final ref = collection.doc();
    await ref.set({
      'name': data.name,
    });
    return ref;
  }

  Future<void> delete(MapDocumentReference projectRef) async {
    await projectRef.delete();
  }
}

@freezed
class ProjectStatesRepository with _$ProjectStatesRepository {
  const factory ProjectStatesRepository({
    required FirestoreReferences references,
    required MapDocumentReference projectRef,
  }) = _ProjectStatesRepository;

  const ProjectStatesRepository._();

  Stream<ProjectStateModel> forUser({
    required String uid,
  }) {
    return references.projectStateCollection(projectRef).doc(uid).snapshots(includeMetadataChanges: true).map(_asModel);
  }

  ProjectStateModel _asModel(MapDocumentSnapshot snapshot) {
    return ProjectStateModel(
      doc: references.asDoc(snapshot),
    );
  }
}

@freezed
class ProjectNodesRepository with _$ProjectNodesRepository {
  const factory ProjectNodesRepository({
    required FirestoreReferences references,
    required MapDocumentReference projectRef,
  }) = _ProjectNodesRepository;

  const ProjectNodesRepository._();

  ProjectNodeModel _asModel(MapDocumentSnapshot snapshot) {
    // TODO: deleted
    final data = snapshot.data();
    final type = data!['type'] as String;
    if (type == 'box') {
      return ProjectBoxNodeModel(
        doc: references.asDoc(snapshot),
      );
    }
    throw UnsupportedError(data.toString());
  }

  List<ProjectNodeModel> _asModels(MapQuerySnapshot snapshot) {
    return snapshot.docs.map(_asModel).toList(growable: false);
  }

  Stream<List<ProjectNodeModel>> all() {
    final ref = references.projectNodesCollection(projectRef);
    return ref.snapshots(includeMetadataChanges: true).map(_asModels);
  }
}

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

  MapDocumentReference reference(String workspaceId) {
    return collection.doc(workspaceId);
  }
}

@freezed
class ProjectWorkspaceStatesRepository with _$ProjectWorkspaceStatesRepository {
  const factory ProjectWorkspaceStatesRepository({
    required FirestoreReferences references,
    required MapDocumentReference projectWorkspaceRef,
  }) = _ProjectWorkspaceStatesRepository;

  const ProjectWorkspaceStatesRepository._();

  ProjectWorkspaceStateModel _asModel(MapDocumentSnapshot snapshot) {
    return ProjectWorkspaceStateModel(
      doc: references.asDoc(snapshot),
    );
  }

  Stream<ProjectWorkspaceStateModel> forUser({required String uid}) {
    return references
        .projectWorkspaceStateCollection(projectWorkspaceRef)
        .doc(uid)
        .snapshots(includeMetadataChanges: true)
        .map(_asModel);
  }
}

@freezed
class ProjectWorkspaceItemsRepository with _$ProjectWorkspaceItemsRepository {
  const factory ProjectWorkspaceItemsRepository({
    required MapDocumentReference workspaceRef,
    required FirestoreReferences references,
  }) = _ProjectWorkspaceItemsRepository;

  const ProjectWorkspaceItemsRepository._();

  ProjectWorkspaceItemModel _asModel(MapDocumentSnapshot snapshot) {
    return ProjectWorkspaceItemModel(
      doc: references.asDoc(snapshot),
    );
  }

  List<ProjectWorkspaceItemModel> _asModels(MapQuerySnapshot snapshot) {
    return snapshot.docs.map(_asModel).toList(growable: false);
  }

  Stream<List<ProjectWorkspaceItemModel>> items() {
    return references
        .projectWorkspaceItemsCollection(workspaceRef)
        .snapshots(includeMetadataChanges: true)
        .map(_asModels);
  }
}
