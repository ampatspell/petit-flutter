import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petit_editor/src/providers/new_project.dart';
import 'package:petit_editor/src/routes/router.dart';
import 'package:petit_editor/src/theme.dart';
import 'package:petit_editor/src/typedefs.dart';

class NewProjectForm extends ConsumerWidget {
  const NewProjectForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FIXME: content is NewProjectData which I'm not accessing. watching just to keep it alive
    ref.watch(newProjectProvider);

    void didCreate(MapDocumentReference reference) {
      if (context.mounted) {
        ProjectsRoute().go(context);
      }
    }

    return SizedBox(
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextBox(
            placeholder: 'Project name',
            onChanged: (value) => ref.read(newProjectProvider.notifier).setName(value),
          ),
          AppGaps.gap10,
          FilledButton(
            onPressed: ref.read(newProjectProvider.notifier).createCallback(didCreate),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
