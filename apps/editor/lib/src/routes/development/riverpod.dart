import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/project.dart';
import '../../providers/app.dart';
import '../../providers/projects.dart';
import '../../providers/references.dart';

part 'riverpod.g.dart';

class DevelopmentRiverpodScreen extends HookConsumerWidget {
  const DevelopmentRiverpodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Riverpod'),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ProjectsWidget(),
        ],
      ),
    );
  }
}

@Riverpod(dependencies: [])
Project selectedProject(SelectedProjectRef ref) => throw UnimplementedError();

class ProjectsWidget extends HookConsumerWidget {
  const ProjectsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(allProjectsProvider);
    return AsyncValueWidget(
      value: projects,
      builder: (context, projects) {
        final project = projects.all[0];
        return ProviderScope(
          overrides: [
            selectedProjectProvider.overrideWithValue(project),
          ],
          child: const ProjectWidget(),
        );
      },
    );
  }
}

class AsyncValueWidget<T extends Object> extends ConsumerWidget {
  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T value) builder;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return value.when(
      data: (data) {
        return builder(context, data);
      },
      error: (error, stackTrace) {
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stackTrace);
        return Text(error.toString());
      },
      loading: () {
        return const Text('Loading…');
      },
    );
  }
}

class ProjectWidget extends HookConsumerWidget {
  const ProjectWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(selectedProjectProvider);
    return Text(project.toString());
  }
}
