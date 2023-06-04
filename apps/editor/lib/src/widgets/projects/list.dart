import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../app/router.dart';
import '../../mobx/mobx.dart';
import '../base/models_list_view.dart';

class ProjectsList extends StatelessWidget {
  const ProjectsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print('$this');
    return ModelsListView<Projects, ProjectDoc>(
      models: (model) => model.docs,
      placeholder: const Text('No projects created yet'),
      item: Observer(builder: (context) {
        print('$this item');
        final doc = context.watch<ProjectDoc>();
        return ListTile.selectable(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(doc.name),
          ),
          onPressed: () {
            ProjectRoute(projectId: doc.id).go(context);
          },
        );
      }),
    );
  }
}
