part of 'editor.dart';

class _WorkspaceItemContainer extends StatelessObserverWidget {
  const _WorkspaceItemContainer({required this.child});

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
      child: _DraggableWorkspaceItem(
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
