import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/project_node.dart';
import '../base.dart';
import 'project.dart';

part 'nodes.g.dart';

@Riverpod(dependencies: [projectId, firestoreStreams])
Stream<List<ProjectNodeModel>> projectNodeModelsStream(ProjectNodeModelsStreamRef ref) {
  final projectId = ref.watch(projectIdProvider);
  return ref.watch(firestoreStreamsProvider).nodesById(projectId: projectId);
}

//

@Riverpod(dependencies: [])
List<ProjectNodeModel> projectNodeModels(ProjectNodeModelsRef ref) => throw OverrideProviderException();
