import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'typedefs.dart';
import 'base.dart';

part 'references.freezed.dart';

@freezed
class FirestoreReferences with _$FirestoreReferences {
  const factory FirestoreReferences({
    required FirebaseServices services,
  }) = _FirestoreReferences;

  const FirestoreReferences._();

  FirebaseFirestore get _firestore => services.firestore;

  MapCollectionReference projects() {
    return _firestore.collection('projects');
  }

  MapCollectionReference projectNodesCollection(MapDocumentReference projectRef) {
    return projectRef.collection('nodes');
  }

  MapCollectionReference projectWorkspacesCollection(MapDocumentReference projectRef) {
    return projectRef.collection('workspaces');
  }

  MapCollectionReference projectWorkspaceItemsCollection(MapDocumentReference workspaceRef) {
    return workspaceRef.collection('items');
  }
}
