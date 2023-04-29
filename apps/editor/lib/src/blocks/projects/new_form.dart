import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petit_editor/src/routes/router.dart';
import 'package:petit_editor/src/stores/projects.dart';
import 'package:petit_editor/src/theme.dart';

class NewProjectForm extends HookWidget {
  const NewProjectForm({super.key});

  @override
  Widget build(BuildContext context) {
    final store = useState(NewProjectStore());
    return Observer(
      builder: (context) {
        void commit() async {
          final ref = await store.value.commit();
          if (context.mounted && ref != null) {
            ProjectRoute(projectId: ref.id).go(context);
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextBox(
              placeholder: 'Project name',
              onChanged: (value) => store.value.name = value,
            ),
            AppGaps.gap10,
            FilledButton(
              onPressed: store.value.canCommit ? () => commit() : null,
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
