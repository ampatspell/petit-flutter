import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/node.dart';
import '../base.dart';
import 'project.dart';

part 'nodes.g.dart';

@Riverpod(dependencies: [projectId, firestoreStreams])
Stream<List<NodeModel>> nodeModelsStream(NodeModelsStreamRef ref) {
  final projectId = ref.watch(projectIdProvider);
  return ref.watch(firestoreStreamsProvider).nodesById(projectId: projectId);
}

@Riverpod(dependencies: [nodeModelsStream])
List<NodeModel> nodeModels(NodeModelsRef ref) {
  return ref.watch(nodeModelsStreamProvider.select((value) => value.requireValue));
}
