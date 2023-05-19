import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/projects.dart';
import '../../models/typedefs.dart';
import '../references.dart';

part 'new.g.dart';

@Riverpod(dependencies: [firestoreReferences])
class NewProject extends _$NewProject {
  @override
  NewProjectModel build() {
    return const NewProjectModel();
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
        final reference = ref.read(firestoreReferencesProvider).projectsCollection().doc();
        await reference.set({
          'name': state.name,
        });
        cb(reference);
      } finally {
        state = state.copyWith(isBusy: false);
      }
    };
  }
}
