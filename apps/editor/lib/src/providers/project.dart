import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project.dart';
import '../models/project_node.dart';
import '../models/typedefs.dart';
import 'base.dart';
import 'generic.dart';
import 'references.dart';

part 'project.g.dart';

@Riverpod(dependencies: [])
String projectId(ProjectIdRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [projectId, firestoreReferences])
MapDocumentReference projectReference(ProjectReferenceRef ref) {
  final id = ref.watch(projectIdProvider);
  return ref.watch(firestoreReferencesProvider).projects().doc(id);
}

@Riverpod(dependencies: [projectReference, projectModelStreamByProjectReference])
Stream<ProjectModel> projectModelStream(ProjectModelStreamRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  return ref.watch(projectModelStreamByProjectReferenceProvider(projectRef: projectRef));
}

@Riverpod(dependencies: [projectReference, uid, projectStateModelByProjectRefAndUser])
Stream<ProjectStateModel> projectStateModelStream(ProjectStateModelStreamRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  final uid = ref.watch(uidProvider)!;
  return ref.watch(projectStateModelByProjectRefAndUserProvider(
    projectRef: projectRef,
    uid: uid,
  ));
}

@Riverpod(dependencies: [projectReference, projectNodeModelsByProjectReference])
Stream<List<ProjectNodeModel>> projectNodeModelsStream(ProjectNodeModelsStreamRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  return ref.watch(projectNodeModelsByProjectReferenceProvider(
    projectRef: projectRef,
  ));
}

//

@Riverpod(dependencies: [])
ProjectModel projectModel(ProjectModelRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
ProjectStateModel projectStateModel(ProjectStateModelRef ref) => throw OverrideProviderException();

@Riverpod()
List<ProjectNodeModel> projectNodeModels(ProjectNodeModelsRef ref) => throw OverrideProviderException();
