import 'package:fluent_ui/fluent_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../blocks/riverpod/order.dart';
import '../models/project.dart';
import '../repositories/projects.dart';
import 'app.dart';
import 'references.dart';

part 'projects.g.dart';

@Riverpod(dependencies: [firestoreReferences])
ProjectsRepository projectsRepository(ProjectsRepositoryRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  return ProjectsRepository(references: references);
}

@Riverpod(dependencies: [])
class SortedProjectsOrder extends _$SortedProjectsOrder {
  @override
  OrderDirection build() {
    state = OrderDirection.asc;
    return state;
  }

  void toggle() {
    state = state.next;
  }
}

@Riverpod(dependencies: [projectsRepository, SortedProjectsOrder])
Stream<List<Project>> sortedProjects(SortedProjectsRef ref) {
  final order = ref.watch(sortedProjectsOrderProvider);
  return ref.watch(projectsRepositoryProvider).all(order);
}

@Riverpod(dependencies: [projectsRepository])
class ResetProjects extends _$ResetProjects {
  @override
  VoidCallback? build() {
    return reset;
  }

  void reset() async {
    state = null;
    try {
      await ref.read(projectsRepositoryProvider).reset();
    } finally {
      state = reset;
    }
  }
}
