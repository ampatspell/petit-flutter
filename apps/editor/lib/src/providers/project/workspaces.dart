import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/project_workspace.dart';
import '../base.dart';
import 'project.dart';

part 'workspaces.g.dart';

@Riverpod(dependencies: [projectId, firestoreStreams])
Stream<List<ProjectWorkspaceModel>> workspaceModelsStream(WorkspaceModelsStreamRef ref) {
  final projectId = ref.watch(projectIdProvider);
  return ref.watch(firestoreStreamsProvider).workspacesByProjectId(projectId);
}

//

@Riverpod(dependencies: [])
List<ProjectWorkspaceModel> workspaceModels(WorkspaceModelsRef ref) => throw OverrideProviderException();
