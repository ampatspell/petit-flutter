import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'project_node.dart';
import 'references.dart';
import 'typedefs.dart';

part 'project_nodes.freezed.dart';

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
