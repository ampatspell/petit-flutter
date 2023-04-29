import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petit_editor/src/routes/development.dart';
import 'package:petit_editor/src/routes/router.dart';
import 'package:petit_editor/src/stores/app.dart';
import 'package:petit_zug/petit_zug.dart';

import '../../get_it.dart';
import '../../stores/firestore/project.dart';

class ModelsListView<T extends FirestoreEntity> extends StatelessWidget {
  final FirestoreModels<T> models;
  final ListTile Function(BuildContext context, T model) itemBuilder;

  const ModelsListView({
    super.key,
    required this.models,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (models.isLoading) {
        return const SizedBox.shrink();
      } else {
        if (models.content.isEmpty) {
          return const Center(
            child: Text('No entities'),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) => Observer(builder: (context) {
              final model = models.content[index];
              return itemBuilder(context, model);
            }),
            itemCount: models.content.length,
          );
        }
      }
    });
  }
}

class ProjectsList extends HookWidget {
  final void Function(DocumentReference<ProjectData> ref) onSelect;

  const ProjectsList({
    super.key,
    required this.onSelect,
  });

  FirebaseFirestore get firestore => it.get();

  @override
  Widget build(BuildContext context) {
    final models = useModels(
      query: firestore.collection('projects').orderBy('name'),
      model: (reference) => Project(reference),
    );
    return ModelsListView(
      models: models,
      itemBuilder: (context, model) => ListTile.selectable(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('${model.name}'),
        ),
        onSelectionChange: (_) {
          ProjectRoute(projectId: model.reference.id).go(context);
        },
      ),
    );
  }
}
