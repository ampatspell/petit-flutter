import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/project.dart';
import '../widgets/base/fluent_screen.dart';
import '../widgets/base/loaded_scope/loaded_scope.dart';
import '../widgets/development/one.dart';
import '../widgets/development/screen.dart';
import '../widgets/development/three.dart';
import '../widgets/development/two.dart';
import '../widgets/project/screen.dart';
import '../widgets/projects/new/screen.dart';
import '../widgets/projects/screen.dart';

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
  ProjectRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoadedScope(
      parent: this,
      loaders: (context, ref) => [
        overrideProvider(projectIdProvider).withValue(id),
      ],
      child: const ProjectScreen(),
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

@Riverpod(keepAlive: true)
Raw<GoRouter> router(RouterRef ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/projects',
    routes: $appRoutes,
    navigatorKey: _rootKey,
    redirect: (context, state) async {
      print('redirect: ${state.name}');
      return null;
    },
  );
}

@Riverpod(keepAlive: true, dependencies: [router])
Stream<Object> routerOnRouteChange(RouterOnRouteChangeRef ref) {
  final controller = StreamController<Object>();
  void listener() {
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      controller.add(Object());
    });
  }

  final router = ref.read(routerProvider);
  router.addListener(listener);
  ref.onDispose(() => router.removeListener(listener));

  return controller.stream;
}
