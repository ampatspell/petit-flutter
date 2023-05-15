import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../app/theme.dart';
import '../../../providers/project.dart';
import '../../base/loaded_scope/loaded_scope.dart';
import 'workspace/editor.dart';
import 'workspace/inspector.dart';

class ProjectWorkspace extends ConsumerWidget {
  const ProjectWorkspace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _WithLoaded(
      child: _Container(
        content: ProjectWorkspaceEditor(),
        inspector: ProjectWorkspaceInspector(),
      ),
    );
  }
}

class _WithLoaded extends ConsumerWidget {
  const _WithLoaded({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(selectedProjectWorkspaceModelProvider);
    if (workspace != null) {
      return LoadedScope(
        loaders: (context, ref) => [
          overrideProvider(projectWorkspaceModelProvider).withValue(workspace),
        ],
        child: LoadedScope(
          loaders: (context, ref) => [
            overrideProvider(projectWorkspaceItemModelsProvider).withLoadedValue(
              ref.watch(projectWorkspaceItemModelsStreamProvider),
            ),
          ],
          child: child,
        ),
      );
    } else {
      return const Center(
        child: Text('Workspace not selected'),
      );
    }
  }
}

class _Container extends StatelessWidget {
  const _Container({
    required this.content,
    required this.inspector,
  });

  final Widget content;
  final Widget inspector;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Grey.grey245),
                  top: BorderSide(color: Grey.grey245),
                  right: BorderSide(color: Grey.grey245),
                ),
              ),
              child: content,
            ),
          ),
          inspector,
        ],
      ),
    );
  }
}
