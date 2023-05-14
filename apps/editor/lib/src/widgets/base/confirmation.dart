import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

Future<void> deleteConfirmation(
  BuildContext context, {
  required String message,
  required void Function(BuildContext context) onAction,
}) async {
  await confirmation(
    context,
    message: message,
    action: 'Delete',
    onAction: onAction,
  );
}

Future<void> confirmation(
  BuildContext context, {
  required String message,
  required String action,
  required void Function(BuildContext context) onAction,
}) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (context) => ContentDialog(
      title: Text(message),
      actions: [
        Button(
          child: Text(action),
          onPressed: () {
            context.pop();
            onAction(context);
          },
        ),
        FilledButton(
          child: const Text('Cancel'),
          onPressed: () {
            context.pop();
          },
        ),
      ],
    ),
  );
}

CommandBarButton buildDeleteCommandBarButton(
  BuildContext context, {
  required String label,
  required String message,
  required VoidCallback? action,
  required void Function(BuildContext context, VoidCallback onDelete) onCommit,
}) {
  VoidCallback? delete() {
    if (action == null) {
      return null;
    }

    return () async {
      await deleteConfirmation(
        context,
        message: message,
        onAction: (context) => onCommit(context, action),
      );
    };
  }

  return CommandBarButton(
    icon: const Icon(FluentIcons.remove),
    label: Text(label),
    onPressed: delete(),
  );
}
