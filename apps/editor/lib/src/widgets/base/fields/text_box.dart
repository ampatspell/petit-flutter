part of 'fields.dart';

class FieldTextBox<T, O> extends HookConsumerWidget {
  const FieldTextBox({
    super.key,
    required this.provider,
  });

  final AutoDisposeProvider<Field<T, O>> provider;

  String readCurrentValue(WidgetRef ref) {
    final value = ref.read(provider).property.value;
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  PropertyValidation<T> validateCurrentValue(WidgetRef ref) {
    return ref.read(provider)._validate(readCurrentValue(ref));
  }

  PropertyValidation<T> validateValue(WidgetRef ref, String value) {
    return ref.read(provider)._validate(value);
  }

  void updateValue(WidgetRef ref, T value) {
    ref.read(provider).property.update(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validation = useState<PropertyValidation<T>>(validateCurrentValue(ref));

    final controller = useTextEditingController(
      text: readCurrentValue(ref),
    );

    PropertyValidation<T> validateAndUpdateState(String value) {
      final next = validateValue(ref, value);
      validation.value = next;
      return next;
    }

    void update() {
      final value = readCurrentValue(ref);
      if (controller.text != value) {
        controller.text = value;
        validateAndUpdateState(value);
      }
    }

    ref.listen(provider.select((value) => value.property.value), (previous, next) {
      update();
    });

    return FieldLabel(
      label: ref.watch(provider.select((value) => value.property.name)),
      child: FieldError<T>(
        validation: validation.value,
        child: Focus(
          onFocusChange: (value) {
            if (!value) {
              update();
            }
          },
          child: TextBox(
            enabled: ref.watch(provider.select((value) => !value.isDisabledAny)),
            controller: controller,
            placeholder: '',
            onChanged: validateAndUpdateState,
            onSubmitted: (value) {
              final validation = validateAndUpdateState(value);
              if (validation.error == null) {
                updateValue(ref, validation.value as T);
              }
            },
          ),
        ),
      ),
    );
  }
}
