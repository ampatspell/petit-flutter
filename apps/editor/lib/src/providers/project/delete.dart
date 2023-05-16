import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../generic.dart';
import 'project.dart';

part 'delete.g.dart';

@Riverpod(dependencies: [projectReference, projectsRepository])
Future<void> projectDelete(ProjectDeleteRef ref) {
  final reference = ref.watch(projectReferenceProvider);
  final repository = ref.watch(projectsRepositoryProvider);
  return repository.delete(reference);
}
