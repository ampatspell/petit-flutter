import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project.dart';
import '../typedefs.dart';
import 'app.dart';
import 'references.dart';

part 'projects.g.dart';

@Riverpod(dependencies: [firestoreReferences])
class AllProjectsQuery extends _$AllProjectsQuery {
  @override
  Raw<Stream<MapQuerySnapshot>> build() {
    return ref.watch(firestoreReferencesProvider).sortedProjects.snapshots(includeMetadataChanges: true);
  }
}

@Riverpod(dependencies: [AllProjectsQuery])
class AllProjects extends _$AllProjects {
  @override
  Stream<List<Project>> build() async* {
    final stream = ref.watch(allProjectsQueryProvider);
    await for (var event in stream) {
      yield event.docs.map((e) {
        return Project(reference: e.reference, data: e.data());
      }).toList(growable: false);
    }
  }
}
