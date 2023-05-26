part of 'fields.dart';

class FieldError<T> extends StatelessWidget {
  const FieldError({
    super.key,
    required this.validation,
    required this.child,
  });

  final PropertyValidation<T>? validation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final error = validation?.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (error != null) ...[
          const Gap(3),
          DefaultFluentTextStyle(
            resolve: (typography) {
              final brightness = FluentTheme.of(context).brightness;
              return typography.caption!.copyWith(color: Colors.red.defaultBrushFor(brightness));
            },
            child: Text(error),
          ),
        ]
      ],
    );
  }
}
