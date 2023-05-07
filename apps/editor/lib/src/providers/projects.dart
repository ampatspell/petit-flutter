import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/project.dart';
import '../typedefs.dart';
import 'app.dart';
import 'references.dart';

part 'projects.g.dart';

@Riverpod(dependencies: [firestoreReferences])
Raw<Stream<MapQuerySnapshot>> allProjectsQuery(AllProjectsQueryRef ref) {
  return ref
      .watch(firestoreReferencesProvider)
      .sortedProjects
      .snapshots(includeMetadataChanges: true);
}

@Riverpod(dependencies: [allProjectsQuery])
Stream<List<Project>> allProjects(AllProjectsRef ref) async* {
  final stream = ref.watch(allProjectsQueryProvider);
  await for (var event in stream) {
    yield event.docs
        .map((e) => Project(reference: e.reference, data: e.data()))
        .toList(growable: false);
  }
}
