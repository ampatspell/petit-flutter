import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

import '../get.dart';
import '../mobx/mobx.dart';
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

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

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

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return FluentScreen(
      content: navigator,
      shellContext: shellNavigatorKey.currentContext,
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

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: initialLocation,
  routes: $appRoutes,
  navigatorKey: rootNavigatorKey,
  redirect: (context, state) {
    return runInAction(() {
      final auth = it.get<Auth>();
      final user = auth.user;
      final location = state.location;
      if (location != '/') {
        if (user == null) {
          return '/';
        }
      } else if (location == '/') {
        if (user != null) {
          return '/projects';
        }
      }
      return null;
    });
  },
);

const initialLocation = '/projects';
