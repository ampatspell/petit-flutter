part of 'editor.dart';

class _BoxWorkspaceItem extends StatelessObserverWidget {
  const _BoxWorkspaceItem();

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
