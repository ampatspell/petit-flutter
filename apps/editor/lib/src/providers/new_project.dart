import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project.dart';
import '../typedefs.dart';
import 'firebase.dart';
import 'projects.dart';
import 'references.dart';

part 'new_project.g.dart';

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
