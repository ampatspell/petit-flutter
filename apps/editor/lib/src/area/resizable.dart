part of 'area.dart';

class _AreaNodeEditorResizable extends HookWidget {
  final Widget child;
  final Node node;
  final double handleSize;

  const _AreaNodeEditorResizable({
    required this.handleSize,
    required this.child,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final size = node.frame.size;
        final h = handleSize / 2;
        return SizedBox(
          width: size.width + handleSize,
          height: size.height + handleSize,
          child: Stack(
            children: [
              Positioned(
                top: h,
                left: h,
                width: size.width,
                height: size.height,
                child: child,
              ),
              buildHandle('top', 'left'),
              buildHandle('top', 'middle'),
              buildHandle('top', 'right'),
              buildHandle('middle', 'left'),
              buildHandle('middle', 'right'),
              buildHandle('bottom', 'left'),
              buildHandle('bottom', 'middle'),
              buildHandle('bottom', 'right'),
            ],
          ),
        );
      },
    );
  }

  Widget buildHandle(String vertical, String horizontal) {
    final size = node.frame.size;
    final h = handleSize / 2;
    late final double top;
    late final double left;

    if (vertical == 'top') {
      top = 0;
    } else if (vertical == 'middle') {
      top = size.height / 2 - h;
    } else if (vertical == 'bottom') {
      top = size.height;
    }

    if (horizontal == 'left') {
      left = 0;
    } else if (horizontal == 'middle') {
      left = size.width / 2 - h;
    } else if (horizontal == 'right') {
      left = size.width;
    }

    return buildHandleContent(vertical, horizontal, top, left);
  }

  Widget buildHandleContent(String vertical, String horizontal, double top, double left) {
    return Positioned(
      top: top.floorToDouble(),
      left: left.floorToDouble(),
      child: _AreaNodeEditorResizeDraggable(
        node: node,
        vertical: vertical,
        horizontal: horizontal,
        child: _AreaNodeEditorResizeHandle(
          size: handleSize,
        ),
      ),
    );
  }
}

class _AreaNodeEditorResizeDraggable extends HookWidget {
  final Node node;
  final Widget child;
  final String vertical;
  final String horizontal;

  const _AreaNodeEditorResizeDraggable({
    required this.node,
    required this.child,
    required this.vertical,
    required this.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final size = useState<Size?>(null);
    final offset = useState<Offset?>(null);
    return Draggable(
      feedback: Container(),
      childWhenDragging: child,
      child: child,
      onDragStarted: () {
        size.value = node.frame.size;
        offset.value = node.frame.offset;
      },
      onDragUpdate: (details) => onDragUpdate(size, offset, details),
    );
  }

  void onDragUpdate(
    ValueNotifier<Size?> sizeNotifier,
    ValueNotifier<Offset?> offsetNotifier,
    DragUpdateDetails details,
  ) {
    final delta = details.delta;
    var size = sizeNotifier.value!;
    var offset = offsetNotifier.value!;

    late final double width;
    late final double height;
    late final double dx;
    late final double dy;

    if (vertical == 'bottom') {
      if (horizontal == 'middle') {
        width = size.width;
        height = size.height + delta.dy;
        dx = offset.dx;
        dy = offset.dy;
      } else if (horizontal == 'left') {
        width = size.width - delta.dx;
        height = size.height + delta.dy;
        dx = offset.dx + delta.dx;
        dy = offset.dy;
      } else if (horizontal == 'right') {
        width = size.width + delta.dx;
        height = size.height + delta.dy;
        dx = offset.dx;
        dy = offset.dy;
      }
    } else if (vertical == 'top') {
      if (horizontal == 'middle') {
        width = size.width;
        height = size.height - delta.dy;
        dx = offset.dx;
        dy = offset.dy + delta.dy;
      } else if (horizontal == 'left') {
        width = size.width - delta.dx;
        height = size.height - delta.dy;
        dx = offset.dx + delta.dx;
        dy = offset.dy + delta.dy;
      } else if (horizontal == 'right') {
        width = size.width + delta.dx;
        height = size.height - delta.dy;
        dx = offset.dx;
        dy = offset.dy + delta.dy;
      }
    } else if (vertical == 'middle') {
      if (horizontal == 'left') {
        width = size.width - delta.dx;
        height = size.height;
        dx = offset.dx + delta.dx;
        dy = offset.dy;
      } else if (horizontal == 'right') {
        width = size.width + delta.dx;
        height = size.height;
        dx = offset.dx;
        dy = offset.dy;
      }
    }

    size = Size(width, height);
    sizeNotifier.value = size;

    offset = Offset(dx, dy);
    offsetNotifier.value = offset;

    node.frame.updateSizeAndOffset(
      Size(size.width.floorToDouble(), size.height.floorToDouble()),
      Offset(offset.dx.floorToDouble(), offset.dy.floorToDouble()),
    );
  }
}

class _AreaNodeEditorResizeHandle extends HookWidget {
  final double size;

  const _AreaNodeEditorResizeHandle({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final hover = useState(false);
    return MouseRegion(
      onEnter: (event) {
        hover.value = true;
      },
      onExit: (event) {
        hover.value = false;
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          border: Border.all(
            color: hover.value ? Colors.black.withAlpha(100) : Colors.black.withAlpha(50),
          ),
        ),
      ),
    );
  }
}
