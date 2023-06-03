part of '../mobx.dart';

class ProjectNodeDoc extends _ProjectNodeDoc with _$ProjectNodeDoc {
  ProjectNodeDoc({required super.doc});

  @override
  String toString() {
    return 'ProjectNodeDoc{doc: ${doc.id}, data: ${doc.data}}';
  }
}

@StoreConfig(hasToString: false)
abstract class _ProjectNodeDoc with Store, Mountable implements DocumentModel {
  _ProjectNodeDoc({
    required this.doc,
  });

  @override
  Iterable<Mountable> get mountable => [];

  @override
  final Document doc;
}
