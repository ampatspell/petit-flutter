import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/project.dart';
import '../../providers/projects/projects.dart';
import '../base/models_list_view.dart';

class ProjectsList extends ConsumerWidget {
  const ProjectsList({
    super.key,
    required this.onSelect,
  });

  final void Function(ProjectModel project) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectModelsProvider);
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
  }
}
