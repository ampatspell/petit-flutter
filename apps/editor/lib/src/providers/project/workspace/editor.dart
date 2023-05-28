import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/node.dart';
import '../../../models/workspace.dart';
import '../../base.dart';
import '../nodes.dart';
import 'items.dart';
import 'workspace.dart';

part 'editor.g.dart';

@Riverpod(dependencies: [])
WorkspaceItemModel workspaceItemModel(WorkspaceItemModelRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
NodeModel nodeModel(NodeModelRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [workspaceStateModel, workspaceItemModels])
WorkspaceItemModel? selectedWorkspaceItemModel(SelectedWorkspaceItemModelRef ref) {
  final id = ref.watch(workspaceStateModelProvider.select((value) => value.item));
  return ref.watch(workspaceItemModelsProvider.select((value) {
    return value.firstWhereOrNull((element) => element.doc.id == id);
  }));
}

@Riverpod(dependencies: [selectedWorkspaceItemModel, workspaceItemModel])
bool isWorkspaceItemModelSelected(IsWorkspaceItemModelSelectedRef ref) {
  final selected = ref.watch(selectedWorkspaceItemModelProvider.select((value) => value?.doc.id));
  final id = ref.watch(workspaceItemModelProvider.select((value) => value.doc.id));
  return id == selected;
}

@Riverpod(dependencies: [selectedWorkspaceItemModel, nodeModels])
NodeModel? selectedNodeModel(SelectedNodeModelRef ref) {
  final id = ref.watch(selectedWorkspaceItemModelProvider.select((value) => value?.node));
  if (id == null) {
    return null;
  }
  return ref.watch(nodeModelsProvider.select((value) {
    return value.firstWhereOrNull((element) => element.doc.id == id);
  }));
}
