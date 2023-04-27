import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:macos_ui/macos_ui.dart';
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
          await store.value.commit();
          if (context.mounted) {
            ProjectsRoute().go(context);
          }
        }

        return Padding(
          padding: AppEdgeInsets.all10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MacosTextField(
                placeholder: 'Project name',
                onChanged: (value) => store.value.name = value,
              ),
              AppGaps.gap10,
              PushButton(
                buttonSize: ButtonSize.large,
                onPressed: store.value.canCommit ? () => commit() : null,
                child: const Text("Create"),
              ),
            ],
          ),
        );
      },
    );
  }
}
