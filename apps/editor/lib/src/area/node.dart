part of 'area.dart';

class _AreaNodeEditor extends HookWidget {
  final EditorArea _area;
  final Node _node;
  final double resizeHandleSize = 10.0;

  const _AreaNodeEditor({
    required Node node,
    required EditorArea area,
  })  : _node = node,
        _area = area;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final h = resizeHandleSize / 2;
        return Positioned(
          top: _node.frame.offset.dy - h,
          left: _node.frame.offset.dx - h,
          child: _AreaNodeEditorDraggable(
            node: _node,
            onDragEnd: (node) => _area.didMoveNode(node),
            child: _AreaNodeEditorResizable(
              handleSize: resizeHandleSize,
              node: _node,
              child: buildChild(),
            ),
          ),
        );
      },
    );
  }

  Widget buildChild() {
    final node = _node;
    if (node is ContainerNode) {
      return _AreaNodeEditorContainer(node: node, area: _area);
    }
    throw UnsupportedError('$_node');
  }
}
