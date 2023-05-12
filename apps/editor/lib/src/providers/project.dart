import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project.dart';
import '../models/project_node.dart';
import '../models/project_workspace.dart';
import '../repositories/project.dart';
import '../repositories/project_nodes.dart';
import '../repositories/project_workspaces.dart';
import '../typedefs.dart';
import 'firebase.dart';
import 'projects.dart';
import 'references.dart';

part 'project.g.dart';

@Riverpod(dependencies: [])
MapDocumentReference projectReference(ProjectReferenceRef ref) => throw UnimplementedError('override');

@Riverpod(dependencies: [projectReference, projectsRepository])
Stream<Project> project(ProjectRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  final repository = ref.watch(projectsRepositoryProvider);
  return repository.byReference(projectRef);
}

@Riverpod(dependencies: [projectReference, firestoreReferences])
ProjectRepository projectRepository(ProjectRepositoryRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectRepository(references: references, projectRef: projectRef);
}

@Riverpod(dependencies: [projectReference, firestoreReferences])
ProjectNodesRepository projectNodesRepository(ProjectNodesRepositoryRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectNodesRepository(references: references, projectRef: projectRef);
}

@Riverpod(dependencies: [projectNodesRepository])
Stream<List<ProjectNode>> projectNodes(ProjectNodesRef ref) {
  final repository = ref.watch(projectNodesRepositoryProvider);
  return repository.all();
}

@Riverpod(dependencies: [projectReference, firestoreReferences])
ProjectWorkspacesRepository projectWorkspacesRepository(ProjectWorkspacesRepositoryRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectWorkspacesRepository(references: references, projectRef: projectRef);
}

@Riverpod(dependencies: [projectWorkspacesRepository])
Stream<List<ProjectWorkspace>> projectWorkspaces(ProjectWorkspacesRef ref) {
  return ref.watch(projectWorkspacesRepositoryProvider).all();
}

@Riverpod(dependencies: [projectRepository])
class ProjectDelete extends _$ProjectDelete {
  @override
  VoidCallback? build() {
    state = commit;
    return state;
  }

  void commit() async {
    final repository = ref.read(projectRepositoryProvider);
    state = null;
    try {
      await repository.delete();
    } finally {
      state = commit;
    }
  }
}

//

@Riverpod(dependencies: [])
Project loadedProject(LoadedProjectRef ref) => throw UnimplementedError('override');

@Riverpod(dependencies: [])
List<ProjectNode> loadedProjectNodes(LoadedProjectNodesRef ref) => throw UnimplementedError('override');

@Riverpod(dependencies: [])
List<ProjectWorkspace> loadedProjectWorkspaces(LoadedProjectWorkspacesRef ref) => throw UnimplementedError('override');
