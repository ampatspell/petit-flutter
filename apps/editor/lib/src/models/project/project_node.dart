part of '../models.dart';

abstract class ProjectNode implements DocumentModel {
  ProjectNodeType get type;

  String get id;

  PropertyGroups get properties;
}

mixin SizedProjectNode {
  int get width;

  int get height;

  Size get size {
    return Size(width.toDouble(), height.toDouble());
  }

  Size renderedSize(int itemPixel, int workspacePixel) {
    return size * itemPixel.toDouble() * workspacePixel.toDouble();
  }

  Size renderedSizeForItem(WorkspaceItem item) {
    return renderedSize(item.pixel, item.workspace.pixel);
  }

  Future<void> updateSize(Size size);

  Future<void> save();
}

class BoxProjectNode = _BoxProjectNode with _$_BoxProjectNode<BoxProjectNodeDoc> implements ProjectNode;

abstract class _BoxProjectNode extends _ProjectNode<BoxProjectNodeDoc> with SizedProjectNode {
  _BoxProjectNode(BoxProjectNodeDoc doc) : super(doc, ProjectNodeType.box);

  @override
  int get width => doc['width'] as int;

  @override
  int get height => doc['height'] as int;

  Color get color => Color(doc['color'] as int);

  @override
  Future<void> updateSize(Size size) async {
    doc['width'] = size.width.toInt();
    doc['height'] = size.height.toInt();
  }

  @override
  Future<void> save() async {
    await doc.save();
  }

  late final PropertyGroups properties = PropertyGroups([
    PropertyGroup(name: 'Size', properties: [
      Property<int, String>.documentModel(
        model: () => this,
        key: 'width',
        initial: 1,
        validator: intIsInRangeValidator(1, null),
        presentation: integerTextBoxPresentation,
      ),
      Property<int, String>.documentModel(
        model: () => this,
        key: 'height',
        initial: 1,
        validator: intIsInRangeValidator(1, null),
        presentation: integerTextBoxPresentation,
      )
    ]),
  ]);

  @override
  String toString() {
    return 'BoxProjectNode{id: $id, width: $width, height: $height, color: $color}';
  }
}

abstract class _ProjectNode<D extends ProjectNodeDoc> with Store, Mountable implements DocumentModel {
  _ProjectNode(this.nodeDoc, this.type);

  final ProjectNodeType type;
  final D nodeDoc;

  @override
  Document get doc => nodeDoc.doc;

  String get id => doc.id;

  @override
  String toString() {
    return 'ProjectNode{id: $id, type: $type}';
  }
}
