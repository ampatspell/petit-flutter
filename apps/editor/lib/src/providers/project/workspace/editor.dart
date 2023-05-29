import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/node.dart';
import '../../../models/properties.dart';
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

@Riverpod(dependencies: [selectedWorkspaceItemModel])
Properties? selectedWorkspaceItemModelProperties(SelectedWorkspaceItemModelPropertiesRef ref) {
  final model = ref.watch(selectedWorkspaceItemModelProvider);
  if (model == null) {
    return null;
  }
  return Properties(
    groups: [
      PropertyGroup(
        label: 'Position',
        properties: [
          Property.integerTextBox(value: model.x, update: model.updateX),
          Property.integerTextBox(value: model.y, update: model.updateY),
        ],
      ),
      PropertyGroup(
        label: 'Pixel',
        properties: [
          Property.integerTextBox(value: model.pixel, update: model.updatePixel),
        ],
      ),
    ],
  );
}

@Riverpod(dependencies: [selectedNodeModel])
Properties? selectedNodeModelProperties(SelectedNodeModelPropertiesRef ref) {
  final model = ref.watch(selectedNodeModelProvider);
  if (model == null) {
    return null;
  }

  final groups = <PropertyGroup>[];

  if (model is NodeModelWithSize) {
    final sized = model as NodeModelWithSize;
    groups.addAll([
      PropertyGroup(
        label: 'Size',
        properties: [
          Property.integerTextBox(value: sized.width, update: sized.updateWidth),
          Property.integerTextBox(value: sized.height, update: sized.updateHeight),
        ],
      )
    ]);
  }

  if (model is BoxNodeModel) {
    groups.addAll([
      PropertyGroup(
        label: 'Color',
        properties: [
          Property.colorTextBox(value: model.color, update: model.updateColor),
        ],
      ),
    ]);
  }

  return Properties(groups: groups);
}
