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

  Rect? screen;

  @action
  void onDragStart(Alignment alignment) {
    dragging = alignment;
    final position = item.renderedPosition;
    final size = this.size!;
    screen = Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
  }

  @action
  void onDragUpdate(Alignment handle, DragUpdateDetails details) {
    final delta = details.delta;
    final screen = this.screen!;

    var left = screen.left;
    var top = screen.top;
    var right = screen.right;
    var bottom = screen.bottom;

    if (handle.containsTop) {
      top = top + delta.dy;
    }
    if (handle.containsBottom) {
      bottom = bottom + delta.dy;
    }
    if (handle.containsLeft) {
      left = left + delta.dx;
    }
    if (handle.containsRight) {
      right = right + delta.dx;
    }

    this.screen = Rect.fromLTRB(left, top, right, bottom);

    final itemPixel = item.pixel.toDouble();
    final workspacePixel = item.workspace.pixel.toDouble();

    double r(double value, double px) => (value / px).ceilToDouble();

    final rect = Rect.fromLTWH(
      r(screen.left, workspacePixel),
      r(screen.top, workspacePixel),
      r(screen.width, itemPixel * workspacePixel),
      r(screen.height, itemPixel * workspacePixel),
    );

    item.updatePosition(Offset(rect.left, rect.top));
    sizedNode!.updateSize(Size(rect.width, rect.height));
  }

  @action
  void onDragEnd(Alignment alignment, DraggableDetails details) {
    dragging = null;
    item.save();
    sizedNode!.save();
  }
}

class _ResizableWorkspaceItem extends StatelessWidget {
  const _ResizableWorkspaceItem({
    required this.child,
  });

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
            child: ResizableHandles(
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

//
// abstract class WithRenderedSize extends Widget {
//   const WithRenderedSize({super.key});
//
//   Size get renderedSize;
// }
//
// class ResizeState {
//   final Rect initial;
//   Rect previous;
//
//   ResizeState._(this.initial, this.previous);
//
//   factory ResizeState.create(Rect entity, double pixel) {
//     final scaled = Rect.fromLTWH(
//       entity.left * pixel,
//       entity.top * pixel,
//       entity.width * pixel,
//       entity.height * pixel,
//     );
//     return ResizeState._(scaled, scaled);
//   }
// }
//

class ResizableHandles extends StatelessWidget {
  const ResizableHandles({
    super.key,
    required this.child,
  });

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
      return ResizableHandle(alignment: alignment);
    });
  }
}

class ResizableHandle extends StatelessObserverWidget {
  const ResizableHandle({
    super.key,
    required this.alignment,
  });

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<_ResizableState>();
    final content = buildContent(context);

    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Draggable(
          feedback: Container(),
          childWhenDragging: content,
          child: content,
          onDragStarted: () => state.onDragStart(alignment),
          onDragUpdate: (e) => state.onDragUpdate(alignment, e),
          onDragEnd: (e) => state.onDragEnd(alignment, e),
        ),
      ),
    );
  }

  MouseRegion buildContent(BuildContext context) {
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
