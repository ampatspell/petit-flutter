import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petit_editor/src/repositories/project_workspaces.dart';
import 'package:petit_editor/src/typedefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'firebase.dart';
import 'references.dart';

part 'project_workspaces.g.dart';

@Riverpod(dependencies: [firestoreReferences])
ProjectWorkspacesRepository projectWorkspacesRepository(
  ProjectWorkspacesRepositoryRef ref, {
  required MapDocumentReference projectRef,
}) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectWorkspacesRepository(references: references, projectRef: projectRef);
}
