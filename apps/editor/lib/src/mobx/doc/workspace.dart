part of '../mobx.dart';

class WorkspaceDoc = _WorkspaceDoc with _$WorkspaceDoc;

@StoreConfig(hasToString: false)
abstract class _WorkspaceDoc with Store, Mountable implements DocumentModel {
  _WorkspaceDoc({
    required this.doc,
  });

  @override
  Iterable<Mountable> get mountable => [];

  @override
  final Document doc;

  String get id => doc.id;

  String get name => doc['name'] as String;

  @override
  String toString() {
    return 'WorkspaceDoc{path: ${doc.path} data: ${doc.data}';
  }
}
