import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../get_it.dart';
import '../routes/router.dart';

class FluentScreen extends HookWidget {
  final Widget content;
  final BuildContext? shellContext;

  const FluentScreen({
    super.key,
    required this.content,
    required this.shellContext,
  });

  FirebaseAuth get auth => it.get();

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

    final authStateChanges = useState(auth.authStateChanges());
    final userSnapshot = useStream(authStateChanges.value);

    return NavigationView(
      appBar: NavigationAppBar(
        title: (selected.value as PaneItem).title,
        automaticallyImplyLeading: false,
        leading: shellContext != null ? const _Leading() : null,
        actions: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: buildActions(context, userSnapshot),
            ),
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

  List<Widget> buildActions(BuildContext context, AsyncSnapshot<User?> userSnapshot) {
    final user = userSnapshot.data;

    void signIn() async {
      await auth.signInWithEmailAndPassword(email: 'ampatspell@gmail.com', password: 'heythere');
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
        button(icon: FluentIcons.sign_out, onPressed: signOut),
      ];
    }
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
