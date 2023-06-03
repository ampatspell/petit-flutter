part of '../mobx.dart';

class ProjectDoc extends _ProjectDoc with _$ProjectDoc {
  ProjectDoc({required super.doc});

  String get id => doc.id;

  String get name => doc['name'] as String? ?? 'Untitled';

  @override
  String toString() {
    return 'ProjectDoc{id: $id, data: ${doc.data}}';
  }
}

@StoreConfig(hasToString: false)
abstract class _ProjectDoc with Store, Mountable implements DocumentModel {
  _ProjectDoc({
    required this.doc,
  });

  @override
  final Document doc;

  @override
  Iterable<Mountable> get mountable => [];
}
