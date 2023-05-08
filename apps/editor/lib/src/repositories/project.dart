import 'package:petit_editor/src/typedefs.dart';

class ProjectRepository {
  final MapDocumentReference projectRef;

  ProjectRepository({
    required this.projectRef,
  });

  @override
  String toString() {
    return 'ProjectRepository{projectRef.path: ${projectRef.path}}';
  }
}
