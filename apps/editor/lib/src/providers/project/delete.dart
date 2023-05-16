import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'project.dart';

part 'delete.g.dart';

@Riverpod(dependencies: [projectModel])
class ProjectModelDelete extends _$ProjectModelDelete {
  @override
  VoidCallback? build() {
    return commit;
  }

  void commit() async {
    final doc = ref.read(projectModelProvider);
    state = null;
    try {
      await doc.delete();
    } finally {
      state = commit;
    }
  }
}
