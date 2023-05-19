import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/project_workspace.dart';
import '../../../models/project_workspaces.dart';
import '../../base.dart';
import '../../references.dart';
import '../project.dart';

part 'workspace.g.dart';

@Riverpod(dependencies: [])
String workspaceId(WorkspaceIdRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [projectId, workspaceId, firestoreStreams])
Stream<ProjectWorkspaceModel> workspaceModelStream(WorkspaceModelStreamRef ref) {
  final projectId = ref.watch(projectIdProvider);
  final workspaceId = ref.watch(workspaceIdProvider);
  return ref.watch(firestoreStreamsProvider).workspaceById(projectId: projectId, workspaceId: workspaceId);
}

@Riverpod(dependencies: [projectId, workspaceId, firestoreStreams])
Stream<ProjectWorkspaceStateModel> workspaceStateModelStream(WorkspaceStateModelStreamRef ref) {
  final projectId = ref.watch(projectIdProvider);
  final workspaceId = ref.watch(workspaceIdProvider);
  return ref.watch(firestoreStreamsProvider).workspaceStateById(projectId: projectId, workspaceId: workspaceId);
}

//

@Riverpod(dependencies: [])
ProjectWorkspaceModel workspaceModel(WorkspaceModelRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
ProjectWorkspaceStateModel workspaceStateModel(WorkspaceStateModelRef ref) => throw OverrideProviderException();
