import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../widgets/base/order.dart';
import 'project.dart';
import 'references.dart';
import 'typedefs.dart';

part 'projects.freezed.dart';

@freezed
class ProjectsRepository with _$ProjectsRepository {
  const factory ProjectsRepository({
    required FirestoreReferences references,
  }) = _ProjectsRepository;

  const ProjectsRepository._();

  MapCollectionReference get collection => references.projects();

  ProjectModel _asModel(MapDocumentSnapshot snapshot) {
    return ProjectModel(
      doc: references.asDoc(snapshot),
    );
  }

  List<ProjectModel> _asModels(QuerySnapshot<FirestoreMap> event) {
    return event.docs.map(_asModel).toList(growable: false);
  }

  Stream<List<ProjectModel>> all(OrderDirection order) {
    return collection
        .orderBy('name', descending: order.isDescending)
        .snapshots(includeMetadataChanges: true)
        .map(_asModels);
  }

  Stream<ProjectModel> byReference(MapDocumentReference projectRef) {
    return projectRef.snapshots(includeMetadataChanges: true).map(_asModel);
  }

  Future<MapDocumentReference> add(NewProjectData data) async {
    final ref = collection.doc();
    await ref.set({
      'name': data.name,
    });
    return ref;
  }

  MapDocumentReference referenceById(String id) {
    return collection.doc(id);
  }
}

@freezed
class ProjectsReset with _$ProjectsReset {
  const factory ProjectsReset({
    required FirestoreReferences references,
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
}

@freezed
class NewProjectData with _$NewProjectData {
  const factory NewProjectData({
    @Default(false) bool isBusy,
    @Default('') String name,
  }) = _NewProjectData;

  const NewProjectData._();

  bool get isValid => name.isNotEmpty;
}
