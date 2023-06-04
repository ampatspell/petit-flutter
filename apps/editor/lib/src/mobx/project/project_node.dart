part of '../mobx.dart';

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
}

class BoxProjectNode = _BoxProjectNode with _$_BoxProjectNode<BoxProjectNodeDoc> implements ProjectNode;

abstract class _BoxProjectNode extends _ProjectNode<BoxProjectNodeDoc> with SizedProjectNode {
  _BoxProjectNode(BoxProjectNodeDoc doc) : super(doc, ProjectNodeType.box);

  @override
  int get width => doc['width'] as int;

  @override
  int get height => doc['height'] as int;

  Color get color => Color(doc['color'] as int);

  late final PropertyGroups properties = PropertyGroups([
    PropertyGroup(name: 'Size', properties: [
      Property<int, String>.documentModel(
        this,
        key: 'width',
        initial: 1,
        validator: intIsPositiveValidator,
        presentation: integerTextBoxPresentation,
      ),
      Property<int, String>.documentModel(
        this,
        key: 'height',
        initial: 1,
        validator: intIsPositiveValidator,
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
