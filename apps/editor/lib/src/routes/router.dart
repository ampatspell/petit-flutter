import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petit_editor/src/blocks/riverpod/provider_scope_overrides.dart';

import '../blocks/riverpod/fluent_screen.dart';
import '../providers/project.dart';
import 'development.dart';
import 'development/measurable.dart';
import 'development/riverpod.dart';
import 'projects.dart';
import 'projects/new.dart';
import 'projects/project.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellKey = GlobalKey<NavigatorState>();

@TypedShellRoute<FluentRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<ProjectsRoute>(
      path: '/projects',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<NewProjectRoute>(path: 'new'),
        TypedGoRoute<ProjectRoute>(path: ':id'),
      ],
    ),
    TypedGoRoute<DevelopmentRoute>(
      path: '/dev',
      routes: [
        TypedGoRoute<DevelopmentRiverpodRoute>(path: 'riverpod'),
        TypedGoRoute<DevelopmentMeasurableRoute>(path: 'measurable'),
        // TypedGoRoute<DevelopmentSpriteEditorRoute>(path: 'sprite-editor'),
        // TypedGoRoute<DevelopmentResizableRoute>(path: 'resizable'),
        // TypedGoRoute<DevelopmentWorkspaceRoute>(path: 'workspace'),
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

class DevelopmentRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DevelopmentScreen();
  }
}

class DevelopmentMeasurableRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DevelopmentMeasurableScreen();
  }
}

class DevelopmentRiverpodRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DevelopmentRiverpodScreen();
  }
}

// class DevelopmentSpriteEditorRoute extends GoRouteData {
//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return const DevelopmentSpriteEditorScreen();
//   }
// }
//
// class DevelopmentWorkspaceRoute extends GoRouteData {
//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return const DevelopmentWorkspaceScreen();
//   }
// }
//
// class DevelopmentResizableRoute extends GoRouteData {
//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return const DevelopmentResizableScreen();
//   }
// }

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
  final String id;

  ProjectRoute({required this.id});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProviderScopeOverrides(
      parent: this,
      overrides: (context, ref) => [
        overrideProvider(projectIdProvider).withValue(id),
      ],
      child: const ProjectScreen(),
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
    icon: FluentIcons.code,
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
