import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/workspace.dart';
import '../../base.dart';
import '../project.dart';

part 'workspace.g.dart';

@Riverpod(dependencies: [])
String workspaceId(WorkspaceIdRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [projectId, workspaceId, firestoreStreams])
Stream<WorkspaceModel> workspaceModelStream(WorkspaceModelStreamRef ref) {
  final projectId = ref.watch(projectIdProvider);
  final workspaceId = ref.watch(workspaceIdProvider);
  return ref.watch(firestoreStreamsProvider).workspaceById(projectId: projectId, workspaceId: workspaceId);
}

@Riverpod(dependencies: [projectId, workspaceId, firestoreStreams])
Stream<WorkspaceStateModel> workspaceStateModelStream(WorkspaceStateModelStreamRef ref) {
  final projectId = ref.watch(projectIdProvider);
  final workspaceId = ref.watch(workspaceIdProvider);
  return ref.watch(firestoreStreamsProvider).workspaceStateById(projectId: projectId, workspaceId: workspaceId);
}

//

@Riverpod(dependencies: [])
WorkspaceModel workspaceModel(WorkspaceModelRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
WorkspaceStateModel workspaceStateModel(WorkspaceStateModelRef ref) => throw OverrideProviderException();
