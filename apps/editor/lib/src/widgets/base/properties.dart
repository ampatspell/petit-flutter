import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app/theme.dart';
import '../../models/properties.dart';
import 'gaps.dart';
import 'text_style.dart';

class PropertiesWidget extends ConsumerWidget {
  const PropertiesWidget({
    super.key,
    required this.properties,
  });

  final AutoDisposeProvider<Properties> properties;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final length = ref.watch(properties.select((value) => value.groups.length));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < length; i++)
          PropertyGroupWidget(
            properties: properties,
            group: (properties) => properties.groups[i],
          ),
      ],
    );
  }
}

class PropertyWidgetHelper<T, E> {
  const PropertyWidgetHelper({
    required this.properties,
    required this.property,
  });

  final ProviderListenable<Properties> properties;
  final Property<T, E> Function(Properties properties) property;

  ProviderListenable<R> select<R>(R Function(Property<T, E> property) cb) {
    return properties.select((value) {
      return cb(property(value));
    });
  }

  ProviderListenable<E> selectEditorValue() {
    return select((property) {
      return property.presentation.convertToEditor(property);
    });
  }

  ProviderListenable<T> selectValue() {
    return select((property) {
      return property.value;
    });
  }

  T readValue(WidgetRef ref) {
    return ref.read(selectValue());
  }

  E readEditorValue(WidgetRef ref) {
    return ref.read(selectEditorValue());
  }

  PropertyValidationResult<T> updateWithEditorValue(WidgetRef ref, E value) {
    return ref.read(select((property) {
      return property.updateWithEditorValue(value);
    }));
  }

  PropertyValidationResult<T> validateEditorValue(WidgetRef ref, E value) {
    return ref.read(select((property) {
      return property.validateEditorValue(value);
    }));
  }

  PropertyWidgetHelper<T, N> cast<N>() {
    return PropertyWidgetHelper(
      properties: properties,
      property: (properties) => property(properties) as Property<T, N>,
    );
  }
}

class PropertyGroupWidget extends ConsumerWidget {
  const PropertyGroupWidget({
    super.key,
    required this.properties,
    required this.group,
  });

  final ProviderListenable<Properties> properties;
  final PropertyGroup Function(Properties properties) group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = ref.watch(properties.select((value) => group(value).label));
    final length = ref.watch(properties.select((value) => group(value).properties.length));

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Grey.grey245),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            DefaultFluentTextStyle(
              resolve: (typography) => typography.caption,
              child: Text(label),
            ),
            const Gap(3),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...withGapsBetween(
                children: [
                  for (var i = 0; i < length; i++)
                    Expanded(
                      child: PropertyWidget(
                        helper: PropertyWidgetHelper<dynamic, dynamic>(
                          properties: properties,
                          property: (properties) => group(properties).properties[i],
                        ),
                      ),
                    )
                ],
                gap: const Gap(10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PropertyWidget extends ConsumerWidget {
  const PropertyWidget({
    super.key,
    required this.helper,
  });

  final PropertyWidgetHelper<dynamic, dynamic> helper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(helper.select((property) => property.presentation.type));
    switch (type) {
      case PresentationType.textBox:
        return TextBoxPropertyWidget(helper: helper.cast<String>());
    }
  }
}

class TextBoxPropertyWidget extends HookConsumerWidget {
  const TextBoxPropertyWidget({
    super.key,
    required this.helper,
  });

  final PropertyWidgetHelper<dynamic, String> helper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: helper.readEditorValue(ref));
    late ValueNotifier<String?> error;

    void update() {
      final editor = helper.readEditorValue(ref);
      controller.text = editor;
      error.value = helper.validateEditorValue(ref, editor).error;
    }

    ref.listen(helper.selectEditorValue(), (previous, next) {
      if (controller.text != next) {
        update();
      }
    });

    return Focus(
      onFocusChange: (value) {
        if (!value) {
          update();
        }
      },
      child: PropertyErrorWidget(
        register: (next) {
          error = next;
          error.value = helper.validateEditorValue(ref, controller.text).error;
        },
        child: TextBox(
          placeholder: '',
          controller: controller,
          onChanged: (value) {
            final result = helper.validateEditorValue(ref, value);
            error.value = result.error;
          },
          onSubmitted: (value) {
            final result = helper.updateWithEditorValue(ref, value);
            error.value = result.error;
          },
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }
}

class PropertyErrorWidget extends HookWidget {
  const PropertyErrorWidget({
    super.key,
    required this.register,
    required this.child,
  });

  final Widget child;
  final void Function(ValueNotifier<String?> error) register;

  @override
  Widget build(BuildContext context) {
    final error = useState<String?>(null);
    register(error);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (error.value != null) ...[
          const Gap(3),
          DefaultFluentTextStyle(
            resolve: (typography) {
              final brightness = FluentTheme.of(context).brightness;
              return typography.caption!.copyWith(color: Colors.red.defaultBrushFor(brightness));
            },
            child: Text(error.value!),
          ),
        ],
      ],
    );
  }
}
