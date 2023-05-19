import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/project.dart';
import '../../widgets/base/order.dart';
import '../base.dart';
import '../references.dart';

part 'projects.g.dart';

@Riverpod(dependencies: [])
class ProjectModelsOrder extends _$ProjectModelsOrder {
  @override
  OrderDirection build() {
    return OrderDirection.asc;
  }

  void toggle() {
    state = state.next;
  }
}

@Riverpod(dependencies: [ProjectModelsOrder, firestoreStreams])
Stream<List<ProjectModel>> projectModelsStream(ProjectModelsStreamRef ref) {
  final order = ref.watch(projectModelsOrderProvider);
  return ref.watch(firestoreStreamsProvider).projects(order: order);
}

//

@Riverpod(dependencies: [])
List<ProjectModel> projectModels(ProjectModelsRef ref) => throw OverrideProviderException();
