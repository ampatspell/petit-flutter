import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../blocks/async_value.dart';
import '../../models/project.dart';
import '../../providers/projects.dart';

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
    final projects = ref.watch(sortedProjectsProvider);
    return AsyncValueWidget(
      value: projects,
      builder: (context, projects) {
        final project = projects[0];
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

class ProjectWidget extends HookConsumerWidget {
  const ProjectWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(selectedProjectProvider);
    return Text(project.toString());
  }
}
