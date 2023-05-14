import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project.dart';
import '../models/project_node.dart';
import '../models/project_nodes.dart';
import '../models/project_workspace.dart';
import '../models/project_workspaces.dart';
import '../models/typedefs.dart';
import 'base.dart';
import 'projects.dart';
import 'references.dart';

part 'project.g.dart';

@Riverpod(dependencies: [])
String projectId(ProjectIdRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [projectId, projectsRepository])
MapDocumentReference projectReference(ProjectReferenceRef ref) {
  final id = ref.watch(projectIdProvider);
  final repository = ref.watch(projectsRepositoryProvider);
  return repository.referenceById(id);
}

@Riverpod(dependencies: [projectReference, projectsRepository])
Stream<ProjectModel> projectModelStream(ProjectModelStreamRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  final repository = ref.watch(projectsRepositoryProvider);
  return repository.byReference(projectRef);
}

@Riverpod(dependencies: [firestoreReferences, projectReference])
ProjectNodesRepository projectNodesRepository(ProjectNodesRepositoryRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  final projectRef = ref.watch(projectReferenceProvider);
  return ProjectNodesRepository(
    references: references,
    projectRef: projectRef,
  );
}

@Riverpod(dependencies: [firestoreReferences, projectReference])
ProjectWorkspacesRepository projectWorkspacesRepository(ProjectWorkspacesRepositoryRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  final projectRef = ref.watch(projectReferenceProvider);
  return ProjectWorkspacesRepository(
    references: references,
    projectRef: projectRef,
  );
}

@Riverpod(dependencies: [projectNodesRepository])
Stream<List<ProjectNodeModel>> projectNodeModelsStream(ProjectNodeModelsStreamRef ref) {
  return ref.watch(projectNodesRepositoryProvider).all();
}

@Riverpod(dependencies: [projectWorkspacesRepository])
Stream<List<ProjectWorkspaceModel>> projectWorkspaceModelsStream(ProjectWorkspaceModelsStreamRef ref) {
  return ref.watch(projectWorkspacesRepositoryProvider).all();
}

//

@Riverpod(dependencies: [])
ProjectModel projectModel(ProjectModelRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
List<ProjectNodeModel> projectNodeModels(ProjectNodeModelsRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
List<ProjectWorkspaceModel> projectWorkspaceModels(ProjectWorkspaceModelsRef ref) => throw OverrideProviderException();

//

@Riverpod(dependencies: [projectModel, projectWorkspaceModels])
ProjectWorkspaceModel? projectWorkspaceModel(ProjectWorkspaceModelRef ref) {
  final id = ref.watch(projectModelProvider.select((value) => value.workspace));
  if (id == null) {
    return null;
  }
  return ref.watch(projectWorkspaceModelsProvider.select((value) {
    return value.firstWhereOrNull((element) => element.doc.id == id);
  }));
}

@Riverpod(dependencies: [projectModel])
class ProjectDocDelete extends _$ProjectDocDelete {
  @override
  VoidCallback? build() {
    return commit;
  }

  void commit() async {
    final doc = ref.read(projectModelProvider);
    state = null;
    try {
      await doc.delete();
    } finally {
      state = commit;
    }
  }
}

@Riverpod(dependencies: [])
ProjectNodeModel projectNodeModel(ProjectNodeModelRef ref) => throw OverrideProviderException();
