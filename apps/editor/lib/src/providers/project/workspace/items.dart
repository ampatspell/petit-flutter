import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/project_workspace.dart';
import '../../base.dart';
import '../project.dart';
import 'workspace.dart';

part 'items.g.dart';

@Riverpod(dependencies: [projectId, workspaceId, firestoreStreams])
Stream<List<ProjectWorkspaceItemModel>> workspaceItemModelsStream(WorkspaceItemModelsStreamRef ref) {
  final projectId = ref.watch(projectIdProvider);
  final workspaceId = ref.watch(workspaceIdProvider);
  return ref.watch(firestoreStreamsProvider).workspaceItemsById(projectId: projectId, workspaceId: workspaceId);
}

//

@Riverpod()
List<ProjectWorkspaceItemModel> workspaceItemModels(WorkspaceItemModelsRef ref) => throw OverrideProviderException();
