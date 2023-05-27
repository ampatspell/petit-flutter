part of 'properties.dart';

class PropertyPixelSegmented<Properties, Value> extends ConsumerWidget {
  const PropertyPixelSegmented({
    super.key,
    required this.accessor,
  });

  final PropertyAccessor<Properties, Value, int, PixelOptions> accessor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PropertyLabel(
      accessor: accessor,
      child: Segmented<int>(
        disabled: accessor.watchDisabled(ref),
        selected: accessor.watchEdit(ref),
        segments: accessor.watchOptions(ref).values.map((value) {
          return Segment(label: '${value}x', value: value);
        }).toList(growable: false),
        onSelect: (edit) {
          final result = accessor.validateEdit(ref, edit);
          if (result.error == null) {
            accessor.update(ref, result.value as Value);
          }
        },
      ),
    );
  }
}
