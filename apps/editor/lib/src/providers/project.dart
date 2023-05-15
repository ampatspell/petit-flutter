import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project.dart';
import '../models/project_node.dart';
import '../models/project_nodes.dart';
import '../models/project_workspace.dart';
import '../models/project_workspaces.dart';
import '../models/projects.dart';
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

@Riverpod(dependencies: [firestoreReferences, projectReference])
ProjectStatesRepository projectStatesRepository(ProjectStatesRepositoryRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  final projectRef = ref.watch(projectReferenceProvider);
  return ProjectStatesRepository(references: references, projectRef: projectRef);
}

@Riverpod(dependencies: [projectStatesRepository, authStateChanges])
Stream<ProjectStateModel> projectStateModelStream(ProjectStateModelStreamRef ref) {
  final repository = ref.watch(projectStatesRepositoryProvider);
  final user = ref.watch(authStateChangesProvider).requireValue!;
  return repository.forUser(
    uid: user.uid,
  );
}

//

@Riverpod(dependencies: [])
ProjectModel projectModel(ProjectModelRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
ProjectStateModel projectStateModel(ProjectStateModelRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
List<ProjectNodeModel> projectNodeModels(ProjectNodeModelsRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
List<ProjectWorkspaceModel> projectWorkspaceModels(ProjectWorkspaceModelsRef ref) => throw OverrideProviderException();

//

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

//

@Riverpod(dependencies: [projectStateModel, projectWorkspaceModels])
ProjectWorkspaceModel? selectedProjectWorkspaceModel(SelectedProjectWorkspaceModelRef ref) {
  final id = ref.watch(projectStateModelProvider.select((value) => value.workspace));
  if (id == null) {
    return null;
  }
  return ref.watch(projectWorkspaceModelsProvider.select((value) {
    return value.firstWhereOrNull((element) => element.doc.id == id);
  }));
}

@Riverpod(dependencies: [projectModel, projectNodeModels])
ProjectNodeModel? selectedProjectNodeModel(SelectedProjectNodeModelRef ref) {
  final id = ref.watch(projectModelProvider.select((value) => value.node));
  if (id == null) {
    return null;
  }
  return ref.watch(projectNodeModelsProvider.select((value) {
    return value.firstWhereOrNull((element) => element.doc.id == id);
  }));
}

// TODO: this is just for sidebar
@Riverpod(dependencies: [])
ProjectNodeModel projectNodeModel(ProjectNodeModelRef ref) => throw OverrideProviderException();

//

@Riverpod(dependencies: [])
ProjectWorkspaceModel projectWorkspaceModel(ProjectWorkspaceModelRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [projectWorkspaceModel, firestoreReferences])
ProjectWorkspaceStatesRepository projectWorkspaceStatesRepository(ProjectWorkspaceStatesRepositoryRef ref) {
  final projectWorkspaceRef = ref.watch(projectWorkspaceModelProvider.select((value) => value.doc.reference));
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectWorkspaceStatesRepository(
    projectWorkspaceRef: projectWorkspaceRef,
    references: references,
  );
}

@Riverpod(dependencies: [projectWorkspaceModel, firestoreReferences])
ProjectWorkspaceItemsModel projectWorkspaceItemsModel(ProjectWorkspaceItemsModelRef ref) {
  final workspace = ref.watch(projectWorkspaceModelProvider);
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectWorkspaceItemsModel(workspace: workspace, references: references);
}

@Riverpod(dependencies: [projectWorkspaceItemsModel])
Stream<List<ProjectWorkspaceItemModel>> projectWorkspaceItemModelsStream(ProjectWorkspaceItemModelsStreamRef ref) {
  return ref.watch(projectWorkspaceItemsModelProvider).items();
}

//

@Riverpod(dependencies: [])
List<ProjectWorkspaceItemModel> projectWorkspaceItemModels(ProjectWorkspaceItemModelsRef ref) =>
    throw OverrideProviderException();

@Riverpod(dependencies: [])
ProjectWorkspaceItemModel projectWorkspaceItemModel(ProjectWorkspaceItemModelRef ref) =>
    throw OverrideProviderException();

@Riverpod(dependencies: [projectWorkspaceItemModel, projectNodeModels])
ProjectNodeModel projectWorkspaceItemNodeModel(ProjectWorkspaceItemNodeModelRef ref) {
  final id = ref.watch(projectWorkspaceItemModelProvider.select((value) => value.node));
  return ref.watch(projectNodeModelsProvider.select((value) {
    return value.firstWhere((node) => node.doc.id == id);
  }));
}
