import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/workspace.dart';
import '../../base.dart';
import '../project.dart';
import 'workspace.dart';

part 'items.g.dart';

@Riverpod(dependencies: [projectId, workspaceId, firestoreStreams])
Stream<List<WorkspaceItemModel>> workspaceItemModelsStream(WorkspaceItemModelsStreamRef ref) {
  final projectId = ref.watch(projectIdProvider);
  final workspaceId = ref.watch(workspaceIdProvider);
  return ref.watch(firestoreStreamsProvider).workspaceItemsById(projectId: projectId, workspaceId: workspaceId);
}

//

@Riverpod(dependencies: [])
List<WorkspaceItemModel> workspaceItemModels(WorkspaceItemModelsRef ref) => throw OverrideProviderException();
