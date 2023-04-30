import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:petit_editor/src/routes/router.dart';
import 'package:petit_zug/petit_zug.dart';

import '../../get_it.dart';
import '../../stores/project.dart';
import '../models_list_view.dart';
import '../order.dart';

class ProjectsList extends HookWidget {
  final void Function(DocumentReference<FirestoreData> ref) onSelect;
  final OrderDirection order;

  const ProjectsList({
    super.key,
    required this.onSelect,
    required this.order,
  });

  FirebaseFirestore get firestore => it.get();

  @override
  Widget build(BuildContext context) {
    final models = useModels(
      query: firestore.collection('projects').orderBy('name', descending: order.isDescending),
      model: (reference) => Project(reference),
    );
    return ModelsListView(
      models: models,
      placeholder: const Text('No projects created yet'),
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
