part of '../mobx.dart';

abstract class ProjectNode implements DocumentModel {}

mixin SizedProjectNode {
  int get width;

  int get height;

  Size get size {
    return Size(width.toDouble(), height.toDouble());
  }

  Size renderedSize(int itemPixel, int workspacePixel) {
    return size * itemPixel.toDouble() * workspacePixel.toDouble();
  }

// void updateWidth(int value);
//
// void updateHeight(int value);
}

class BoxProjectNode = _BoxProjectNode with _$_BoxProjectNode<BoxProjectNodeDoc> implements ProjectNode;

abstract class _BoxProjectNode extends _ProjectNode<BoxProjectNodeDoc> with SizedProjectNode {
  _BoxProjectNode(super.nodeDoc);

  @override
  int get width => doc['width'] as int;

  @override
  int get height => doc['height'] as int;

  Color get color => Color(doc['color'] as int);

  @override
  String toString() {
    return 'BoxProjectNode{id: $id, width: $width, height: $height, color: $color}';
  }
}

@StoreConfig(hasToString: false)
abstract class _ProjectNode<D extends ProjectNodeDoc> with Store, Mountable implements DocumentModel {
  _ProjectNode(this.nodeDoc);

  final D nodeDoc;

  @override
  Document get doc => nodeDoc.doc;

  String get id => doc.id;

  String get type => doc['type'] as String;

  @override
  String toString() {
    return 'ProjectNode{id: $id, type: $type}';
  }
}
