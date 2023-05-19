import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/node.dart';
import '../../../providers/project/nodes.dart';
import '../../../providers/project/project.dart';
import '../../../providers/project/workspace/editor.dart';
import '../../../providers/project/workspace/items.dart';
import '../../../providers/project/workspace/workspace.dart';
import '../../base/scope_overrides/scope_overrides.dart';

class WorkspaceScreen extends ConsumerWidget {
  const WorkspaceScreen({
    super.key,
    required this.projectId,
    required this.workspaceId,
  });

  final String projectId;
  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScopeOverrides(
      overrides: (context, ref) => [
        overrideProvider(projectIdProvider).withValue(projectId),
        overrideProvider(workspaceIdProvider).withValue(workspaceId),
      ],
      child: ScopeOverrides(
        overrides: (context, ref) => [
          overrideProvider(projectModelProvider).withListenable(projectModelStreamProvider),
          overrideProvider(projectStateModelProvider).withListenable(projectStateModelStreamProvider),
          overrideProvider(workspaceModelProvider).withListenable(workspaceModelStreamProvider),
          overrideProvider(workspaceStateModelProvider).withListenable(workspaceStateModelStreamProvider),
          overrideProvider(nodeModelsProvider).withListenable(nodeModelsStreamProvider),
          overrideProvider(workspaceItemModelsProvider).withListenable(workspaceItemModelsStreamProvider),
        ],
        child: const WorkspaceScreenContent(),
      ),
    );
  }
}

class WorkspaceScreenContent extends ConsumerWidget {
  const WorkspaceScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspacePixel = ref.watch(workspaceStateModelProvider.select((value) => value.pixel));

    VoidCallback setWorkspacePixel(int value) {
      return () => ref.read(workspaceStateModelProvider).updatePixel(value);
    }

    final item = ref.watch(selectedWorkspaceItemModelProvider);
    final node = ref.watch(selectedNodeModelProvider);

    VoidCallback setItemPixel(int value) {
      return () => item!.updatePixel(value);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: WorkspaceEditor()),
        Container(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Workspace: $workspacePixel'),
                const Gap(10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Button(
                      child: const Text('1'),
                      onPressed: setWorkspacePixel(1),
                    ),
                    Button(
                      child: const Text('2'),
                      onPressed: setWorkspacePixel(2),
                    ),
                    Button(
                      child: const Text('4'),
                      onPressed: setWorkspacePixel(4),
                    ),
                  ],
                ),
                if (item != null) ...[
                  const Gap(20),
                  Text('Item: $item'),
                  const Gap(10),
                  Text('Node: $node'),
                  const Gap(10),
                  Text('Pixel: ${item.pixel}'),
                  const Gap(10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Button(
                        child: const Text('1'),
                        onPressed: setItemPixel(1),
                      ),
                      Button(
                        child: const Text('2'),
                        onPressed: setItemPixel(2),
                      ),
                      Button(
                        child: const Text('4'),
                        onPressed: setItemPixel(4),
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }
}

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
        color: Colors.white,
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

class WorkspaceItemContainer extends ConsumerWidget {
  const WorkspaceItemContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSelect() {
      final id = ref.read(workspaceItemModelProvider.select((value) => value.doc.id));
      ref.read(workspaceStateModelProvider).updateItem(id);
    }

    final isSelected = ref.watch(isWorkspaceItemModelSelectedProvider);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.red : Colors.transparent),
      ),
      child: GestureDetector(
        onTap: onSelect,
        child: child,
      ),
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
