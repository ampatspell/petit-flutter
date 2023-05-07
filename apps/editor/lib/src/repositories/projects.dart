import '../models/project.dart';
import '../typedefs.dart';
import 'references.dart';

class ProjectsRepository {
  final FirestoreReferences references;

  ProjectsRepository({
    required this.references,
  });

  Stream<List<Project>> allProjects() {
    return references.sortedProjects.snapshots(includeMetadataChanges: false).map((event) {
      return event.docs.map((e) {
        return Project(
          reference: e.reference,
          data: e.data(),
        );
      }).toList(growable: false);
    });
  }

  Future<MapDocumentReference> addProject({required String name}) async {
    final ref = references.projects.doc();
    await ref.set({'name': name});
    return ref;
  }
}
