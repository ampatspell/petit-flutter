import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project.dart';
import '../models/project_node.dart';
import '../models/project_workspace.dart';
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
  final repository = ref.watch(projectsRepositoryProvider);
  return repository.all(orderDirection);
}

@Riverpod(dependencies: [firestoreReferences])
MapDocumentReference projectReferenceById(
  ProjectReferenceByIdRef ref, {
  required String projectId,
}) {
  final references = ref.watch(firestoreReferencesProvider);
  return references.projects().doc(projectId);
}

@Riverpod(dependencies: [projectsRepository])
Raw<Stream<ProjectModel>> projectModelStreamByProjectReference(
  ProjectModelStreamByProjectReferenceRef ref, {
  required MapDocumentReference projectRef,
}) {
  final repository = ref.watch(projectsRepositoryProvider);
  return repository.byReference(projectRef);
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
  final repository = ref.watch(projectNodesRepositoryByProjectRefProvider(
    projectRef: projectRef,
  ));
  return repository.all();
}

@Riverpod(dependencies: [projectWorkspacesRepositoryByProjectRef])
Raw<Stream<List<ProjectWorkspaceModel>>> projectWorkspaceModelsStreamByProjectReference(
  ProjectWorkspaceModelsStreamByProjectReferenceRef ref, {
  required MapDocumentReference projectRef,
}) {
  final repository = ref.watch(projectWorkspacesRepositoryByProjectRefProvider(
    projectRef: projectRef,
  ));
  return repository.all();
}
