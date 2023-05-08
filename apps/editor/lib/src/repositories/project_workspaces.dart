import 'package:petit_editor/src/typedefs.dart';

import '../models/project_workspace.dart';
import 'references.dart';

class ProjectWorkspacesRepository {
  final FirestoreReferences _references;
  final MapDocumentReference projectRef;

  const ProjectWorkspacesRepository({
    required FirestoreReferences references,
    required this.projectRef,
  }) : _references = references;

  MapCollectionReference get reference => _references.projectWorkspacesCollection(projectRef);

  Stream<List<ProjectWorkspace>> all() {
    return reference.snapshots(includeMetadataChanges: false).map((event) {
      return event.docs.map((e) {
        return ProjectWorkspace(reference: e.reference, data: e.data());
      }).toList(growable: false);
    });
  }

  @override
  String toString() {
    return 'ProjectWorkspacesRepository{collection: ${reference.path}}';
  }
}
