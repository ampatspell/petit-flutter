import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/doc.dart';
import '../../../models/workspace.dart';
import '../../../widgets/base/fields/fields.dart';
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

@Riverpod(dependencies: [workspaceModelStream])
WorkspaceModel workspaceModel(WorkspaceModelRef ref) {
  return ref.watch(workspaceModelStreamProvider.select((value) => value.requireValue));
}

@Riverpod(dependencies: [workspaceStateModelStream])
WorkspaceStateModel workspaceStateModel(WorkspaceStateModelRef ref) {
  return ref.watch(workspaceStateModelStreamProvider.select((value) => value.requireValue));
}

//

@Riverpod(dependencies: [])
FieldGroup workspaceFieldGroup(WorkspaceFieldGroupRef ref) {
  return const FieldGroup();
}

@Riverpod(dependencies: [workspaceFieldGroup, workspaceStateModel])
Field<int, PixelOptions> workspacePixelField(WorkspacePixelFieldRef ref) {
  return Field(
    group: ref.watch(workspaceFieldGroupProvider),
    property: ref.watch(workspaceStateModelProvider.select((value) => value.pixelProperty)),
  );
}
