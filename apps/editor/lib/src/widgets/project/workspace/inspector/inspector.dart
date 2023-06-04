import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../../mobx/mobx.dart';
import '../../../base/line.dart';
import '../../../base/properties/properties.dart';

class WorkspaceInspector extends StatelessWidget {
  const WorkspaceInspector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
                // child: WorkspaceInspectorContent(),
                ),
          ),
          HorizontalLine(),
          _Footer(),
        ],
      ),
    );
  }
}

class _Footer extends StatelessObserverWidget {
  const _Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final properties = context.watch<Workspace>().properties;
    return Provider(
      create: (context) => properties,
      child: const PropertyGroupsForm(),
    );
  }
}

class WorkspaceInspectorContent extends StatelessWidget {
  const WorkspaceInspectorContent({super.key});

  @override
  Widget build(BuildContext context) {
    // final hasItem = ref.watch(selectedWorkspaceItemModelProvider.select((value) => value != null));
    // final hasNode = ref.watch(selectedNodeModelProvider.select((value) => value != null));

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('todo'),
      ],
    );

    // if (hasItem)
    //   PropertiesWidget(
    //     provider: selectedWorkspaceItemModelPropertiesProvider,
    //   ),
    // if (hasNode)
    //   PropertiesWidget(
    //     provider: selectedNodeModelPropertiesProvider,
    //   ),
  }
}
