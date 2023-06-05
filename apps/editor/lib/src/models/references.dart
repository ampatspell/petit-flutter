part of 'models.dart';

class FirestoreReferences {
  FirebaseFirestore get _firestore => it.get();

  MapCollectionReference projects() {
    return _firestore.collection('projects');
  }

  MapDocumentReference projectById(String projectId) {
    return projects().doc(projectId);
  }

  MapCollectionReference projectStatesByRef(MapDocumentReference projectRef) {
    return projectRef.collection('state');
  }

  MapDocumentReference projectStateById({required String projectId, required String uid}) {
    final projectRef = projectById(projectId);
    return projectStatesByRef(projectRef).doc(uid);
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

  MapDocumentReference projectWorkspaceStateByRef({required MapDocumentReference workspaceRef, required String uid}) {
    return projectWorkspaceStatesByRef(workspaceRef).doc(uid);
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
