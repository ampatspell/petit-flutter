part of '../mobx.dart';

class Project = _Project with _$Project;

@StoreConfig(hasToString: false)
abstract class _Project with Store, Mountable implements Loadable {
  _Project({
    required this.id,
  });

  @override
  Iterable<Mountable> get mountable => [__doc, _nodes];

  final String id;

  FirebaseFirestore get _firestore => it.get();

  MapDocumentReference get reference => _firestore.collection('projects').doc(id);

  late final ModelReference<ProjectDoc> __doc = ModelReference(
    name: 'Project.__doc',
    reference: () => reference,
    create: ProjectDoc.new,
  );

  late final ModelsQuery<ProjectNode> _nodes = ModelsQuery(
    name: 'Project._nodes',
    query: () => reference.collection('nodes'),
    create: (doc) => ProjectNode(ProjectNodeDoc(doc)),
  );

  @override
  bool get isLoaded => __doc.isLoaded && _nodes.isLoaded;

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

  List<ProjectNode> get nodes => _nodes.content;

  //

  @override
  String toString() {
    return 'Project{id: $id, doc: ${__doc.content}}';
  }
}
