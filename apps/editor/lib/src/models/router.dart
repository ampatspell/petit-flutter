part of 'models.dart';

class Route {
  const Route({
    required this.location,
    required this.icon,
    required this.title,
    required this.go,
  });

  final String location;
  final IconData icon;
  final String title;
  final void Function(BuildContext context) go;
}

final home = Route(
  location: HomeRoute().location,
  icon: FluentIcons.calories,
  title: 'Home',
  go: (context) => HomeRoute().go(context),
);

final loggedIn = [
  Route(
    location: ProjectsRoute().location,
    icon: FluentIcons.project_collection,
    title: 'Projects',
    go: (context) => ProjectsRoute().go(context),
  ),
  Route(
    location: DevelopmentRoute().location,
    icon: FluentIcons.code,
    title: 'Development',
    go: (context) => DevelopmentRoute().go(context),
  ),
];

class RouterHelper = _RouterHelper with _$RouterHelper;

abstract class _RouterHelper with Store {
  _RouterHelper() {
    _subscribe();
  }

  @observable
  bool canPop = false;

  @action
  void _setCanPop(bool value) {
    canPop = value;
  }

  void _subscribe() {
    router.addListener(() {
      SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
        _setCanPop(router.canPop());
      });
    });

    reaction((reaction) => _auth.user, (user) {
      final context = rootNavigatorKey.currentContext!;
      if (user == null) {
        HomeRoute().go(context);
      } else {
        ProjectsRoute().go(context);
      }
    });
  }

  Auth get _auth => it.get();

  @computed
  List<Route> get routes {
    if (_auth.user != null) {
      return loggedIn;
    }
    return [
      home,
    ];
  }

  @override
  String toString() {
    return 'RouterHelper{}';
  }
}
