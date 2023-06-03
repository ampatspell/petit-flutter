import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/base.dart';
import '../widgets/base/fluent_screen.dart';
import '../widgets/development/one.dart';
import '../widgets/development/screen.dart';
import '../widgets/development/three.dart';
import '../widgets/development/two.dart';
import '../widgets/home.dart';
import '../widgets/project/screen.dart';
import '../widgets/project/workspace/screen.dart';
import '../widgets/projects/new/screen.dart';
import '../widgets/projects/screen.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellKey = GlobalKey<NavigatorState>();

@TypedShellRoute<FluentRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<HomeRoute>(
      path: '/',
    ),
    TypedGoRoute<ProjectsRoute>(
      path: '/projects',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<NewProjectRoute>(path: 'new'),
        TypedGoRoute<ProjectRoute>(
          path: ':projectId',
          routes: [
            TypedGoRoute<ProjectWorkspaceRoute>(path: 'workspaces/:workspaceId'),
          ],
        ),
      ],
    ),
    TypedGoRoute<DevelopmentRoute>(
      path: '/dev',
      routes: [
        TypedGoRoute<DevelopmentOneRoute>(path: '1'),
        TypedGoRoute<DevelopmentTwoRoute>(path: '2'),
        TypedGoRoute<DevelopmentThreeRoute>(path: '3'),
      ],
    ),
  ],
)
class FluentRoute extends ShellRouteData {
  const FluentRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = _shellKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return FluentScreen(
      content: navigator,
      shellContext: _shellKey.currentContext,
    );
  }
}

class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

class DevelopmentRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DevelopmentScreen();
  }
}

class DevelopmentOneRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DevelopmentOneScreen();
  }
}

class DevelopmentTwoRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DevelopmentTwoScreen();
  }
}

class DevelopmentThreeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DevelopmentThreeScreen();
  }
}

class ProjectsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProjectsScreen();
  }
}

class NewProjectRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewProjectScreen();
  }
}

class ProjectRoute extends GoRouteData {
  const ProjectRoute({required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProjectScreen(projectId: projectId);
  }
}

class ProjectWorkspaceRoute extends GoRouteData {
  const ProjectWorkspaceRoute({
    required this.projectId,
    required this.workspaceId,
  });

  final String projectId;
  final String workspaceId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WorkspaceScreen(
      projectId: projectId,
      workspaceId: workspaceId,
    );
  }
}

// // Without this static key, the dialog will not cover the navigation rail.
// static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

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

@Riverpod(keepAlive: true, dependencies: [appState])
List<Route> routes(RoutesRef ref) {
  final hasUser = ref.watch(appStateProvider.select((value) => value.user != null));
  if (hasUser) {
    return loggedIn;
  }
  return [
    home,
  ];
}

@Riverpod(keepAlive: true, dependencies: [appState])
Raw<GoRouter> router(RouterRef ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: initialLocation,
    routes: $appRoutes,
    navigatorKey: _rootKey,
    redirect: (context, state) async {
      final location = state.location;
      if (location != '/') {
        final signedOut = ref.read(appStateProvider.select((value) => value.user == null));
        if (signedOut) {
          return '/';
        }
      } else if (location == '/') {
        final signedIn = ref.read(appStateProvider.select((value) => value.user != null));
        if (signedIn) {
          return '/projects';
        }
      }
      return null;
    },
  );
}

class OnRouteChange {
  @override
  String toString() {
    return 'OnRouteChange{}';
  }
}

@Riverpod(keepAlive: true, dependencies: [router])
Stream<OnRouteChange> routerOnRouteChange(RouterOnRouteChangeRef ref) {
  final controller = StreamController<OnRouteChange>();
  void listener() {
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      controller.add(OnRouteChange());
    });
  }

  final router = ref.read(routerProvider);
  router.addListener(listener);
  ref.onDispose(() => router.removeListener(listener));

  return controller.stream;
}

const initialLocation = '/dev/3';
