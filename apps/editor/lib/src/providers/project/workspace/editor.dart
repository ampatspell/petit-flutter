import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/node.dart';
import '../../../models/properties.dart';
import '../../../models/workspace.dart';
import '../../../widgets/base/fields/fields.dart';
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

//

@Riverpod(dependencies: [])
PropertyGroup selectedWorkspaceItemPropertyGroup(SelectedWorkspaceItemPropertyGroupRef ref) {
  return const PropertyGroup();
}

@Riverpod()
WorkspaceItemModelProperties selectedWorkspaceItemModelProperties(SelectedWorkspaceItemModelPropertiesRef ref) {
  final provider = selectedWorkspaceItemModelProvider;

  return WorkspaceItemModelProperties(
    group: ref.watch(selectedWorkspaceItemPropertyGroupProvider),
    x: Property.withRef(
      ref: ref,
      provider: provider,
      value: (model) => model!.x,
      update: (model, value) => model!.updateX(value),
    ),
    y: Property.withRef(
      ref: ref,
      provider: provider,
      value: (model) => model!.y,
      update: (model, value) => model!.updateY(value),
    ),
    pixel: Property.withRef(
      ref: ref,
      provider: provider,
      value: (model) => model!.pixel,
      update: (model, value) => model!.updatePixel(value),
    ),
  );
}
