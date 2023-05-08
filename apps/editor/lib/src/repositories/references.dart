import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/firebase.dart';
import '../typedefs.dart';

class FirestoreReferences {
  final FirebaseServices _services;

  FirestoreReferences(FirebaseServices services) : _services = services;

  FirebaseFirestore get _firestore => _services.firestore;

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

  @override
  String toString() {
    return 'FirestoreReferences{}';
  }
}
