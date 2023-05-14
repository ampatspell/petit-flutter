import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app/router.dart';
import '../../providers/base.dart';

class FluentScreen extends HookConsumerWidget {
  const FluentScreen({
    super.key,
    required this.content,
    required this.shellContext,
  });

  final Widget content;
  final BuildContext? shellContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        actions: const SizedBox(
          height: 50,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: CurrentUser(),
          ),
        ),
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
      onPressed = router.pop;
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

class CurrentUser extends HookConsumerWidget {
  const CurrentUser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authStateChangesProvider);
    final auth = ref.watch(firebaseServicesProvider.select((services) {
      return services.auth;
    }));

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
