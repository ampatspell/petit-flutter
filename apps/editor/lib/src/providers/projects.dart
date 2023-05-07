import 'package:riverpod_annotation/riverpod_annotation.dart';

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

@Riverpod(dependencies: [projectsRepository])
Stream<List<Project>> allProjects(AllProjectsRef ref) {
  return ref.watch(projectsRepositoryProvider).allProjects();
}
