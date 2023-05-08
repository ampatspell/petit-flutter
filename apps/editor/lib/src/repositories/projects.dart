import 'package:fluent_ui/fluent_ui.dart';
import 'package:petit_editor/src/blocks/riverpod/order.dart';

import '../models/project.dart';
import '../typedefs.dart';
import 'references.dart';

class ProjectsRepository {
  final FirestoreReferences references;

  const ProjectsRepository({
    required this.references,
  });

  MapCollectionReference get projectsReference => references.projects();

  Stream<List<Project>> allProjects(OrderDirection order) {
    return projectsReference
        .orderBy('name', descending: order.isDescending)
        .snapshots(includeMetadataChanges: false)
        .map((event) {
      return event.docs.map((e) {
        return Project(
          reference: e.reference,
          data: e.data(),
        );
      }).toList(growable: false);
    });
  }

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
  }

  Future<void> _createProject({
    required String name,
    required List<Map<String, dynamic>> nodes,
    required List<Map<String, dynamic>> items,
  }) async {
    final projectRef = projectsReference.doc();
    final nodesRef = references.projectNodesCollection(projectRef);
    final workspacesRef = references.projectWorkspacesCollection(projectRef);
    final workspaceRef = workspacesRef.doc();
    final workspaceItemsRef = references.projectWorkspaceItemsCollection(workspaceRef);

    Future<void> createProject() async {
      await projectRef.set({
        'name': name,
      });
    }

    Future<void> createNode(Map<String, dynamic> map) async {
      final nodeRef = nodesRef.doc(map['id']);
      map.remove('id');
      await nodeRef.set(map);
    }

    Future<void> createNodes() async {
      await Future.wait(nodes.map((e) => createNode(e)));
    }

    Future<void> createItem(Map<String, dynamic> map) async {
      final itemRef = workspaceItemsRef.doc(map['id']);
      map.remove('id');
      await itemRef.set(map);
    }

    Future<void> createItems() async {
      await Future.wait(items.map((e) => createItem(e)));
    }

    Future<void> createWorkspace() async {
      await workspaceRef.set({
        'name': 'default',
      });
    }

    await Future.wait([
      createProject(),
      createWorkspace(),
      createNodes(),
      createItems(),
    ]);
  }

  Future<void> _deleteProjects() async {
    final projects = await projectsReference.get();
    await Future.wait(projects.docs.map((projectSnap) async {
      final projectRef = projectSnap.reference;

      Future<void> deleteNodes() async {
        final nodesRef = references.projectNodesCollection(projectRef);
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
        final workspacesRef = references.projectWorkspacesCollection(projectRef);
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

  Future<MapDocumentReference> addProject({
    required String name,
  }) async {
    final ref = projectsReference.doc();
    await ref.set({
      'name': name,
    });
    return ref;
  }
}