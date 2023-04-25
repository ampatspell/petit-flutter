part of 'area.dart';

class _AreaNodeEditorDraggable extends HookWidget {
  final Node node;
  final Widget child;
  final void Function(Node node) onDragEnd;

  const _AreaNodeEditorDraggable({
    required this.node,
    required this.child,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable(
      childWhenDragging: Container(),
      feedback: Material(
        child: child,
      ),
      child: child,
      onDragEnd: (details) {
        node.frame.updateOffset(details.offset);
        onDragEnd(node);
      },
    );
  }
}
