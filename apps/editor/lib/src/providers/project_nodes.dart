import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petit_editor/src/providers/references.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project_node.dart';
import '../repositories/project_nodes.dart';
import '../typedefs.dart';
import 'firebase.dart';

part 'project_nodes.g.dart';

@Riverpod(dependencies: [firestoreReferences])
ProjectNodesRepository projectNodesRepository(
  ProjectNodesRepositoryRef ref, {
  required MapDocumentReference projectRef,
}) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectNodesRepository(references: references, projectRef: projectRef);
}

@Riverpod(dependencies: [projectNodesRepository])
Stream<List<ProjectNode>> projectNodes(
  ProjectNodesRef ref, {
  required MapDocumentReference projectRef,
}) {
  final repository = ref.watch(projectNodesRepositoryProvider(projectRef: projectRef));
  return repository.all();
}
