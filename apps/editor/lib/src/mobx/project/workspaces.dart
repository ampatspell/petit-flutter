part of '../mobx.dart';

class Workspaces = _Workspaces with _$Workspaces;

@StoreConfig(hasToString: false)
abstract class _Workspaces with Store, Mountable implements Loadable {
  _Workspaces({
    required this.project,
  });

  @override
  Iterable<Mountable> get mountable => [_docs];

  final Project project;

  late final ModelsQuery<WorkspaceDoc> _docs = ModelsQuery(
    query: () => project.reference.collection('workspaces').orderBy('name'),
    create: (doc) => WorkspaceDoc(doc: doc),
  );

  List<WorkspaceDoc> get docs => _docs.content;

  @override
  bool get isLoaded => project.isLoaded && _docs.isLoaded;

  @override
  bool get isMissing => project.isMissing;

  @override
  String toString() {
    return 'Workspaces{docs: $docs}';
  }
}
