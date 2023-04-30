import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petit_editor/src/routes/development.dart';
import 'package:petit_editor/src/routes/router.dart';
import 'package:petit_zug/petit_zug.dart';

import '../../get_it.dart';
import '../../stores/firestore/project.dart';

enum OrderDirection {
  asc(FluentIcons.sort_up),
  desc(FluentIcons.sort_down);

  final IconData icon;

  const OrderDirection(this.icon);

  OrderDirection get next {
    if (this == asc) {
      return desc;
    }
    return asc;
  }

  bool get isDescending {
    return this == desc;
  }
}

class ModelsListView<T extends FirestoreEntity> extends StatelessWidget {
  final FirestoreModels<T> models;
  final ListTile Function(BuildContext context, T model) itemBuilder;
  final Widget placeholder;

  const ModelsListView({
    super.key,
    required this.models,
    required this.itemBuilder,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final content = models.content;
      final length = content.length;
      if (models.isLoading) {
        return const SizedBox.shrink();
      } else {
        if (length == 0) {
          return Center(
            child: placeholder,
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) => Observer(builder: (context) {
              final model = content[index];
              return itemBuilder(context, model);
            }),
            itemCount: length,
          );
        }
      }
    });
  }
}

class ProjectsList extends HookWidget {
  final void Function(DocumentReference<ProjectData> ref) onSelect;
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
