import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:mobx/mobx.dart';
import 'package:petit_zug/petit_zug.dart';

import '../get_it.dart';

part 'development.g.dart';

DateTime? timestampToDateTime(dynamic value) {
  if (value is FieldValue) {
    return DateTime.now();
  }
  if (value is Timestamp) {
    return value.toDate();
  }
  return null;
}

class Project extends _Project with _$Project {
  Project(super.reference);

  @computed
  String? get name => data['name'];

  @computed
  int? get index => data['index'];

  @computed
  DateTime? get createdAt => timestampToDateTime(data['createdAt']);

  @action
  void incIndex() {
    var index = this.index ?? 0;
    index++;
    data['index'] = index;
    data['createdAt'] = FieldValue.serverTimestamp();
  }

  @override
  String toString() {
    return 'Project{path: ${reference.path}, data: $data}';
  }
}

abstract class _Project extends FirestoreEntity with Store {
  _Project(super.reference);
}

class DevelopmentScreen extends HookWidget {
  const DevelopmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var collection = it.get<FirebaseFirestore>().collection('projects');
    var reference = collection.orderBy('index');
    final models = useSubscribable(FirestoreModels<Project>(
      reference: reference,
      model: (reference) {
        return Project(reference);
      },
      canUpdate: null,
    ));

    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Development'),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildListView(context, models),
          buildModelsContent(context, models),
          buildAddNew(context, collection),
        ],
      ),
    );
  }

  Widget buildModelsContent(BuildContext context, FirestoreModels<Project> snapshot) {
    return Observer(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: snapshot.content.map((e) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  FilledButton(
                    child: const Text('+'),
                    onPressed: () {
                      e.incIndex();
                      e.save();
                    },
                  ),
                  const Gap(10),
                  FilledButton(
                    child: const Text('-'),
                    onPressed: () {
                      e.delete();
                    },
                  ),
                  const Gap(10),
                  Text('${e.name} ${e.index} ${e.createdAt}'),
                  const Gap(10),
                  Text(e.isSaving ? 'Saving' : 'Idle'),
                ],
              ),
            );
          }).toList(growable: false),
        );
      },
    );
  }

  buildAddNew(BuildContext context, CollectionReference<Map<String, dynamic>> reference) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton(
          child: const Text('Add new'),
          onPressed: () {
            Project(reference.doc())
              ..set({
                'name': 'New',
                'index': 0,
                'createdAt': FieldValue.serverTimestamp(),
              })
              ..save();
          },
        ),
      ],
    );
  }

  Widget buildListView(BuildContext context, FirestoreModels<Project> models) {
    return Observer(
      builder: (context) {
        print('list');
        return SizedBox(
          width: 300,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Observer(builder: (context) {
                print('item $index');
                final model = models.content[index];
                return ListTile.selectable(
                  title: Text('${model.name} ${model.index}'),
                  onSelectionChange: (selected) {},
                );
              });
            },
            itemCount: models.content.length,
          ),
        );
      },
    );
  }
}
