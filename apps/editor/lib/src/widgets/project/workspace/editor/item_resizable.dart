part of 'editor.dart';

extension on Alignment {
  bool get containsLeft => [
        Alignment.centerLeft,
        Alignment.bottomLeft,
        Alignment.topLeft,
      ].contains(this);

  bool get containsRight => [
        Alignment.centerRight,
        Alignment.bottomRight,
        Alignment.topRight,
      ].contains(this);

  bool get containsTop => [
        Alignment.topLeft,
        Alignment.topRight,
        Alignment.topCenter,
      ].contains(this);

  bool get containsBottom => [
        Alignment.bottomRight,
        Alignment.bottomLeft,
        Alignment.bottomCenter,
      ].contains(this);
}

class _ResizableState = __ResizableState with _$_ResizableState;

abstract class __ResizableState with Store {
  __ResizableState({required this.item});

  final WorkspaceItem item;
  final handle = 10.0;

  @computed
  ProjectNode? get node => item.node;

  @computed
  SizedProjectNode? get sizedNode => node is SizedProjectNode ? node as SizedProjectNode : null;

  @computed
  Size? get size {
    final node = sizedNode;
    if (node == null) {
      return null;
    }
    return node.renderedSizeForItem(item);
  }

  @observable
  Alignment? hovering;

  @observable
  Alignment? dragging;

  bool isHovering(Alignment alignment) {
    return hovering == alignment;
  }

  bool isDragging(Alignment alignment) {
    return dragging == alignment;
  }

  @action
  void setHovering(Alignment alignment) {
    hovering = alignment;
  }

  @action
  void unsetHovering(Alignment alignment) {
    if (hovering == alignment) {
      hovering = null;
    }
  }

  Rect initial = Rect.zero;
  Offset delta = Offset.zero;

  @action
  void onDragStart(Alignment alignment) {
    dragging = alignment;
    final position = item.position;
    final size = sizedNode!.size;
    initial = Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
    delta = Offset.zero;
  }

  @action
  void onDragUpdate(Alignment handle, DragUpdateDetails details) {
    delta = delta + details.delta;

    final itemPixel = item.pixel;
    final workspacePixel = item.workspace.pixel;

    final dx = (delta.dx / itemPixel / workspacePixel).floorToDouble();
    final dy = (delta.dy / itemPixel / workspacePixel).floorToDouble();

    var left = initial.left;
    var top = initial.top;
    var width = initial.width;
    var height = initial.height;

    if (handle.containsTop) {
      top += dy * workspacePixel;
      height -= dy;
    }
    if (handle.containsLeft) {
      left += dx * workspacePixel;
      width -= dx;
    }
    if (handle.containsRight) {
      width += dx;
    }
    if (handle.containsBottom) {
      height += dy;
    }

    item.updatePosition(Offset(left, top));
    sizedNode!.updateSize(Size(width, height));
  }

  @action
  void onDragEnd(Alignment alignment, DraggableDetails details) {
    dragging = null;
    item.save();
    sizedNode!.save();
  }
}

class _ResizableWorkspaceItem extends StatelessWidget {
  const _ResizableWorkspaceItem({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final item = context.watch<WorkspaceItem>();
    return Provider(
      create: (context) => _ResizableState(item: item),
      child: Observer(builder: (context) {
        final state = context.watch<_ResizableState>();
        final size = state.size;
        final handle = state.handle;
        if (size != null) {
          return SizedBox(
            width: size.width + handle,
            height: size.height + handle,
            child: _ResizableHandles(
              child: Padding(
                padding: EdgeInsets.all(handle / 2),
                child: child,
              ),
            ),
          );
        }
        return child;
      }),
    );
  }
}

class _ResizableHandles extends StatelessWidget {
  const _ResizableHandles({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        ...buildHandles(context),
      ],
    );
  }

  Iterable<Widget> buildHandles(BuildContext context) {
    final handles = [
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.centerLeft,
      Alignment.centerRight,
      Alignment.bottomLeft,
      Alignment.bottomCenter,
      Alignment.bottomRight
    ];
    return handles.map((alignment) {
      return _ResizableHandle(alignment: alignment);
    });
  }
}

class _ResizableHandle extends StatelessWidget {
  const _ResizableHandle({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<_ResizableState>();
    final child = _ResizableHandleContent(alignment: alignment);
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Draggable(
          feedback: Container(),
          childWhenDragging: child,
          child: child,
          onDragStarted: () => state.onDragStart(alignment),
          onDragUpdate: (e) => state.onDragUpdate(alignment, e),
          onDragEnd: (e) => state.onDragEnd(alignment, e),
        ),
      ),
    );
  }
}

class _ResizableHandleContent extends StatelessObserverWidget {
  const _ResizableHandleContent({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<_ResizableState>();
    final handle = state.handle;
    final hover = state.isHovering(alignment);
    final dragging = state.isDragging(alignment);
    return MouseRegion(
      onEnter: (e) => state.setHovering(alignment),
      onExit: (e) => state.unsetHovering(alignment),
      child: Container(
        width: handle,
        height: handle,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withAlpha(30),
          ),
          color: (hover || dragging) ? Colors.black.withAlpha(60) : Colors.black.withAlpha(30),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
