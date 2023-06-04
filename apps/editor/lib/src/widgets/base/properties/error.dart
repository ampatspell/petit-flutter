part of 'properties.dart';

class PropertyError extends StatelessObserverWidget {
  const PropertyError({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final error = context.watch<PropertyState>().error;
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
        ],
      ],
    );
  }
}
