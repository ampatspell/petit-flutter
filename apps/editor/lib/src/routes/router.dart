import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petit_editor/src/routes/projects/project.dart';

import 'projects.dart';
import 'projects/new.dart';

part 'router.g.dart';

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  @override
  FutureOr<String> redirect(BuildContext context, GoRouterState state) {
    return '/projects';
  }
}

@TypedGoRoute<ProjectsRoute>(
  path: '/projects',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<NewProjectRoute>(
      path: 'new',
    ),
    TypedGoRoute<ProjectRoute>(
      path: ':projectId',
    ),
  ],
)
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

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProjectScreen(projectId: projectId);
  }
}

final router = GoRouter(
  debugLogDiagnostics: true,
  routes: $appRoutes,
);
