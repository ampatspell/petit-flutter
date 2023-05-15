import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project.dart';
import '../models/project_node.dart';
import '../models/repositories.dart';
import '../models/typedefs.dart';
import '../widgets/base/order.dart';
import 'references.dart';

part 'generic.g.dart';

@Riverpod(dependencies: [firestoreReferences])
ProjectsRepository projectsRepository(ProjectsRepositoryRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectsRepository(
    references: references,
  );
}

@Riverpod(dependencies: [projectsRepository])
Raw<Stream<List<ProjectModel>>> projectModelsStreamByOrder(
  ProjectModelsStreamByOrderRef ref, {
  required OrderDirection orderDirection,
}) {
  return ref.watch(projectsRepositoryProvider).all(orderDirection);
}

@Riverpod(dependencies: [firestoreReferences])
MapDocumentReference projectReferenceById(
  ProjectReferenceByIdRef ref, {
  required String projectId,
}) {
  return ref.watch(firestoreReferencesProvider).projects().doc(projectId);
}

@Riverpod(dependencies: [projectsRepository])
Raw<Stream<ProjectModel>> projectModelStreamByProjectReference(
  ProjectModelStreamByProjectReferenceRef ref, {
  required MapDocumentReference projectRef,
}) {
  return ref.watch(projectsRepositoryProvider).byReference(projectRef);
}

@Riverpod(dependencies: [firestoreReferences])
ProjectStatesRepository projectStatesRepositoryByProjectRef(
  ProjectStatesRepositoryByProjectRefRef ref, {
  required MapDocumentReference projectRef,
}) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectStatesRepository(
    references: references,
    projectRef: projectRef,
  );
}

@Riverpod(dependencies: [projectStatesRepositoryByProjectRef])
Raw<Stream<ProjectStateModel>> projectStateModelByProjectRefAndUser(
  ProjectStateModelByProjectRefAndUserRef ref, {
  required MapDocumentReference projectRef,
  required String uid,
}) {
  final repository = ref.watch(projectStatesRepositoryByProjectRefProvider(projectRef: projectRef));
  return repository.forUser(
    uid: uid,
  );
}

@Riverpod(dependencies: [firestoreReferences])
ProjectNodesRepository projectNodesRepositoryByProjectRef(
  ProjectNodesRepositoryByProjectRefRef ref, {
  required MapDocumentReference projectRef,
}) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectNodesRepository(
    references: references,
    projectRef: projectRef,
  );
}

@Riverpod(dependencies: [firestoreReferences])
ProjectWorkspacesRepository projectWorkspacesRepositoryByProjectRef(
  ProjectWorkspacesRepositoryByProjectRefRef ref, {
  required MapDocumentReference projectRef,
}) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectWorkspacesRepository(
    references: references,
    projectRef: projectRef,
  );
}

@Riverpod(dependencies: [firestoreReferences])
ProjectWorkspaceStatesRepository projectWorkspaceStatesRepository(
  ProjectWorkspaceStatesRepositoryRef ref, {
  required MapDocumentReference projectWorkspaceRef,
}) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectWorkspaceStatesRepository(
    references: references,
    projectWorkspaceRef: projectWorkspaceRef,
  );
}

@Riverpod(dependencies: [projectNodesRepositoryByProjectRef])
Raw<Stream<List<ProjectNodeModel>>> projectNodeModelsByProjectReference(
  ProjectNodeModelsByProjectReferenceRef ref, {
  required MapDocumentReference projectRef,
}) {
  final repository = ref.watch(projectNodesRepositoryByProjectRefProvider(projectRef: projectRef));
  return repository.all();
}

