part of '../mobx.dart';

abstract class ProjectNodeDoc implements DocumentModel {}

class BoxProjectNodeDoc = _BoxProjectNodeDoc with _$BoxProjectNodeDoc implements ProjectNodeDoc;

abstract class _BoxProjectNodeDoc extends _ProjectNodeDoc {
  _BoxProjectNodeDoc(super.doc);
}

@StoreConfig(hasToString: false)
abstract class _ProjectNodeDoc with Store, Mountable implements DocumentModel {
  _ProjectNodeDoc(this.doc);

  @override
  final Document doc;

  @override
  String toString() {
    return '$runtimeType{id: ${doc.id}, data: ${doc.data}';
  }
}
