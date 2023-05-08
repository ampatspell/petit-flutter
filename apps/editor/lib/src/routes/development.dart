import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:gap/gap.dart';
import 'package:petit_editor/src/routes/router.dart';

class DevelopmentScreen extends HookWidget {
  const DevelopmentScreen({super.key});

  List<Widget> _buildItems(BuildContext context) {
    Widget item({
      IconData icon = FluentIcons.code,
      required String label,
      VoidCallback? onPressed,
    }) {
      return ListTile.selectable(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(icon, size: 13),
              const Gap(10),
              Text(label),
            ],
          ),
        ),
        onPressed: onPressed,
      );
    }

    return [
      item(
        label: 'Riverpod',
        onPressed: () => DevelopmentRiverpodRoute().go(context),
      ),
      item(
        label: 'Measurable',
        onPressed: () => DevelopmentMeasurableRoute().go(context),
      ),
      // item(
      //   label: 'Activatable',
      //   onPressed: () => DevelopmentActivatableRoute().go(context),
      // ),
      // item(
      //   label: 'Sprite editor',
      //   onPressed: () => DevelopmentSpriteEditorRoute().go(context),
      // ),
      // item(
      //   label: 'Resizable',
      //   onPressed: () => DevelopmentResizableRoute().go(context),
      // ),
      // item(
      //   label: 'Workspace',
      //   onPressed: () => DevelopmentWorkspaceRoute().go(context),
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Text('Development'),
      ),
      content: ListView(children: _buildItems(context)),
    );
  }
}
