part of 'fields.dart';

typedef PropertyGetValue<T> = T Function();
typedef PropertyUpdateValue<T> = void Function(T value);
typedef PropertyValidate<T, O> = PropertyValidation<T> Function(Property<T, O> property, String value);

@freezed
class Property<T, O> with _$Property<T, O> {
  const factory Property({
    required String name,
    required T value,
    required PropertyUpdateValue<T> update,
    required PropertyValidate<T, O> validate,
    @Default(false) bool isDisabled,
    O? options,
  }) = _Property<T, O>;
}

@freezed
class FieldGroup with _$FieldGroup {
  const factory FieldGroup({
    @Default(false) bool isDisabled,
  }) = _FieldGroup;

  const FieldGroup._();
}

@freezed
class PropertyValidation<T> with _$PropertyValidation<T> {
  const factory PropertyValidation({
    String? error,
    T? value,
  }) = _PropertyValidation<T>;
}

@freezed
class Field<T, O> with _$Field<T, O> {
  const factory Field({
    required FieldGroup group,
    @Default(false) bool isDisabled,
    required Property<T, O> property,
  }) = _Field<T, O>;

  const Field._();

  bool get isDisabledAny => isDisabled || property.isDisabled || group.isDisabled;

  PropertyValidation<T> _validate(String value) => property.validate(property, value);
}

PropertyValidation<int> requiredInteger(Property<int, void> property, String value) {
  final parsed = int.tryParse(value);
  if (parsed == null) {
    return PropertyValidation(error: '${property.name} must be integer');
  }
  return PropertyValidation(value: parsed);
}
