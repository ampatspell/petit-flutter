import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/projects.dart';
import '../base.dart';

part 'reset.g.dart';

@Riverpod(dependencies: [firestoreReferences, uid])
ProjectsReset projectsReset(ProjectsResetRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  final uid = ref.watch(uidProvider);
  return ProjectsReset(
    references: references,
    uid: uid!,
  );
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