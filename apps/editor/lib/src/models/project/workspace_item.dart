part of '../models.dart';

class WorkspaceItem = _WorkspaceItem with _$WorkspaceItem;

abstract class _WorkspaceItem with Store, Mountable implements DocumentModel {
  _WorkspaceItem({required this.itemDoc, required this.workspace});

  final _Workspace workspace;
  final WorkspaceItemDoc itemDoc;

  @override
  Document get doc => itemDoc.doc;

  String get id => doc.id;

  int get x => itemDoc.x;

  int get y => itemDoc.y;

  int get pixel => itemDoc.pixel;

  String get nodeId => itemDoc.node;

  Offset get position => Offset(x.toDouble(), y.toDouble());

  @computed
  Offset get renderedPosition {
    return position * workspace.pixel.toDouble();
  }

  @action
  void updatePosition(Offset position) {
    itemDoc.x = position.dx.toInt();
    itemDoc.y = position.dy.toInt();
  }

  @action
  Future<void> save() async {
    await itemDoc.doc.save();
  }

  @computed
  ProjectNode? get node {
    return workspace.project.nodes.firstWhereOrNull((node) => node.id == nodeId);
  }

  late final PropertyGroups properties = PropertyGroups([
    PropertyGroup(
      name: 'Position',
      properties: [
        Property<int, String>.documentModel(
          model: () => this,
          key: 'x',
          initial: 1,
          validator: noopValidator,
          presentation: integerTextBoxPresentation,
        ),
        Property<int, String>.documentModel(
          model: () => this,
          key: 'y',
          initial: 1,
          validator: noopValidator,
          presentation: integerTextBoxPresentation,
        )
      ],
    ),
    PropertyGroup(
      name: 'Pixel',
      properties: [
        Property<int, String>.documentModel(
          model: () => this,
          key: 'pixel',
          initial: 1,
          validator: intIsInRangeValidator(1, 16),
          presentation: integerTextBoxPresentation,
        )
      ],
    ),
  ]);

  @override
  String toString() {
    return 'WorkspaceItem{id: $id, x: $x, y: $y, pixel: $pixel, node: $node}';
  }
}
