import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/project.dart';
import '../base.dart';

part 'project.g.dart';

@Riverpod(dependencies: [])
String projectId(ProjectIdRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [projectId, firestoreStreams])
Stream<ProjectModel> projectModelStream(ProjectModelStreamRef ref) {
  final projectId = ref.watch(projectIdProvider);
  return ref.watch(firestoreStreamsProvider).projectById(projectId: projectId);
}

@Riverpod(dependencies: [projectId, firestoreStreams])
Stream<ProjectStateModel> projectStateModelStream(ProjectStateModelStreamRef ref) {
  final projectId = ref.watch(projectIdProvider);
  return ref.watch(firestoreStreamsProvider).projectStateById(projectId: projectId);
}

//

@Riverpod(dependencies: [projectModelStream])
ProjectModel projectModel(ProjectModelRef ref) {
  return ref.watch(projectModelStreamProvider.select((value) => value.requireValue));
}

@Riverpod(dependencies: [projectStateModelStream])
ProjectStateModel projectStateModel(ProjectStateModelRef ref) {
  return ref.watch(projectStateModelStreamProvider.select((value) => value.requireValue));
}
