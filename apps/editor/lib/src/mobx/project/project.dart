part of '../mobx.dart';

class Project = _Project with _$Project;

abstract class _Project with Store, Mountable implements Loadable {
  _Project({
    required this.id,
  });

  @override
  Iterable<Mountable> get mountable => [__doc];

  final String id;

  FirestoreReferences get _references => it.get();

  MapDocumentReference get reference => _references.projectById(id);

  late final ModelReference<ProjectDoc> __doc = ModelReference(
    reference: () => reference,
    create: (doc) => ProjectDoc(doc: doc),
  );

  @override
  bool get isLoaded => __doc.isLoaded;

  @override
  bool get isMissing => __doc.isMissing;

  //

  ProjectDoc get _doc => __doc.content!;

  String get name => _doc.name;

  @action
  Future<void> delete() async {
    await _doc.doc.delete();
  }

  //

  @override
  String toString() {
    return 'Project{id: $id, data: ${__doc.content?.doc.data}}';
  }
}
