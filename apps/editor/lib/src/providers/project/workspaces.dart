import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/project_workspace.dart';
import '../base.dart';
import '../generic.dart';
import 'project.dart';

part 'workspaces.g.dart';

@Riverpod(dependencies: [projectReference, workspaceModelsStreamByProjectReference])
Stream<List<ProjectWorkspaceModel>> workspaceModelsStream(WorkspaceModelsStreamRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  return ref.watch(workspaceModelsStreamByProjectReferenceProvider(
    projectRef: projectRef,
  ));
}

//

@Riverpod(dependencies: [])
List<ProjectWorkspaceModel> workspaceModels(WorkspaceModelsRef ref) => throw OverrideProviderException();
