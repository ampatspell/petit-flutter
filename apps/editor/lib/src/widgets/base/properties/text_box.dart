part of 'properties.dart';

class PropertyTextBox<Properties, Value> extends HookConsumerWidget {
  const PropertyTextBox({
    super.key,
    required this.accessor,
  });

  final PropertyAccessor<Properties, Value, String, void> accessor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = useState<String?>(accessor.readCurrentError(ref));

    final controller = useTextEditingController(
      text: accessor.readEditValue(ref),
    );

    ref.listen(accessor.selectValue, (previous, next) {
      if (controller.text != next) {
        controller.text = accessor.toEdit(next);
        error.value = accessor.readCurrentError(ref);
      }
    });

    return PropertyLabel(
      accessor: accessor,
      child: PropertyError<String>(
        error: error.value,
        child: Focus(
          onFocusChange: (value) {
            if (!value) {
              controller.text = accessor.readEditValue(ref);
              error.value = accessor.readCurrentError(ref);
            }
          },
          child: TextBox(
            controller: controller,
            placeholder: '',
            enabled: !accessor.watchDisabled(ref),
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              final result = accessor.validateEdit(ref, value);
              error.value = result.error;
            },
            onSubmitted: (value) {
              final result = accessor.validateEdit(ref, value);
              if (result.error == null) {
                accessor.update(ref, result.value as Value);
              }
            },
          ),
        ),
      ),
    );
  }
}
