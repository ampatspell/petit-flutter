import 'package:fluent_ui/fluent_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../blocks/riverpod/order.dart';
import '../models/project.dart';
import '../models/project_node.dart';
import '../models/projects.dart';
import '../typedefs.dart';
import 'base.dart';
import 'references.dart';

part 'projects.g.dart';

@Riverpod(dependencies: [])
class ProjectDocsOrder extends _$ProjectDocsOrder {
  @override
  OrderDirection build() {
    state = OrderDirection.asc;
    return state;
  }

  void toggle() {
    state = state.next;
  }
}

@Riverpod(dependencies: [firestoreReferences])
Projects projects(ProjectsRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  return Projects(references: references);
}

@Riverpod(dependencies: [firestoreReferences])
ProjectsReset projectsReset(ProjectsResetRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectsReset(references: references);
}

@Riverpod(dependencies: [projects, ProjectDocsOrder])
Stream<List<ProjectDoc>> projectDocsStream(ProjectDocsStreamRef ref) {
  final order = ref.watch(projectDocsOrderProvider);
  return ref.watch(projectsProvider).all(order);
}

@Riverpod(dependencies: [projectsReset])
class ResetProjects extends _$ResetProjects {
  @override
  VoidCallback? build() {
    return reset;
  }

  void reset() async {
    state = null;
    try {
      await ref.read(projectsResetProvider).reset();
    } finally {
      state = reset;
    }
  }
}

@Riverpod(dependencies: [projects])
class NewProject extends _$NewProject {
  @override
  NewProjectData build() {
    return const NewProjectData();
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  VoidCallback? createCallback(void Function(MapDocumentReference) cb) {
    if (!state.isValid || state.isBusy) {
      return null;
    }
    return () async {
      state = state.copyWith(isBusy: true);
      try {
        final reference = await ref.read(projectsProvider).add(state);
        cb(reference);
      } finally {
        state = state.copyWith(isBusy: false);
      }
    };
  }
}

//

@Riverpod(dependencies: [])
List<ProjectDoc> projectDocs(ProjectDocsRef ref) => throw OverrideProviderException();

//

@Riverpod(dependencies: [])
ProjectNodeDoc projectNodeDoc(ProjectNodeDocRef ref) => throw OverrideProviderException();
