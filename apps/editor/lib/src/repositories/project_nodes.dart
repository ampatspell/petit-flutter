import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petit_editor/src/models/project_node.dart';
import 'package:petit_editor/src/typedefs.dart';

import 'references.dart';

class ProjectNodesRepository {
  final FirestoreReferences _references;
  final MapDocumentReference projectRef;

  const ProjectNodesRepository({
    required FirestoreReferences references,
    required this.projectRef,
  }) : _references = references;

  MapCollectionReference get reference => _references.projectNodesCollection(projectRef);

  Stream<List<ProjectNode>> all() {
    return reference.snapshots(includeMetadataChanges: false).map((event) {
      return event.docs.map((e) {
        return _toProjectNode(e);
      }).toList(growable: false);
    });
  }

  ProjectNode _toProjectNode(QueryDocumentSnapshot<FirestoreMap> e) {
    final reference = e.reference;
    final data = e.data();
    final type = data['type'] as String;
    if (type == 'box') {
      return ProjectBoxNode(reference: reference, data: data);
    }
    throw UnsupportedError(data.toString());
  }

  @override
  String toString() {
    return 'ProjectNodesRepository{collection: ${reference.path}}';
  }
}
