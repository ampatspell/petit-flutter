import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/base.dart';

class DevelopmentThreeScreen extends HookConsumerWidget {
  const DevelopmentThreeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref
        .watch(firestoreStreamsProvider)
        .workspaceItems(projectId: 'eUuGnv22OZZrn4l0AksM', workspaceId: '9Dp5CXfyxxtOySe9uOiS');

    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Three'),
      ),
      content: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          return Text(snapshot.toString());
        },
      ),
    );
  }
}
