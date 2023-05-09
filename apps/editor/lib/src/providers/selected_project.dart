import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petit_editor/src/models/project_workspace.dart';
import 'package:petit_editor/src/providers/project_nodes.dart';
import 'package:petit_editor/src/providers/project_workspaces.dart';
import 'package:petit_editor/src/providers/projects.dart';
import 'package:petit_editor/src/repositories/project_workspaces.dart';
import 'package:petit_editor/src/typedefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project.dart';
import '../models/project_node.dart';
import '../repositories/project_nodes.dart';
import 'firebase.dart';
import 'references.dart';

part 'selected_project.g.dart';

@Riverpod(dependencies: [])
MapDocumentReference selectedProjectReference(SelectedProjectReferenceRef ref) => throw UnimplementedError();

@Riverpod(dependencies: [selectedProjectReference, projectsRepository])
Stream<Project> selectedProject(SelectedProjectRef ref) {
  final projectRef = ref.watch(selectedProjectReferenceProvider);
  final repository = ref.watch(projectsRepositoryProvider);
  return repository.byReference(projectRef);
}

@Riverpod(dependencies: [selectedProjectReference, projectNodesRepository])
ProjectNodesRepository selectedProjectNodesRepository(SelectedProjectNodesRepositoryRef ref) {
  final projectRef = ref.watch(selectedProjectReferenceProvider);
  return ref.watch(projectNodesRepositoryProvider(projectRef: projectRef));
}

@Riverpod(dependencies: [selectedProjectNodesRepository])
Stream<List<ProjectNode>> selectedProjectNodes(SelectedProjectNodesRef ref) {
  return ref.watch(selectedProjectNodesRepositoryProvider).all();
}

@Riverpod(dependencies: [selectedProjectReference, projectWorkspacesRepository])
ProjectWorkspacesRepository selectedProjectWorkspacesRepository(SelectedProjectWorkspacesRepositoryRef ref) {
  final projectRef = ref.watch(selectedProjectReferenceProvider);
  return ref.watch(projectWorkspacesRepositoryProvider(projectRef: projectRef));
}

@Riverpod(dependencies: [selectedProjectWorkspacesRepository])
Stream<List<ProjectWorkspace>> selectProjectWorkspaces(SelectProjectWorkspacesRef ref) {
  return ref.watch(selectedProjectWorkspacesRepositoryProvider).all();
}
