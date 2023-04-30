import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:petit_editor/src/routes/projects/project.dart';
import 'package:petit_editor/src/stores/project.dart';

import '../blocks/fluent_screen.dart';
import '../get_it.dart';
import 'development.dart';
import 'projects.dart';
import 'projects/new.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellKey = GlobalKey<NavigatorState>();

@TypedShellRoute<FluentRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<ProjectsRoute>(
      path: '/projects',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<NewProjectRoute>(
          path: 'new',
        ),
        TypedGoRoute<ProjectRoute>(
          path: ':projectId',
        ),
      ],
    ),
    TypedGoRoute<DevelopmentRoute>(path: '/dev'),
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

class DevelopmentRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DevelopmentScreen();
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
  final String projectId;

  ProjectRoute({required this.projectId});

  FirebaseFirestore get firestore => it.get();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProjectScreen(
      reference: firestore.collection('projects').doc(projectId),
    );
  }
}

// // Without this static key, the dialog will not cover the navigation rail.
// static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

class Route {
  final String location;
  final IconData icon;
  final String title;
  final void Function(BuildContext context) go;

  const Route({
    required this.location,
    required this.icon,
    required this.title,
    required this.go,
  });
}

final routes = [
  Route(
    location: ProjectsRoute().location,
    icon: FluentIcons.project_collection,
    title: 'Projects',
    go: (context) => ProjectsRoute().go(context),
  ),
  Route(
    location: DevelopmentRoute().location,
    icon: FluentIcons.deploy,
    title: 'Development',
    go: (context) => DevelopmentRoute().go(context),
  ),
];

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/projects',
  routes: $appRoutes,
  navigatorKey: _rootKey,
);
