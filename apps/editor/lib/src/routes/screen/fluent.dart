import 'package:fluent_ui/fluent_ui.dart';

import '../router.dart';

class FluentScreen extends StatelessWidget {
  final int selected;
  final Widget body;

  const FluentScreen({
    super.key,
    required this.selected,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
        title: Text('Projects'),
      ),
      paneBodyBuilder: (item, body) {
        return this.body;
      },
      pane: NavigationPane(
        header: const Text('Petit'),
        displayMode: PaneDisplayMode.compact,
        selected: selected,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.project_collection),
            title: const Text("Projects"),
            body: const SizedBox.shrink(),
            onTap: () => ProjectsRoute().go(context),
          ),
        ],
      ),
    );
  }
}
