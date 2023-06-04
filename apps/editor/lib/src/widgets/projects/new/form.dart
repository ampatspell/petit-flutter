import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:zug/zug.dart';

import '../../../app/router.dart';

part 'form.g.dart';

class NewProjectFormState = _NewProjectFormState with _$NewProjectFormState;

abstract class _NewProjectFormState with Store {
  @observable
  String name = '';

  @observable
  bool isBusy = false;

  @computed
  bool get isValid => name.trim().isNotEmpty;

  @computed
  bool get isSaveEnabled => isValid && !isBusy;

  FirebaseFirestore get _firestore => it.get();

  @action
  Future<void> save(ValueChanged<String> onSaved) async {
    isBusy = true;
    try {
      final ref = _firestore.collection('projects').doc();
      await ref.set({'name': name});
      onSaved(ref.id);
    } finally {
      isBusy = false;
    }
  }
}

class NewProjectForm extends StatelessWidget {
  const NewProjectForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => NewProjectFormState(),
      child: Observer(builder: (context) {
        final state = context.watch<NewProjectFormState>();

        void onSaved(String id) {
          if (context.mounted) {
            ProjectRoute(projectId: id).go(context);
          }
        }

        return SizedBox(
          width: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBox(
                placeholder: 'Project name',
                onChanged: (value) => state.name = value,
              ),
              const Gap(10),
              FilledButton(
                onPressed: state.isSaveEnabled ? () => state.save(onSaved) : null,
                child: const Text('Create'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
