import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';
import 'typedefs.dart';

part 'projects.freezed.dart';

@freezed
class ProjectsReset with _$ProjectsReset {
  const factory ProjectsReset({
    required FirestoreReferences references,
    required String uid,
  }) = _ProjectsReset;

  const ProjectsReset._();

  Future<void> reset() async {
    await _deleteProjects();
    await _createProjects();
  }

  Future<void> _createProjects() async {
    await _createProject(
      name: 'Minka',
      nodes: [
        {
          'id': 'box-1',
          'type': 'box',
          'width': 30,
          'height': 30,
          'color': Colors.red.withAlpha(50).value,
        },
        {
          'id': 'box-2',
          'type': 'box',
          'width': 30,
          'height': 30,
          'color': Colors.black.withAlpha(50).value,
        },
      ],
      items: [
        {
          'id': '1',
          'node': 'box-1',
          'x': 5,
          'y': 5,
        },
        {
          'id': '2',
          'node': 'box-2',
          'x': 40,
          'y': 5,
        }
      ],
    );
    await _createProject(name: 'Petit', nodes: [], items: []);
  }

  Future<void> _createProject({
    required String name,
    required List<Map<String, dynamic>> nodes,
    required List<Map<String, dynamic>> items,
  }) async {
    final projectRef = references.projects().doc();
    final projectStateRef = references.projectStatesByRef(projectRef).doc(uid);
    final nodesRef = references.projectNodesByRef(projectRef);
    final workspacesRef = references.projectWorkspacesByRef(projectRef);
    final workspaceRef = workspacesRef.doc();
    final workspaceItemsRef = references.projectWorkspaceItemsCollection(workspaceRef);

    Future<void> createProject() async {
      await projectRef.set({
        'name': name,
      });
    }

    Future<void> createProjectState() async {
      await projectStateRef.set({});
    }

    Future<void> createNode(Map<String, dynamic> map) async {
      final nodeRef = nodesRef.doc(map['id'] as String);
      map.remove('id');
      await nodeRef.set(map);
    }

    Future<void> createNodes() async {
      await Future.wait(nodes.map(createNode));
    }

    Future<void> createItem(Map<String, dynamic> map) async {
      final itemRef = workspaceItemsRef.doc(map['id'] as String);
      map.remove('id');
      await itemRef.set(map);
    }

    Future<void> createItems() async {
      await Future.wait(items.map(createItem));
    }

    Future<void> createWorkspace() async {
      await workspaceRef.set({
        'name': 'default',
      });
    }

    await Future.wait([
      createProject(),
      createProjectState(),
      createWorkspace(),
      createNodes(),
      createItems(),
    ]);
  }

  Future<void> _deleteProjects() async {
    final projects = await references.projects().get();
    await Future.wait(projects.docs.map((projectSnap) async {
      final projectRef = projectSnap.reference;

      Future<void> deleteNodes() async {
        final nodesRef = references.projectNodesByRef(projectRef);
        final nodes = await nodesRef.get();
        await Future.wait(nodes.docs.map((e) => e.reference.delete()));
      }

      Future<void> deleteWorkspace(MapDocumentReference workspaceRef) async {
        final itemsRef = references.projectWorkspaceItemsCollection(workspaceRef);
        final items = await itemsRef.get();
        await Future.wait([
          ...items.docs.map((e) => e.reference.delete()),
          workspaceRef.delete(),
        ]);
      }

      Future<void> deleteWorkspaces() async {
        final workspacesRef = references.projectWorkspacesByRef(projectRef);
        final workspaces = await workspacesRef.get();
        await Future.wait(workspaces.docs.map((e) => deleteWorkspace(e.reference)));
      }

      await Future.wait([
        deleteNodes(),
        deleteWorkspaces(),
        projectRef.delete(),
      ]);
    }));
  }
}

@freezed
class NewProjectModel with _$NewProjectModel {
  const factory NewProjectModel({
    @Default(false) bool isBusy,
    @Default('') String name,
  }) = _NewProjectModel;

  const NewProjectModel._();

  bool get isValid => name.isNotEmpty;
}
