part of 'properties.dart';

class PropertyError<T> extends StatelessWidget {
  const PropertyError({
    super.key,
    required this.error,
    required this.child,
  });

  final String? error;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
            child: Text(error!),
          ),
        ]
      ],
    );
  }
}
