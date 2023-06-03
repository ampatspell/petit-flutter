part of '../mobx.dart';

class Projects = _Projects with _$Projects;

@StoreConfig(hasToString: false)
abstract class _Projects with Store, Mountable implements Loadable {
  @override
  Iterable<Mountable> get mountable => [_docs];

  @observable
  OrderDirection order = OrderDirection.asc;

  @action
  void toggleOrder() {
    order = order.next;
  }

  FirebaseFirestore get _firestore => it.get();

  late final ModelsQuery<ProjectDoc> _docs = ModelsQuery(
    name: 'projects_docs',
    query: () => _firestore.collection('projects').orderBy('name', descending: order.isDescending),
    create: (doc) => ProjectDoc(doc: doc),
  );

  List<ProjectDoc> get docs => _docs.content;

  @override
  bool get isLoaded => _docs.isLoaded;

  @override
  final bool isMissing = false;

  void reset() async {
    await ProjectsReset().reset();
  }
}
