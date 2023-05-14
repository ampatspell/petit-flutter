import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:petit_editor/src/app/utils.dart';

import '../../../models/project_workspace.dart';
import '../../base/fluent/combo_box_command_bar_item.dart';

class WorkspacesCommandBarItem extends CommandBarItem {
  final List<ProjectWorkspaceDoc> workspaces;
  final ProjectWorkspaceDoc? selected;
  final void Function(ProjectWorkspaceDoc? doc) onSelect;

  WorkspacesCommandBarItem({
    super.key,
    required this.workspaces,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, CommandBarItemDisplayMode displayMode) {
    return ComboBoxCommandBarItem(
      items: workspaces.map((workspace) {
        return ComboBoxItem(
          value: workspace.reference.id,
          child: Text(workspace.name),
        );
      }).toList(growable: false),
      value: selected?.reference.id,
      onChanged: (workspaces.length > 1 && selected != null).ifTrue((value) {
        final workspace = workspaces.firstWhereOrNull((element) => element.reference.id == value);
        onSelect(workspace);
      }),
      placeholder: const Text('Workspace not selected'),
    ).build(context, displayMode);
  }
}
