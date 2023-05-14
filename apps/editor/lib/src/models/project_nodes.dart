import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:petit_editor/src/models/project_node.dart';
import 'package:petit_editor/src/models/references.dart';
import 'package:petit_editor/src/models/typedefs.dart';

part 'project_nodes.freezed.dart';

@freezed
class ProjectNodes with _$ProjectNodes {
  const factory ProjectNodes({
    required FirestoreReferences references,
    required MapDocumentReference projectRef,
  }) = _ProjectNodes;

  const ProjectNodes._();

  ProjectNodeDoc _asDoc(MapDocumentSnapshot snapshot) {
    // TODO: deleted
    final data = snapshot.data();
    final type = data!['type'] as String;
    if (type == 'box') {
      return ProjectBoxNodeDoc(
        doc: references.asDoc(snapshot),
      );
    }
    throw UnsupportedError(data.toString());
  }

  List<ProjectNodeDoc> _asDocs(MapQuerySnapshot snapshot) {
    return snapshot.docs.map((snapshot) {
      return _asDoc(snapshot);
    }).toList(growable: false);
  }

  Stream<List<ProjectNodeDoc>> all() {
    final ref = references.projectNodesCollection(projectRef);
    return ref.snapshots(includeMetadataChanges: true).map((event) {
      return _asDocs(event);
    });
  }
}
