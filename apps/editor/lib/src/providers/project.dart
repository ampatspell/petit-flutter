import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:petit_editor/src/models/project_node.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project.dart';
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

@Riverpod(dependencies: [projectId, projects])
MapDocumentReference projectReference(ProjectReferenceRef ref) {
  final id = ref.watch(projectIdProvider);
  final projects = ref.watch(projectsProvider);
  return projects.referenceById(id);
}

@Riverpod(dependencies: [projectReference, projects])
Stream<ProjectDoc> projectDocStream(ProjectDocStreamRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  final projects = ref.watch(projectsProvider);
  return projects.byReference(projectRef);
}

@Riverpod(dependencies: [firestoreReferences, projectReference])
ProjectNodes projectNodes(ProjectNodesRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  final projectRef = ref.watch(projectReferenceProvider);
  return ProjectNodes(
    references: references,
    projectRef: projectRef,
  );
}

@Riverpod(dependencies: [firestoreReferences, projectReference])
ProjectWorkspaces projectWorkspaces(ProjectWorkspacesRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  final projectRef = ref.watch(projectReferenceProvider);
  return ProjectWorkspaces(
    references: references,
    projectRef: projectRef,
  );
}

@Riverpod(dependencies: [projectNodes])
Stream<List<ProjectNodeDoc>> projectNodeDocsStream(ProjectNodeDocsStreamRef ref) {
  return ref.watch(projectNodesProvider).all();
}

@Riverpod(dependencies: [projectWorkspaces])
Stream<List<ProjectWorkspaceDoc>> projectWorkspaceDocsStream(ProjectWorkspaceDocsStreamRef ref) {
  return ref.watch(projectWorkspacesProvider).all();
}

//

@Riverpod(dependencies: [])
ProjectDoc projectDoc(ProjectDocRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
List<ProjectNodeDoc> projectNodeDocs(ProjectNodeDocsRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
List<ProjectWorkspaceDoc> projectWorkspaceDocs(ProjectWorkspaceDocsRef ref) => throw OverrideProviderException();

//

@Riverpod(dependencies: [projectDoc, projectWorkspaceDocs])
ProjectWorkspaceDoc? projectWorkspaceDoc(ProjectWorkspaceDocRef ref) {
  final id = ref.watch(projectDocProvider.select((value) => value.workspace));
  if (id == null) {
    return null;
  }
  return ref.watch(projectWorkspaceDocsProvider.select((value) {
    return value.firstWhereOrNull((element) => element.doc.id == id);
  }));
}

@Riverpod(dependencies: [projectDoc])
class ProjectDocDelete extends _$ProjectDocDelete {
  @override
  VoidCallback? build() {
    state = commit;
    return state;
  }

  void commit() async {
    final doc = ref.read(projectDocProvider);
    state = null;
    try {
      await doc.delete();
    } finally {
      state = commit;
    }
  }
}
