import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/utils.dart';
import '../../../../models/project_node.dart';
import '../../../../providers/project.dart';
import '../../../base/loaded_scope/loaded_scope.dart';

class ProjectWorkspaceEditor extends ConsumerWidget {
  const ProjectWorkspaceEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(projectWorkspaceItemModelsProvider);
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (final item in items)
            LoadedScope(
              loaders: (context, ref) => [
                overrideProvider(projectWorkspaceItemModelProvider).withValue(item),
              ],
              child: const ProjectWorkspaceItem(),
            ),
        ],
      ),
    );
  }
}

class ProjectWorkspaceItem extends ConsumerWidget {
  const ProjectWorkspaceItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pixel = ref.watch(projectModelProvider.select((value) => value.pixel));
    final item = ref.watch(projectWorkspaceItemModelProvider);
    final type = ref.watch(projectWorkspaceItemNodeModelProvider.select((value) => value.type));

    late Widget child;

    if (type == 'box') {
      child = const ProjectWorkspaceBoxItem();
    } else {
      throw UnsupportedError(type);
    }

    return Positioned(
      top: (item.y * pixel).toDouble(),
      left: (item.x * pixel).toDouble(),
      child: ProjectWorkspaceItemContainer(
        child: child,
      ),
    );
  }
}

class ProjectWorkspaceItemContainer extends ConsumerWidget {
  const ProjectWorkspaceItemContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedProjectNodeModelProvider.select((value) => value?.doc.id));
    final nodeId = ref.watch(projectWorkspaceItemNodeModelProvider.select((value) => value.doc.id));
    final isSelected = selectedId == nodeId;

    void onSelect() => ref.read(projectModelProvider).updateNodeId(nodeId);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.red.withAlpha(100) : Colors.transparent,
        ),
      ),
      padding: const EdgeInsets.all(1),
      child: GestureDetector(
        onTap: isSelected.ifFalse(onSelect),
        child: child,
      ),
    );
  }
}

class ProjectWorkspaceItemDraggable extends ConsumerWidget {
  const ProjectWorkspaceItemDraggable({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return child;
  }
}

class ProjectWorkspaceBoxItem extends ConsumerWidget {
  const ProjectWorkspaceBoxItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectPixel = ref.watch(projectModelProvider.select((value) => value.pixel));
    final itemPixel = ref.watch(projectWorkspaceItemModelProvider.select((value) => value.pixel));
    final node = ref.watch(projectWorkspaceItemNodeModelProvider) as ProjectBoxNodeModel;

    return Container(
      width: (node.width * itemPixel * projectPixel).toDouble(),
      height: (node.height * itemPixel * projectPixel).toDouble(),
      color: node.color,
    );
  }
}
