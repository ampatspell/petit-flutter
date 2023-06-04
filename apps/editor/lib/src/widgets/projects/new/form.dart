import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';

class NewProjectForm extends StatelessWidget {
  const NewProjectForm({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXME: content is NewProjectModel which I'm not accessing. watching just to keep it alive
    // ref.watch(newProjectProvider);

    // void didCreate(MapDocumentReference reference) {
    //   if (context.mounted) {
    //     ProjectRoute(projectId: reference.id).go(context);
    //   }
    // }

    return SizedBox(
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextBox(
            placeholder: 'Project name',
            // onChanged: (value) => ref.read(newProjectProvider.notifier).setName(value),
          ),
          const Gap(10),
          FilledButton(
            onPressed: () {},
            // onPressed: ref.read(newProjectProvider.notifier).createCallback(didCreate),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
