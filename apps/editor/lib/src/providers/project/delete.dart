import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../base.dart';
import 'project.dart';

part 'delete.g.dart';

@Riverpod(dependencies: [projectId, firestoreReferences])
Future<void> projectDelete(ProjectDeleteRef ref) {
  final projectId = ref.watch(projectIdProvider);
  final reference = ref.watch(firestoreReferencesProvider).projectById(projectId);
  return reference.delete();
}
