import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/project.dart';
import '../../providers/projects.dart';

class DevelopmentRiverpodScreen extends HookConsumerWidget {
  const DevelopmentRiverpodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('build screen');
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Riverpod'),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          DevelopmentRiverpodProjectsTable(),
        ],
      ),
    );
  }
}

class DevelopmentRiverpodProjectsTable extends HookConsumerWidget {
  const DevelopmentRiverpodProjectsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('build table');
    final allProjects = ref.watch(allProjectsProvider);
    return allProjects.when(
      data: (data) {
        debugPrint('data');
        return Content(data: data);
      },
      error: (error, stackTrace) {
        return Text('$error');
      },
      loading: () {
        debugPrint('loading…');
        return const Text('Loading…');
      },
    );
  }
}

class Content extends HookConsumerWidget {
  final List<Project> data;

  const Content({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('build content');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.map((e) => Text(e.toString())).toList(growable: false),
    );
  }
}
