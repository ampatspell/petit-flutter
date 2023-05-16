import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/typedefs.dart';
import '../../base.dart';
import '../../generic.dart';
import '../project.dart';

part 'workspace.g.dart';

@Riverpod(dependencies: [])
String workspaceId(WorkspaceIdRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [projectReference, workspaceId, workspacesRepositoryByProjectRef])
MapDocumentReference workspaceReference(WorkspaceReferenceRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  final workspaceId = ref.watch(workspaceIdProvider);
  return ref.watch(workspacesRepositoryByProjectRefProvider(projectRef: projectRef)).reference(workspaceId);
}
