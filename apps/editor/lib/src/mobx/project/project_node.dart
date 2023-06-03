part of '../mobx.dart';

class ProjectNode = _ProjectNode with _$ProjectNode;

@StoreConfig(hasToString: false)
abstract class _ProjectNode with Store, Mountable implements DocumentModel {
  _ProjectNode(this.nodeDoc);

  final ProjectNodeDoc nodeDoc;

  @override
  Document get doc => nodeDoc.doc;

  @override
  String toString() {
    return 'ProjectNode{nodeDoc: $nodeDoc}';
  }
}
