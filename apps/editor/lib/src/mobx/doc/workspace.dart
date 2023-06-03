part of '../mobx.dart';

class WorkspaceDoc = _WorkspaceDoc with _$WorkspaceDoc;

@StoreConfig(hasToString: false)
abstract class _WorkspaceDoc with Store, Mountable implements DocumentModel {
  _WorkspaceDoc(this.doc);

  @override
  final Document doc;

  String get id => doc.id;

  String get name => doc['name'] as String;

  @override
  String toString() {
    return 'WorkspaceDoc{id: ${doc.id} data: ${doc.data}';
  }
}
