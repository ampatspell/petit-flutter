part of '../mobx.dart';

class Workspace = _Workspace with _$Workspace;

abstract class _Workspace with Store, Mountable implements Loadable {
  _Workspace({
    required this.project,
    required this.id,
  });

  final Project project;
  final String id;

  @override
  Iterable<Mountable> get mountable => [project, __doc, _items];

  late final ModelReference<WorkspaceDoc> __doc = ModelReference(
    name: 'Workspace.__doc',
    reference: () => project.reference.collection('workspaces').doc(id),
    create: WorkspaceDoc.new,
  );

  late final ModelsQuery<WorkspaceItem> _items = ModelsQuery(
    name: 'Workspace.__items',
    query: () => project.reference.collection('workspaces').doc(id).collection('items'),
    create: (doc) => WorkspaceItem(WorkspaceItemDoc(doc)),
  );

  @override
  bool get isLoaded => project.isLoaded && __doc.isLoaded || _items.isLoaded;

  @override
  bool get isMissing => project.isMissing || __doc.isMissing;

  WorkspaceDoc get _doc => __doc.content!;

  int get pixel => _doc.pixel;

  String get name => _doc.name;

  List<WorkspaceItem> get items => _items.content;

  @override
  String toString() {
    return 'Workspace{id: $id, name: $name, pixel: $pixel}';
  }
}
