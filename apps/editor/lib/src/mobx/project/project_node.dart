part of '../mobx.dart';

abstract class ProjectNode implements DocumentModel {}

class BoxProjectNode = _BoxProjectNode with _$_BoxProjectNode<BoxProjectNodeDoc> implements ProjectNode;

abstract class _BoxProjectNode extends _ProjectNode<BoxProjectNodeDoc> {
  _BoxProjectNode(super.nodeDoc);
}

@StoreConfig(hasToString: false)
abstract class _ProjectNode<D extends ProjectNodeDoc> with Store, Mountable implements DocumentModel {
  _ProjectNode(this.nodeDoc);

  final D nodeDoc;

  @override
  Document get doc => nodeDoc.doc;

  @override
  String toString() {
    return '$runtimeType{nodeDoc: $nodeDoc}';
  }
}
