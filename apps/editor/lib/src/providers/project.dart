import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petit_editor/src/typedefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/project.dart';

part 'project.g.dart';

@Riverpod()
ProjectRepository projectRepository(ProjectRepositoryRef ref, {required MapDocumentReference projectRef}) {
  return ProjectRepository(projectRef: projectRef);
}
