import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../widgets/base/order.dart';
import 'base.dart';
import 'project.dart';
import 'project_workspace.dart';
import 'typedefs.dart';

part 'references.freezed.dart';

@freezed
class FirestoreReferences with _$FirestoreReferences {
  const factory FirestoreReferences({
    required FirebaseServices services,
    required String? uid,
  }) = _FirestoreReferences;

  const FirestoreReferences._();

  FirebaseFirestore get _firestore => services.firestore;

  MapCollectionReference projectsCollection() {
    return _firestore.collection('projects');
  }

  MapDocumentReference projectById(String projectId) {
    return projectsCollection().doc(projectId);
  }

  MapCollectionReference projectStateCollection(MapDocumentReference projectRef) {
    return projectRef.collection('state');
  }

  MapDocumentReference projectStateReferenceByRef(MapDocumentReference projectRef) {
    return projectStateCollection(projectRef).doc(uid!);
  }

  MapCollectionReference projectNodesCollection(MapDocumentReference projectRef) {
    return projectRef.collection('nodes');
  }

  MapCollectionReference projectWorkspacesCollection(MapDocumentReference projectRef) {
    return projectRef.collection('workspaces');
  }

  MapDocumentReference projectWorkspaceById(MapDocumentReference projectRef, String workspaceId) {
    return projectWorkspacesCollection(projectRef).doc(workspaceId);
  }

  MapCollectionReference projectWorkspaceStateCollection(MapDocumentReference workspaceRef) {
    return workspaceRef.collection('state');
  }

  MapDocumentReference projectWorkspaceStateByRef(MapDocumentReference workspaceRef) {
    return projectWorkspaceStateCollection(workspaceRef).doc(uid!);
  }

  MapCollectionReference projectWorkspaceItemsCollection(MapDocumentReference workspaceRef) {
    return workspaceRef.collection('items');
  }
}

@freezed
class FirestoreStreams with _$FirestoreStreams {
  const factory FirestoreStreams({
    required FirestoreReferences references,
  }) = _FirestoreStreams;

  const FirestoreStreams._();

  Doc _asDoc(MapDocumentSnapshot snapshot, {bool isOptional = false}) {
    return Doc(
      reference: snapshot.reference,
      isDeleted: !snapshot.exists,
      isOptional: isOptional,
      data: snapshot.data() ?? {},
    );
  }

  ProjectModel _asProjectModel(MapDocumentSnapshot snapshot) {
    return ProjectModel(
      doc: _asDoc(snapshot),
    );
  }

  List<ProjectModel> _asProjectModels(MapQuerySnapshot event) {
    return event.docs.map(_asProjectModel).toList(growable: false);
  }

  Stream<List<ProjectModel>> projects({required OrderDirection order}) {
    return references
        .projectsCollection()
        .orderBy('name', descending: order.isDescending)
        .snapshots(includeMetadataChanges: true)
        .map(_asProjectModels);
  }

  Stream<ProjectModel> projectByReference({required MapDocumentReference projectRef}) {
    return projectRef.snapshots(includeMetadataChanges: true).map(_asProjectModel);
  }

  Stream<ProjectModel> projectById({required String projectId}) {
    return projectByReference(
      projectRef: references.projectById(projectId),
    );
  }

  //

  ProjectStateModel _asProjectStateModel(MapDocumentSnapshot snapshot) {
    return ProjectStateModel(doc: _asDoc(snapshot, isOptional: true));
  }

  Stream<ProjectStateModel> projectStateByProjectReference({required MapDocumentReference projectRef}) {
    return references
        .projectStateReferenceByRef(projectRef)
        .snapshots(includeMetadataChanges: true)
        .map(_asProjectStateModel);
  }

  Stream<ProjectStateModel> projectStateByProjectId({required String projectId}) {
    final projectRef = references.projectsCollection().doc(projectId);
    return projectStateByProjectReference(projectRef: projectRef);
  }

  //

  ProjectWorkspaceModel _asProjectWorkspaceModel(MapDocumentSnapshot snapshot) {
    return ProjectWorkspaceModel(doc: _asDoc(snapshot));
  }

  List<ProjectWorkspaceModel> _asProjectWorkspaceModels(MapQuerySnapshot snapshot) {
    return snapshot.docs.map(_asProjectWorkspaceModel).toList(growable: false);
  }

  Stream<List<ProjectWorkspaceModel>> workspacesByProjectReference(MapDocumentReference projectRef) {
    return references
        .projectWorkspacesCollection(projectRef)
        .snapshots(includeMetadataChanges: true)
        .map(_asProjectWorkspaceModels);
  }

  Stream<List<ProjectWorkspaceModel>> workspacesByProjectId(String projectId) {
    return workspacesByProjectReference(references.projectById(projectId));
  }

  //

  ProjectWorkspaceStateModel _asProjectWorkspaceStateModel(MapDocumentSnapshot snapshot) {
    return ProjectWorkspaceStateModel(doc: _asDoc(snapshot, isOptional: true));
  }

  Stream<ProjectWorkspaceStateModel> workspaceStateByWorkspaceReference({required MapDocumentReference workspaceRef}) {
    return references
        .projectWorkspaceStateByRef(workspaceRef)
        .snapshots(includeMetadataChanges: true)
        .map(_asProjectWorkspaceStateModel);
  }

  Stream<ProjectWorkspaceModel> workspaceById({required String projectId, required String workspaceId}) {
    final projectRef = references.projectById(projectId);
    final workspaceRef = references.projectWorkspaceById(projectRef, workspaceId);
    return workspaceRef.snapshots(includeMetadataChanges: true).map(_asProjectWorkspaceModel);
  }

  Stream<ProjectWorkspaceStateModel> workspaceStateById({required String projectId, required String workspaceId}) {
    final projectRef = references.projectById(projectId);
    final workspaceRef = references.projectWorkspaceById(projectRef, workspaceId);
    return references
        .projectWorkspaceStateByRef(workspaceRef)
        .snapshots(includeMetadataChanges: true)
        .map(_asProjectWorkspaceStateModel);
  }
}

@Freezed(toStringOverride: false)
class Doc with _$Doc {
  const factory Doc({
    required MapDocumentReference reference,
    required FirestoreMap data,
    required bool isDeleted,
    @Default(false) bool isOptional,
  }) = _Doc;

  const Doc._();

  String get id => reference.id;

  String get path => reference.path;

  dynamic operator [](String key) => data[key];

  bool _noChanges(FirestoreMap map, bool force) {
    if (force) {
      return false;
    }
    final current = <String, dynamic>{};
    for (final key in map.keys) {
      current[key] = data[key];
    }
    return mapEquals(current, map);
  }

  Future<void> merge(FirestoreMap map, [bool force = false]) async {
    if (_noChanges(map, force)) {
      return;
    }
    await reference.set(map, SetOptions(merge: true));
  }

  Future<void> set(FirestoreMap map, [bool force = false]) async {
    if (_noChanges(map, force)) {
      return;
    }
    await reference.set(map);
  }

  Future<void> delete() async {
    await reference.delete();
  }

  @override
  String toString() {
    return 'Doc{path: ${reference.path}, data: $data';
  }
}

abstract class HasDoc {
  Doc get doc;
}
