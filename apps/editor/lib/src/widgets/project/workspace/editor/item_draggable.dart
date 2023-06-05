part of 'editor.dart';

class _DraggableWorkspaceItemState = __DraggableWorkspaceItemState with _$_DraggableWorkspaceItemState;

abstract class __DraggableWorkspaceItemState with Store {
  __DraggableWorkspaceItemState(this.workspace, this.item);

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

  void updatePosition() {
    final scaled = offset! / workspace.pixel.toDouble();
    final absolute = this.absolute! + scaled;
    item.updatePosition(absolute);
  }

  @action
  void onDragUpdate(Offset delta) {
    final value = offset!;
    offset = value + delta;
    updatePosition();
  }

  @action
  void onDragEnd() {
    item.save();
  }
}

class _DraggableWorkspaceItem extends StatelessWidget {
  const _DraggableWorkspaceItem({
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
      create: (context) => _DraggableWorkspaceItemState(workspace, workspaceItem),
      child: Builder(
        builder: (context) {
          final state = context.watch<_DraggableWorkspaceItemState>();

          final resizable = _ResizableWorkspaceItem(
            child: child,
          );

          return Draggable(
            feedback: const SizedBox.shrink(),
            childWhenDragging: resizable,
            child: resizable,
            onDragStarted: () {
              state.onDragStart();
              onDragStart();
            },
            onDragUpdate: (details) => state.onDragUpdate(details.delta),
            onDragEnd: (details) => state.onDragEnd(),
          );
        },
      ),
    );
  }
}
