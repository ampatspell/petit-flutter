import 'package:cloud_firestore/cloud_firestore.dart';
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
  return ref.watch(projectsRepositoryProvider).allProjects(order);
}
