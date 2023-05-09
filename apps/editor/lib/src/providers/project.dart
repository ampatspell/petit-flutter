import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petit_editor/src/providers/references.dart';
import 'package:petit_editor/src/typedefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/project.dart';
import 'firebase.dart';

part 'project.g.dart';

@Riverpod(dependencies: [firestoreReferences])
ProjectRepository projectRepository(
  ProjectRepositoryRef ref, {
  required MapDocumentReference projectRef,
}) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectRepository(references: references, projectRef: projectRef);
}
