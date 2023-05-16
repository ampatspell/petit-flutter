import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/projects.dart';
import '../references.dart';

part 'reset.g.dart';

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
