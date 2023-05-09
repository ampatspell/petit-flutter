import 'package:petit_editor/src/repositories/references.dart';
import 'package:petit_editor/src/typedefs.dart';

class ProjectRepository {
  final FirestoreReferences references;
  final MapDocumentReference projectRef;

  ProjectRepository({
    required this.projectRef,
    required this.references,
  });

  @override
  String toString() {
    return 'ProjectRepository{projectRef.path: ${projectRef.path}}';
  }

  Future<void> delete() async {
    await projectRef.delete();
  }
}
