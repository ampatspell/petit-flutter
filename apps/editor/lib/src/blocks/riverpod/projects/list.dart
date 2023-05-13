import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petit_editor/src/blocks/riverpod/models_list_view.dart';
import 'package:petit_editor/src/providers/projects.dart';

import '../../../models/project.dart';

class ProjectsList extends ConsumerWidget {
  final void Function(ProjectDoc project) onSelect;

  const ProjectsList({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, child) {
      final projects = ref.watch(projectDocsProvider);
      return ModelsListView(
        models: projects,
        placeholder: const Text('No projects created yet'),
        itemBuilder: (context, project) {
          return ListTile.selectable(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(project.name),
            ),
            onPressed: () => onSelect(project),
          );
        },
      );
    });
  }
}
