import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../app/typedefs.dart';
import 'base.dart';

part 'references.freezed.dart';

@freezed
class FirestoreReferences with _$FirestoreReferences {
  const factory FirestoreReferences({
    required FirebaseServices services,
    required String? uid,
  }) = _FirestoreReferences;

  const FirestoreReferences._();

  FirebaseFirestore get _firestore => services.firestore;

  MapCollectionReference projects() {
    return _firestore.collection('projects');
  }

  MapDocumentReference projectById(String projectId) {
    return projects().doc(projectId);
  }

  MapCollectionReference projectStatesByRef(MapDocumentReference projectRef) {
    return projectRef.collection('state');
  }

  MapDocumentReference projectStateById({required String projectId}) {
    final projectRef = projectById(projectId);
    return projectStatesByRef(projectRef).doc(uid!);
  }

  MapCollectionReference projectNodesByRef(MapDocumentReference projectRef) {
    return projectRef.collection('nodes');
  }

  MapCollectionReference projectWorkspacesByRef(MapDocumentReference projectRef) {
    return projectRef.collection('workspaces');
  }

  MapDocumentReference projectWorkspaceById({required String projectId, required String workspaceId}) {
    final projectRef = projectById(projectId);
    return projectWorkspacesByRef(projectRef).doc(workspaceId);
  }

  MapCollectionReference projectWorkspaceStatesByRef(MapDocumentReference workspaceRef) {
    return workspaceRef.collection('state');
  }

  MapDocumentReference projectWorkspaceStateByRef(MapDocumentReference workspaceRef) {
    return projectWorkspaceStatesByRef(workspaceRef).doc(uid!);
  }

  MapCollectionReference projectWorkspaceItemsCollection(MapDocumentReference workspaceRef) {
    return workspaceRef.collection('items');
  }

  MapCollectionReference nodesById({required String projectId}) {
    final projectRef = projectById(projectId);
    return projectNodesByRef(projectRef);
  }

  MapCollectionReference projectWorkspaceItemsById({required String projectId, required String workspaceId}) {
    final workspaceRef = projectWorkspaceById(projectId: projectId, workspaceId: workspaceId);
    return projectWorkspaceItemsCollection(workspaceRef);
  }

  MapCollectionReference projectWorkspacesById({required String projectId}) {
    final projectRef = projectById(projectId);
    return projectWorkspacesByRef(projectRef);
  }
}
