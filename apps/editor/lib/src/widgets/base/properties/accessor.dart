part of 'properties.dart';

class PropertyAccessor<Properties, Value, Edit, Options> {
  const PropertyAccessor({
    required this.properties,
    required this.property,
    required this.group,
    required this.converter,
  });

  static PropertyAccessor<Properties, String, String, Options> string<Properties, Options>({
    required AutoDisposeProvider<Properties> properties,
    required Property<String, Options> Function(Properties properties) property,
    required PropertyGroup Function(Properties properties) group,
  }) {
    return PropertyAccessor(
      properties: properties,
      property: property,
      group: group,
      converter: stringToStringConverter,
    );
  }

  static PropertyAccessor<Properties, int, String, Options> integerToString<Properties, Options>({
    required AutoDisposeProvider<Properties> properties,
    required Property<int, Options> Function(Properties properties) property,
    required PropertyGroup Function(Properties properties) group,
  }) {
    return PropertyAccessor(
      properties: properties,
      property: property,
      group: group,
      converter: intToStringConverter,
    );
  }

  static PropertyAccessor<Properties, int, int, Options> integer<Properties, Options>({
    required AutoDisposeProvider<Properties> properties,
    required Property<int, Options> Function(Properties properties) property,
    required PropertyGroup Function(Properties properties) group,
  }) {
    return PropertyAccessor(
      properties: properties,
      property: property,
      group: group,
      converter: intToIntConverter,
    );
  }

  final AutoDisposeProvider<Properties> properties;
  final Property<Value, Options> Function(Properties properties) property;
  final PropertyGroup Function(Properties properties) group;
  final PropertyAccessorConverter<Value, Edit> converter;

  //

  ProviderListenable<Property<Value, Options>> get selectProperty {
    return properties.select(property);
  }

  ProviderListenable<PropertyGroup> get selectGroup {
    return properties.select(group);
  }

  ProviderListenable<Value> get selectValue {
    return properties.select((value) => property(value).value);
  }

  ProviderListenable<Edit> get selectEdit {
    return properties.select((prop) => toEdit(property(prop).value));
  }

  ProviderListenable<String?> get selectLabel {
    return properties.select((value) => property(value).label);
  }

  ProviderListenable<bool> get selectPropertyDisabled {
    return properties.select((value) => property(value).isDisabled);
  }

  ProviderListenable<Options> get selectOptions {
    return properties.select((value) => property(value).options!);
  }

  ProviderListenable<bool> get selectGroupDisabled {
    return properties.select((value) => group(value).isDisabled);
  }

  PropertyValidationResult<Value> validateValue(WidgetRef ref, Value value) {
    return ref.read(selectProperty).validate(value);
  }

  PropertyValidationResult<Value> validateEdit(WidgetRef ref, Edit edit) {
    final result = converter.toValue(edit);
    if (result.error != null) {
      return result;
    }
    return validateValue(ref, result.value as Value);
  }

  void update(WidgetRef ref, Value value) {
    ref.read(selectProperty).update(value);
  }

  Value readValue(WidgetRef ref) {
    return ref.read(selectValue);
  }

  Edit toEdit(Value value) {
    return converter.toEdit(value);
  }

  Edit readEditValue(WidgetRef ref) {
    final value = readValue(ref);
    return toEdit(value);
  }

  String? readCurrentError(WidgetRef ref) {
    final edit = readEditValue(ref);
    return validateEdit(ref, edit).error;
  }

  String? watchLabel(WidgetRef ref) {
    return ref.watch(selectLabel);
  }

  bool watchDisabled(WidgetRef ref) {
    return ref.watch(selectGroupDisabled) || ref.watch(selectPropertyDisabled);
  }

  Edit watchEdit(WidgetRef ref) {
    return ref.watch(selectEdit);
  }

  Options watchOptions(WidgetRef ref) {
    return ref.watch(selectOptions);
  }
}
