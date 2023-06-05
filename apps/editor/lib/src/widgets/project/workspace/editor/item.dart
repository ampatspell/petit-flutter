part of 'editor.dart';

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
        child = const _BoxWorkspaceItem();
    }

    return Positioned(
      top: position.dy,
      left: position.dx,
      child: _WorkspaceItemContainer(
        child: ProxyProvider0(
          update: (context, value) => node,
          child: child,
        ),
      ),
    );
  }
}
