import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme.dart';
import '../../../../mobx/mobx.dart';

part 'editor.g.dart';

class WorkspaceEditor extends StatelessObserverWidget {
  const WorkspaceEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<Workspace>();
    return GestureDetector(
      onTap: () => workspace.selection.clear(),
      child: Container(
        color: Grey.grey221,
        child: Stack(
          fit: StackFit.expand,
          children: [
            for (final item in workspace.items)
              ProxyProvider0(
                update: (context, value) => item,
                child: const _WorkspaceItem(),
              ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceItem extends StatelessObserverWidget {
  const _WorkspaceItem();

  @override
  Widget build(BuildContext context) {
    final item = context.watch<WorkspaceItem>();
    final position = item.renderedPosition;
    final node = item.node;

    if (node == null) {
      return Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('Missing node ${item.nodeId}'),
        ),
      );
    }

    Widget child;
    switch (node.type) {
      case ProjectNodeType.box:
        child = const BoxWorkspaceItem();
    }

    return Positioned(
      top: position.dy,
      left: position.dx,
      child: WorkspaceItemContainer(
        child: ProxyProvider0(
          update: (context, value) => node,
          child: child,
        ),
      ),
    );
  }
}

class WorkspaceItemContainer extends StatelessObserverWidget {
  const WorkspaceItemContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final item = context.watch<WorkspaceItem>();
    final workspace = context.watch<Workspace>();
    final isSelected = workspace.selection.item == item;

    void onSelect() {
      workspace.selection.select(item);
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
        onDragStart: onSelect,
      ),
    );
  }
}

class DraggableWorkspaceItemState = _DraggableWorkspaceItemState with _$DraggableWorkspaceItemState;

abstract class _DraggableWorkspaceItemState with Store {
  _DraggableWorkspaceItemState(this.workspace, this.item);

  final Workspace workspace;
  final WorkspaceItem item;

  @observable
  Offset? offset;

  @observable
  Offset? absolute;

  @action
  void onDragStart() {
    offset = Offset.zero;
    absolute = item.position;
  }

  @action
  void onDragUpdate(Offset delta) {
    final value = offset!;
    offset = value + delta;
  }

  @action
  void onDragEnd() {
    final scaled = offset! / workspace.pixel.toDouble();
    final absolute = this.absolute! + scaled;
    item.updatePosition(absolute);
  }
}

class DraggableWorkspaceItem extends StatelessWidget {
  const DraggableWorkspaceItem({
    super.key,
    required this.child,
    required this.onDragStart,
  });

  final Widget child;
  final VoidCallback onDragStart;

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<Workspace>();
    final workspaceItem = context.watch<WorkspaceItem>();
    return Provider(
      create: (context) => DraggableWorkspaceItemState(workspace, workspaceItem),
      child: Builder(
        builder: (context) {
          final state = context.watch<DraggableWorkspaceItemState>();
          return Draggable(
            feedback: MultiProvider(
              providers: [
                ProxyProvider0(update: (context, value) => workspace),
                ProxyProvider0(update: (context, value) => workspaceItem),
              ],
              child: child,
            ),
            childWhenDragging: const SizedBox.shrink(),
            child: child,
            onDragStarted: () {
              state.onDragStart();
              onDragStart();
            },
            onDragUpdate: (details) {
              final delta = details.delta;
              state.onDragUpdate(delta);
            },
            onDragEnd: (details) {
              state.onDragEnd();
            },
          );
        },
      ),
    );
  }
}

class BoxWorkspaceItem extends StatelessObserverWidget {
  const BoxWorkspaceItem({super.key});

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<Workspace>();
    final item = context.watch<WorkspaceItem>();
    final node = context.watch<ProjectNode>() as BoxProjectNode;
    final size = node.renderedSize(item.pixel, workspace.pixel);
    return Container(
      color: node.color,
      width: size.width,
      height: size.height,
    );
  }
}