// //
//
// @Riverpod(dependencies: [])
// String projectId(ProjectIdRef ref) => throw OverrideProviderException();
//
// @Riverpod(dependencies: [projectId, projectsRepository])
// MapDocumentReference projectReference(ProjectReferenceRef ref) {
//   final id = ref.watch(projectIdProvider);
//   final repository = ref.watch(projectsRepositoryProvider);
//   return repository.referenceById(id);
// }
//
// @Riverpod(dependencies: [projectReference, projectsRepository])
// Stream<ProjectModel> projectModelStream(ProjectModelStreamRef ref) {
//   final projectRef = ref.watch(projectReferenceProvider);
//   final repository = ref.watch(projectsRepositoryProvider);
//   return repository.byReference(projectRef);
// }
//
// @Riverpod(dependencies: [firestoreReferences, projectReference])
// ProjectNodesRepository projectNodesRepository(ProjectNodesRepositoryRef ref) {
//   final references = ref.watch(firestoreReferencesProvider);
//   final projectRef = ref.watch(projectReferenceProvider);
//   return ProjectNodesRepository(
//     references: references,
//     projectRef: projectRef,
//   );
// }
//
// @Riverpod(dependencies: [firestoreReferences, projectReference])
// ProjectWorkspacesRepository projectWorkspacesRepository(ProjectWorkspacesRepositoryRef ref) {
//   final references = ref.watch(firestoreReferencesProvider);
//   final projectRef = ref.watch(projectReferenceProvider);
//   return ProjectWorkspacesRepository(
//     references: references,
//     projectRef: projectRef,
//   );
// }
//
// @Riverpod(dependencies: [projectNodesRepository])
// Stream<List<ProjectNodeModel>> projectNodeModelsStream(ProjectNodeModelsStreamRef ref) {
//   return ref.watch(projectNodesRepositoryProvider).all();
// }
//
// @Riverpod(dependencies: [projectWorkspacesRepository])
// Stream<List<ProjectWorkspaceModel>> projectWorkspaceModelsStream(ProjectWorkspaceModelsStreamRef ref) {
//   return ref.watch(projectWorkspacesRepositoryProvider).all();
// }
//
// @Riverpod(dependencies: [firestoreReferences, projectReference])
// ProjectStatesRepository projectStatesRepository(ProjectStatesRepositoryRef ref) {
//   final references = ref.watch(firestoreReferencesProvider);
//   final projectRef = ref.watch(projectReferenceProvider);
//   return ProjectStatesRepository(references: references, projectRef: projectRef);
// }
//
// @Riverpod(dependencies: [projectStatesRepository, authStateChanges])
// Stream<ProjectStateModel> projectStateModelStream(ProjectStateModelStreamRef ref) {
//   final repository = ref.watch(projectStatesRepositoryProvider);
//   final user = ref.watch(authStateChangesProvider).requireValue!;
//   return repository.forUser(
//     uid: user.uid,
//   );
// }
//
// //
//
// @Riverpod(dependencies: [])
// ProjectModel projectModel(ProjectModelRef ref) => throw OverrideProviderException();
//
// @Riverpod(dependencies: [])
// ProjectStateModel projectStateModel(ProjectStateModelRef ref) => throw OverrideProviderException();
//
// @Riverpod(dependencies: [])
// List<ProjectNodeModel> projectNodeModels(ProjectNodeModelsRef ref) => throw OverrideProviderException();
//
// @Riverpod(dependencies: [])
// List<ProjectWorkspaceModel> projectWorkspaceModels(ProjectWorkspaceModelsRef ref) => throw OverrideProviderException();
//
// //
//
// @Riverpod(dependencies: [projectModel])
// class ProjectDocDelete extends _$ProjectDocDelete {
//   @override
//   VoidCallback? build() {
//     return commit;
//   }
//
//   void commit() async {
//     final doc = ref.read(projectModelProvider);
//     state = null;
//     try {
//       await doc.delete();
//     } finally {
//       state = commit;
//     }
//   }
// }
//
// //
//
// @Riverpod(dependencies: [projectStateModel, projectReference, firestoreReferences])
// MapDocumentReference? projectWorkspaceReference(ProjectWorkspaceReferenceRef ref) {
//   final id = ref.watch(projectStateModelProvider.select((value) => value.workspace));
//   if (id == null) {
//     return null;
//   }
//   final projectRef = ref.watch(projectReferenceProvider);
//   return ref.watch(firestoreReferencesProvider).projectWorkspacesCollection(projectRef).doc(id);
// }
//
// @Riverpod(dependencies: [projectWorkspaceReference, projectWorkspaceModels])
// ProjectWorkspaceModel? selectedProjectWorkspaceModel(SelectedProjectWorkspaceModelRef ref) {
//   final reference = ref.watch(projectWorkspaceReferenceProvider);
//   if (reference == null) {
//     return null;
//   }
//   return ref.watch(projectWorkspaceModelsProvider.select((value) {
//     return value.firstWhereOrNull((element) => element.doc.reference == reference);
//   }));
// }
//
// @Riverpod(dependencies: [projectModel, projectNodeModels])
// ProjectNodeModel? selectedProjectNodeModel(SelectedProjectNodeModelRef ref) {
//   final id = ref.watch(projectModelProvider.select((value) => value.node));
//   if (id == null) {
//     return null;
//   }
//   return ref.watch(projectNodeModelsProvider.select((value) {
//     return value.firstWhereOrNull((element) => element.doc.id == id);
//   }));
// }
//
// // TODO: this is just for sidebar
// @Riverpod(dependencies: [])
// ProjectNodeModel projectNodeModel(ProjectNodeModelRef ref) => throw OverrideProviderException();
//
// //
//
// @Riverpod(dependencies: [])
// ProjectWorkspaceModel projectWorkspaceModel(ProjectWorkspaceModelRef ref) => throw OverrideProviderException();
//
// @Riverpod(dependencies: [projectWorkspaceModel, firestoreReferences])
// ProjectWorkspaceStatesRepository projectWorkspaceStatesRepository(ProjectWorkspaceStatesRepositoryRef ref) {
//   final projectWorkspaceRef = ref.watch(projectWorkspaceModelProvider.select((value) => value.doc.reference));
//   final references = ref.watch(firestoreReferencesProvider);
//   return ProjectWorkspaceStatesRepository(
//     projectWorkspaceRef: projectWorkspaceRef,
//     references: references,
//   );
// }
//
// @Riverpod(dependencies: [projectWorkspaceModel, firestoreReferences])
// ProjectWorkspaceItemsRepository projectWorkspaceItemsRepository(ProjectWorkspaceItemsRepositoryRef ref) {
//   final workspaceRef = ref.watch(projectWorkspaceModelProvider.select((value) => value.doc.reference));
//   final references = ref.watch(firestoreReferencesProvider);
//   return ProjectWorkspaceItemsRepository(
//     workspaceRef: workspaceRef,
//     references: references,
//   );
// }
//
// @Riverpod(dependencies: [projectWorkspaceItemsRepository])
// Stream<List<ProjectWorkspaceItemModel>> projectWorkspaceItemModelsStream(ProjectWorkspaceItemModelsStreamRef ref) {
//   return ref.watch(projectWorkspaceItemsRepositoryProvider).items();
// }
//
// //
//
// @Riverpod(dependencies: [])
// List<ProjectWorkspaceItemModel> projectWorkspaceItemModels(ProjectWorkspaceItemModelsRef ref) =>
//     throw OverrideProviderException();
//
// @Riverpod(dependencies: [])
// ProjectWorkspaceItemModel projectWorkspaceItemModel(ProjectWorkspaceItemModelRef ref) =>
//     throw OverrideProviderException();
//
// @Riverpod(dependencies: [projectWorkspaceItemModel, projectNodeModels])
// ProjectNodeModel projectWorkspaceItemNodeModel(ProjectWorkspaceItemNodeModelRef ref) {
//   final id = ref.watch(projectWorkspaceItemModelProvider.select((value) => value.node));
//   return ref.watch(projectNodeModelsProvider.select((value) {
//     return value.firstWhere((node) => node.doc.id == id);
//   }));
// }
