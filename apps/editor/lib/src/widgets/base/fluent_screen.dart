import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app/router.dart';
import '../../get.dart';
import '../../mobx/mobx.dart';
import '../../providers/base.dart';

class FluentScreen extends ConsumerWidget {
  const FluentScreen({
    super.key,
    required this.content,
    required this.shellContext,
  });

  final Widget content;
  final BuildContext? shellContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routesProvider);

    ref.listen(appStateProvider, (previous, next) {
      if (next.user == null) {
        HomeRoute().go(context);
      } else {
        ProjectsRoute().go(context);
      }
    });

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

    final location = router.location;
    final selected = items.asMap().entries.firstWhereOrNull((element) {
      final key = element.value.key as ValueKey<String>;
      if (key.value == '/') {
        return location == '/';
      }
      return location.startsWith(key.value);
    });

    Widget? title;
    if (selected != null) {
      title = (selected.value as PaneItem).title;
    } else {
      title = const Text('Petit');
    }

    return NavigationView(
      appBar: NavigationAppBar(
        title: title,
        automaticallyImplyLeading: false,
        leading: shellContext != null ? const _Leading() : null,
        actions: const SizedBox(
          height: 50,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: _CurrentUser(),
          ),
        ),
      ),
      paneBodyBuilder: (item, body) => content,
      pane: NavigationPane(
        header: const Text('Petit'),
        displayMode: PaneDisplayMode.minimal,
        items: items,
        selected: selected?.key,
      ),
    );
  }
}

class _Leading extends StatelessObserverWidget {
  const _Leading();

  RouterHelper get helper => it.get();

  @override
  Widget build(BuildContext context) {
    final canPop = helper.canPop;
    VoidCallback? onPressed() {
      if (canPop) {
        router.pop();
      }
      return null;
    }

    return PaneItem(
      icon: const Center(child: Icon(FluentIcons.back, size: 12.0)),
      title: const Text('Back'),
      body: const SizedBox.shrink(),
      enabled: canPop,
    ).build(
      context,
      false,
      onPressed,
      displayMode: PaneDisplayMode.compact,
    );
  }
}

class _CurrentUser extends StatelessObserverWidget {
  const _CurrentUser();

  Auth get _auth => it.get();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: buildActions(context),
    );
  }

  List<Widget> buildActions(BuildContext context) {
    final user = _auth.user;

    void signIn() async {
      await _auth.signInWithEmailAndPassword(
        email: 'ampatspell@gmail.com',
        password: 'heythere',
      );
    }

    void signOut() async {
      await _auth.signOut();
    }

    Widget button({required IconData icon, required VoidCallback onPressed}) {
      return CommandBarButton(
        icon: Icon(icon),
        onPressed: () => onPressed(),
      ).build(
        context,
        CommandBarItemDisplayMode.inPrimary,
      );
    }

    if (user == null) {
      return [
        button(icon: FluentIcons.signin, onPressed: signIn),
      ];
    } else {
      return [
        Text(user.email ?? 'Anonymous'),
        const Gap(10),
        button(icon: FluentIcons.power_button, onPressed: signOut),
      ];
    }
  }
}
