part of '../models.dart';

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
    name: 'Workspace._items',
    query: () => project.reference.collection('workspaces').doc(id).collection('items'),
    create: (doc) => WorkspaceItem(itemDoc: WorkspaceItemDoc(doc), workspace: this),
  );

  @override
  bool get isLoaded => project.isLoaded && __doc.isLoaded && _items.isLoaded;

  @override
  bool get isMissing => project.isMissing || __doc.isMissing;

  WorkspaceDoc get _doc => __doc.content!;

  int get pixel => _doc.pixel;

  String get name => _doc.name;

  List<WorkspaceItem> get items => _items.content;

  //

  late final WorkspaceSelection selection = WorkspaceSelection(this);

  late final PropertyGroups properties = PropertyGroups([
    PropertyGroup(
      name: 'Pixel',
      properties: [
        Property<int, String>.documentModel(
          model: () => _doc,
          key: 'pixel',
          initial: 1,
          validator: intIsPositiveValidator,
          presentation: integerTextBoxPresentation,
        )
      ],
    ),
  ]);

  //

  @override
  String toString() {
    return 'Workspace{id: $id, name: $name, pixel: $pixel}';
  }
}

class WorkspaceSelection = _WorkspaceSelection with _$WorkspaceSelection;

abstract class _WorkspaceSelection with Store {
  _WorkspaceSelection(this._workspace);

  final _Workspace _workspace;

  @observable
  String? itemId;

  @computed
  WorkspaceItem? get item {
    final id = itemId;
    if (id == null) {
      return null;
    }
    return _workspace.items.firstWhereOrNull((element) => element.id == id);
  }

  @action
  void select(WorkspaceItem? item) {
    itemId = item?.id;
  }

  @action
  void clear() {
    select(null);
  }
}
