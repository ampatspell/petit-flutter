import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/workspace.dart';
import '../base.dart';
import 'project.dart';

part 'workspaces.g.dart';

@Riverpod(dependencies: [projectId, firestoreStreams])
Stream<List<WorkspaceModel>> workspaceModelsStream(WorkspaceModelsStreamRef ref) {
  final projectId = ref.watch(projectIdProvider);
  return ref.watch(firestoreStreamsProvider).workspacesById(projectId);
}

@Riverpod(dependencies: [workspaceModelsStream])
List<WorkspaceModel> workspaceModels(WorkspaceModelsRef ref) {
  return ref.watch(workspaceModelsStreamProvider.select((value) => value.requireValue));
}
