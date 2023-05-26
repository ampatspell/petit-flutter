part of 'fields.dart';

class FieldPixels extends ConsumerWidget {
  const FieldPixels({
    super.key,
    required this.provider,
  });

  final AutoDisposeProvider<Field<int, PixelOptions>> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FieldLabel(
      label: ref.watch(provider.select((value) => value.property.name)),
      child: FieldError<int>(
        validation: null,
        child: Segmented(
          segments: ref.watch(provider.select((value) {
            return value.property.options!.values.map((e) {
              return Segment(label: '${e}x', value: e);
            }).toList(growable: false);
          })),
          selected: ref.watch(provider.select((value) => value.property.value)),
          onSelect: (value) {
            final validated = ref.read(provider)._validate(value.toString());
            if (validated.error == null) {
              ref.read(provider).property.update(validated.value as int);
            }
          },
        ),
      ),
    );
  }
}
