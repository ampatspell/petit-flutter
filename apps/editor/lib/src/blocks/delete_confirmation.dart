import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

Future<void> deleteWithConfirmation(
  BuildContext context, {
  required String message,
  required void Function(BuildContext context) onDelete,
}) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (context) => ContentDialog(
      title: Text(message),
      actions: [
        Button(
          child: const Text('Delete'),
          onPressed: () {
            context.pop();
            onDelete(context);
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
