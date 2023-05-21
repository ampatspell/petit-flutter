import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/workspace.dart';
import '../../providers/base.dart';

part 'three.g.dart';

@Riverpod()
Stream<List<WorkspaceItemModel>> workspaceItems(WorkspaceItemsRef ref) {
  return ref
      .watch(firestoreStreamsProvider)
      .workspaceItemsById(projectId: 'eUuGnv22OZZrn4l0AksM', workspaceId: '9Dp5CXfyxxtOySe9uOiS');
}

class DevelopmentThreeScreen extends HookConsumerWidget {
  const DevelopmentThreeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(workspaceItemsProvider);

    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Three'),
      ),
      content: stream.when(
        data: (data) {
          final doc = data[0];

          void toggle() {
            final pixel = doc.pixel == 1 ? 2 : 1;
            final map = {'pixel': pixel};
            doc.controller.merge(doc, map);
          }

          print('* ${doc.pixel}');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Data'),
              const Gap(10),
              ...data.map((e) => Text(e.toString())),
              const Gap(10),
              FilledButton(
                child: const Text('Toggle'),
                onPressed: toggle,
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return Text(error.toString());
        },
        loading: () {
          return const Text('Loading…');
        },
      ),
    );
  }
}
