part of '../mobx.dart';

class ProjectDoc = _ProjectDoc with _$ProjectDoc;

@StoreConfig(hasToString: false)
abstract class _ProjectDoc with Store, Mountable implements DocumentModel {
  _ProjectDoc(this.doc);

  @override
  final Document doc;

  String get id => doc.id;

  String get name => doc['name'] as String;

  @override
  String toString() {
    return 'ProjectDoc{id: $id, data: ${doc.data}';
  }
}
