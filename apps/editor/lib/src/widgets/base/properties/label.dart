part of 'properties.dart';

class PropertyLabel extends ConsumerWidget {
  const PropertyLabel({
    super.key,
    required this.accessor,
    required this.child,
  });

  final PropertyAccessor<dynamic, dynamic, dynamic, dynamic> accessor;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = accessor.watchLabel(ref);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (value != null) ...[
          DefaultFluentTextStyle(
            resolve: (typography) => typography.bodyStrong,
            child: Text(value),
          ),
          const Gap(1),
        ],
        child,
      ],
    );
  }
}
