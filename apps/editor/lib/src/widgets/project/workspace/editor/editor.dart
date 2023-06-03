import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../models/node.dart';
import '../../../../providers/project/nodes.dart';
import '../../../../providers/project/workspace/editor.dart';
import '../../../../providers/project/workspace/items.dart';
import '../../../../providers/project/workspace/workspace.dart';

class WorkspaceEditor extends ConsumerWidget {
  const WorkspaceEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onDeselectItem() {
      ref.read(workspaceStateModelProvider).updateItem(null);
    }

    final items = ref.watch(workspaceItemModelsProvider);
    return GestureDetector(
      onTap: onDeselectItem,
      child: Container(
        color: Grey.grey221,
        child: Stack(
          fit: StackFit.expand,
          children: [
            for (final item in items)
              ProviderScope(
                overrides: [
                  workspaceItemModelProvider.overrideWithValue(item),
                ],
                child: const WorkspaceItem(),
              ),
          ],
        ),
      ),
    );
  }
}

class WorkspaceItem extends ConsumerWidget {
  const WorkspaceItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspacePixel = ref.watch(workspaceStateModelProvider.select((value) => value.pixel));
    final position = ref.watch(workspaceItemModelProvider.select((value) => value.renderedPosition(workspacePixel)));
    final id = ref.watch(workspaceItemModelProvider.select((value) => value.node));
    final node = ref.watch(nodeModelsProvider.select((value) {
      return value.firstWhereOrNull((node) => node.doc.id == id);
    }));

    if (node == null) {
      return const SizedBox.shrink();
    }

    Widget child;
    if (node.type == 'box') {
      child = const BoxWorkspaceItem();
    } else {
      throw UnsupportedError(node.toString());
    }

    return Positioned(
      top: position.dy,
      left: position.dx,
      child: ProviderScope(
        overrides: [
          nodeModelProvider.overrideWithValue(node),
        ],
        child: WorkspaceItemContainer(
          child: child,
        ),
      ),
    );
  }
}

class WorkspaceItemContainer extends HookConsumerWidget {
  const WorkspaceItemContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(isWorkspaceItemModelSelectedProvider);

    final dragging = useState<Offset?>(null);
    final isDragging = dragging.value != null;

    void onSelect() {
      if (isDragging) {
        return;
      }
      final item = ref.read(workspaceItemModelProvider);
      ref.read(workspaceStateModelProvider).updateItem(item.doc.id);
    }

    // void reorder() {
    //   final item = ref.read(workspaceItemModelProvider);
    //   final items = [...ref.read(workspaceItemModelsProvider)];
    //   items.remove(item);
    //   items.insert(0, item);
    //   items.forEachIndexed((index, element) => element.updateIndex(index));
    // }

    void onDragStart() {
      onSelect();
      final position = ref.read(workspaceItemModelProvider.select((value) => value.position));
      dragging.value = position;
    }

    void updatePosition(Offset delta, bool save) {
      final workspacePixel = ref.watch(workspaceStateModelProvider.select((value) => value.pixel));
      final item = ref.read(workspaceItemModelProvider);
      final scaled = delta / workspacePixel.toDouble();
      final absolute = dragging.value! + scaled;
      item.updatePosition(absolute, save);
    }

    void onDragUpdate(Offset delta) {
      updatePosition(delta, false);
    }

    void onDragEnd(Offset delta) {
      updatePosition(delta, true);
      dragging.value = null;
    }

    return GestureDetector(
      onTap: onSelect,
      child: DraggableWorkspaceItem(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? Grey.blue : Grey.grey200),
          ),
          child: child,
        ),
        onDragStart: onDragStart,
        onDragUpdate: onDragUpdate,
        onDragEnd: onDragEnd,
      ),
    );
  }
}

class DraggableWorkspaceItem extends HookConsumerWidget {
  const DraggableWorkspaceItem({
    super.key,
    required this.child,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final Widget child;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final ValueChanged<Offset> onDragEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dragging = useState<Offset?>(null);
    return Draggable(
      feedback: ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: child,
      ),
      childWhenDragging: const SizedBox.shrink(),
      child: child,
      onDragStarted: () {
        dragging.value = Offset.zero;
        onDragStart();
      },
      onDragUpdate: (details) {
        final delta = details.delta;
        final value = dragging.value!;
        dragging.value = value + delta;
        onDragUpdate(dragging.value!);
      },
      onDragEnd: (details) {
        onDragEnd(dragging.value!);
      },
    );
  }
}

class BoxWorkspaceItem extends ConsumerWidget {
  const BoxWorkspaceItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemPixel = ref.watch(workspaceItemModelProvider.select((value) => value.pixel));
    final workspacePixel = ref.watch(workspaceStateModelProvider.select((value) => value.pixel));
    final node = ref.watch(nodeModelProvider) as BoxNodeModel;

    final size = node.renderedSize(itemPixel, workspacePixel);

    return Container(
      color: node.color,
      width: size.width,
      height: size.height,
    );
  }
}
