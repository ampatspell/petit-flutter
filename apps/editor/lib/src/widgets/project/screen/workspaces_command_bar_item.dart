import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../app/utils.dart';
import '../../../models/project_workspace.dart';
import '../../base/combo_box_command_bar_item.dart';

class WorkspacesCommandBarItem extends CommandBarItem {
  WorkspacesCommandBarItem({
    super.key,
    required this.workspaces,
    required this.selected,
    required this.onSelect,
  });

  final List<ProjectWorkspaceModel> workspaces;
  final ProjectWorkspaceModel? selected;
  final void Function(ProjectWorkspaceModel? doc) onSelect;

  @override
  Widget build(BuildContext context, CommandBarItemDisplayMode displayMode) {
    return ComboBoxCommandBarItem(
      items: workspaces.map((workspace) {
        return ComboBoxItem(
          value: workspace.doc.id,
          child: Text(workspace.name),
        );
      }).toList(growable: false),
      value: selected?.doc.id,
      onChanged: (workspaces.length > 1 && selected != null).ifTrue((value) {
        final workspace = workspaces.firstWhereOrNull((element) => element.doc.id == value);
        onSelect(workspace);
      }),
      placeholder: const Text('Workspace not selected'),
    ).build(context, displayMode);
  }
}
