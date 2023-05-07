import '../models/project.dart';
import '../typedefs.dart';
import 'references.dart';

class ProjectsRepository {
  final FirestoreReferences references;

  const ProjectsRepository({
    required this.references,
  });

  MapCollectionReference get reference => references.projects;

  Stream<Projects> allProjects() {
    return reference.orderBy('name').snapshots(includeMetadataChanges: false).map((event) {
      return event.docs.map((e) {
        return Project(
          reference: e.reference,
          data: e.data(),
        );
      }).toList(growable: false);
    }).map((all) {
      return Projects(
        reference: reference,
        all: all,
      );
    });
  }

  Future<MapDocumentReference> addProject({
    required String name,
  }) async {
    final ref = reference.doc();
    await ref.set({
      'name': name,
    });
    return ref;
  }
}
