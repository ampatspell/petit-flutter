import 'package:fluent_ui/fluent_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project.dart';
import '../models/projects.dart';
import '../models/typedefs.dart';
import '../widgets/base/order.dart';
import 'base.dart';
import 'references.dart';

part 'projects.g.dart';

@Riverpod(dependencies: [])
class ProjectModelsOrder extends _$ProjectModelsOrder {
  @override
  OrderDirection build() {
    return OrderDirection.asc;
  }

  void toggle() {
    state = state.next;
  }
}

@Riverpod(dependencies: [firestoreReferences])
ProjectsRepository projectsRepository(ProjectsRepositoryRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectsRepository(references: references);
}

@Riverpod(dependencies: [firestoreReferences])
ProjectsReset projectsReset(ProjectsResetRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectsReset(references: references);
}

@Riverpod(dependencies: [projectsRepository, ProjectModelsOrder])
Stream<List<ProjectModel>> projectModelsStream(ProjectModelsStreamRef ref) {
  final order = ref.watch(projectModelsOrderProvider);
  return ref.watch(projectsRepositoryProvider).all(order);
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

@Riverpod(dependencies: [projectsRepository])
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
        final reference = await ref.read(projectsRepositoryProvider).add(state);
        cb(reference);
      } finally {
        state = state.copyWith(isBusy: false);
      }
    };
  }
}

//

@Riverpod(dependencies: [])
List<ProjectModel> projectModels(ProjectModelsRef ref) => throw OverrideProviderException();
