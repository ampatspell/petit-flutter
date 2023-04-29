import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../routes/router.dart';

class FluentScreen extends HookWidget {
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
    final items = useMemoized(() => routes
        .map((route) => PaneItem(
              key: ValueKey(route.location),
              icon: Icon(route.icon),
              title: Text(route.title),
              body: const SizedBox.shrink(),
              onTap: () => route.go(context),
            ))
        .toList(growable: false)
        .cast<NavigationPaneItem>());

    final selected = items.asMap().entries.firstWhere((element) {
      final key = element.value.key as ValueKey<String>;
      return location.startsWith(key.value);
    });

    return NavigationView(
      appBar: NavigationAppBar(
        title: (selected.value as PaneItem).title,
        automaticallyImplyLeading: false,
        leading: shellContext != null ? const _Leading() : null,
      ),
      paneBodyBuilder: (item, body) => content,
      pane: NavigationPane(
        header: const Text('Petit'),
        displayMode: PaneDisplayMode.compact,
        items: items,
        selected: selected.key,
      ),
    );
  }
}

class _Leading extends StatefulWidget {
  const _Leading();

  @override
  State<_Leading> createState() => _LeadingState();
}

class _LeadingState extends State<_Leading> {
  bool canPop = false;

  void onRouteChange() {
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      setState(() => canPop = router.canPop());
    });
  }

  @override
  void initState() {
    super.initState();
    router.addListener(onRouteChange);
  }

  @override
  void dispose() {
    super.dispose();
    router.removeListener(onRouteChange);
  }

  @override
  Widget build(BuildContext context) {
    var enabled = false;
    VoidCallback? onPressed;
    if (canPop) {
      enabled = true;
      onPressed = () => router.pop();
    }

    return PaneItem(
      icon: const Center(child: Icon(FluentIcons.back, size: 12.0)),
      title: const Text('Back'),
      body: const SizedBox.shrink(),
      enabled: enabled,
    ).build(
      context,
      false,
      onPressed,
      displayMode: PaneDisplayMode.compact,
    );
  }
}
