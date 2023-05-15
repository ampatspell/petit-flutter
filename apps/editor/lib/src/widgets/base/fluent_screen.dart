import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app/router.dart';
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
    final router = ref.read(routerProvider);
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
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: _CurrentUser(),
          ),
        ),
      ),
      paneBodyBuilder: (item, body) => content,
      pane: NavigationPane(
        header: const Text('Petit'),
        displayMode: PaneDisplayMode.compact,
        items: items,
        selected: selected?.key,
      ),
    );
  }
}

class _Leading extends HookConsumerWidget {
  const _Leading();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(routerOnRouteChangeProvider);
    final canPop = ref.read(routerProvider.select((value) => value.canPop()));
    VoidCallback? onPressed() {
      if (canPop) {
        ref.read(routerProvider).pop();
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

class _CurrentUser extends HookConsumerWidget {
  const _CurrentUser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authStateChangesProvider);
    final auth = ref.watch(firebaseServicesProvider.select((services) => services.auth));

    return state.when(
      data: (data) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: buildActions(context, auth, data),
        );
      },
      error: (error, stackTrace) {
        debugPrintStack(
          label: 'CurrentUser',
          stackTrace: stackTrace,
        );
        return const Text('Error');
      },
      loading: () {
        return const SizedBox.shrink();
      },
    );
  }

  List<Widget> buildActions(
    BuildContext context,
    FirebaseAuth auth,
    User? user,
  ) {
    void signIn() async {
      await auth.signInWithEmailAndPassword(
        email: 'ampatspell@gmail.com',
        password: 'heythere',
      );
    }

    void signOut() async {
      await auth.signOut();
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
