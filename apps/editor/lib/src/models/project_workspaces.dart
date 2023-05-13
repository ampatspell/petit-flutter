import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:petit_editor/src/models/project_workspace.dart';
import 'package:petit_editor/src/models/references.dart';
import 'package:petit_editor/src/typedefs.dart';

part 'project_workspaces.freezed.dart';

@freezed
class ProjectWorkspaces with _$ProjectWorkspaces {
  const factory ProjectWorkspaces({
    required FirestoreReferences references,
    required MapDocumentReference projectRef,
  }) = _ProjectWorkspaces;

  const ProjectWorkspaces._();

  ProjectWorkspaceDoc _asDoc(MapDocumentSnapshot snapshot) {
    return ProjectWorkspaceDoc(
      reference: snapshot.reference,
      data: snapshot.data() ?? {},
      isDeleted: snapshot.exists,
    );
  }

  List<ProjectWorkspaceDoc> _asDocs(MapQuerySnapshot event) {
    return event.docs.map((e) => _asDoc(e)).toList(growable: false);
  }

  Stream<List<ProjectWorkspaceDoc>> all() {
    final ref = references.projectWorkspacesCollection(projectRef);
    return ref.snapshots(includeMetadataChanges: false).map((event) => _asDocs(event));
  }
}
