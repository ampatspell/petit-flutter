import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:zug/zug.dart';

import '../../app/router.dart';
import '../../models/models.dart';
import 'line.dart';

class FluentScreen extends StatelessObserverWidget {
  const FluentScreen({
    super.key,
    required this.content,
    required this.shellContext,
  });

  final Widget content;
  final BuildContext? shellContext;

  RouterHelper get helper => it.get();

  @override
  Widget build(BuildContext context) {
    final items = helper.routes
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _Debug(),
                Gap(15),
                _CurrentUser(),
              ],
            ),
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
      mainAxisSize: MainAxisSize.min,
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

class _Debug extends StatelessWidget {
  const _Debug();

  @override
  Widget build(BuildContext context) {
    void show() {
      showDialog(
        dismissWithEsc: true,
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Observer(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  color: Colors.white,
                  child: ListView.separated(
                    itemCount: mounted.length,
                    separatorBuilder: (context, index) => const HorizontalLine(),
                    itemBuilder: (context, index) {
                      return Observer(
                        builder: (context) {
                          return ListTile(
                            title: Text(mounted[index].toString()),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return CommandBarButton(
      icon: const Icon(FluentIcons.code),
      label: Observer(
        builder: (context) {
          return Text('${mounted.length} / ${subscriptions.length}');
        },
      ),
      onPressed: show,
    ).build(
      context,
      CommandBarItemDisplayMode.inPrimary,
    );
  }
}
