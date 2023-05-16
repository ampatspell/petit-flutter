import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/project.dart';
import '../../models/projects.dart';
import '../../widgets/base/order.dart';
import '../base.dart';
import '../generic.dart';
import '../references.dart';

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
ProjectsReset projectsReset(ProjectsResetRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectsReset(references: references);
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

@Riverpod(dependencies: [ProjectModelsOrder, projectModelsStreamByOrder])
Stream<List<ProjectModel>> projectModelsStream(ProjectModelsStreamRef ref) {
  final order = ref.watch(projectModelsOrderProvider);
  return ref.watch(projectModelsStreamByOrderProvider(orderDirection: order));
}

//

@Riverpod(dependencies: [])
List<ProjectModel> projectModels(ProjectModelsRef ref) => throw OverrideProviderException();
