import 'package:petit_editor/src/blocks/riverpod/order.dart';

import '../models/project.dart';
import '../typedefs.dart';
import 'references.dart';

class ProjectsRepository {
  final FirestoreReferences references;

  const ProjectsRepository({
    required this.references,
  });

  MapCollectionReference get reference => references.projects;

  Stream<List<Project>> allProjects(OrderDirection order) {
    return reference
        .orderBy('name', descending: order.isDescending)
        .snapshots(includeMetadataChanges: false)
        .map((event) {
      return event.docs.map((e) {
        return Project(
          reference: e.reference,
          data: e.data(),
        );
      }).toList(growable: false);
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
