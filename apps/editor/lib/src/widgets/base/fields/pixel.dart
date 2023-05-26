part of 'fields.dart';

class FieldPixels extends ConsumerWidget {
  const FieldPixels({
    super.key,
    required this.provider,
  });

  final AutoDisposeProvider<Field<int, PixelOptions>> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider.select((value) => value.property.value));
    final validation = ref.read(provider)._validate(value.toString());

    return FieldLabel(
      label: ref.watch(provider.select((value) => value.property.name)),
      child: FieldError<int>(
        validation: validation,
        child: Segmented(
          segments: ref.watch(provider.select((value) {
            return value.property.options!.values.map((e) {
              return Segment(label: '${e}x', value: e);
            }).toList(growable: false);
          })),
          selected: value,
          onSelect: (value) {
            final field = ref.read(provider);
            final validated = field._validate(value.toString());
            if (validated.error == null) {
              field.property.update(validated.value as int);
            }
          },
        ),
      ),
    );
  }
}
