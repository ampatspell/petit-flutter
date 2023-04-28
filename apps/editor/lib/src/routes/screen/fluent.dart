import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../router.dart';

class FluentTools extends HookWidget {
  final Widget child;

  const FluentTools({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class FluentScreen extends StatelessWidget {
  final Widget content;
  final BuildContext? shellContext;

  const FluentScreen({
    super.key,
    required this.content,
    required this.shellContext,
  });

  @override
  Widget build(BuildContext context) {
    final location = router.location;
    final items = routes
        .map((route) => PaneItem(
              key: ValueKey(route.location),
              icon: Icon(route.icon),
              title: Text(route.title),
              body: const SizedBox.shrink(),
              onTap: () => route.go(context),
            ))
        .toList(growable: false)
        .cast<NavigationPaneItem>();

    final selected = items.asMap().entries.firstWhere((element) {
      final key = element.value.key as ValueKey<String>;
      return location.startsWith(key.value);
    });

    return NavigationView(
      appBar: NavigationAppBar(
        title: (selected.value as PaneItem).title,
        // actions: ctx.buildAppBarActions != null ? ctx.buildAppBarActions!(context) : null,
      ),
      paneBodyBuilder: (item, body) => content,
      pane: NavigationPane(
        header: const Text('Petit'),
        displayMode: PaneDisplayMode.open,
        items: items,
        selected: selected.key,
      ),
    );
  }
}
