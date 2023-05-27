import 'package:freezed_annotation/freezed_annotation.dart';

part 'properties.freezed.dart';

typedef PropertyValidator<Value> = PropertyValidationResult<Value> Function(Value value);
typedef PropertyUpdate<Value> = void Function(Value value);
typedef PropertyValueToEdit<Edit, Value> = Edit Function(Value value);
typedef PropertyEditToValue<Edit, Value> = PropertyValidationResult<Value> Function(Edit edit);

@freezed
class PropertyGroup with _$PropertyGroup {
  const factory PropertyGroup({
    @Default(false) bool isDisabled,
  }) = _PropertyGroup;
}

@freezed
class PropertyValidationResult<Value> with _$PropertyValidationResult<Value> {
  const factory PropertyValidationResult({
    String? error,
    Value? value,
  }) = _PropertyValidationResult<Value>;
}

@freezed
class PropertyAccessorConverter<Value, Edit> with _$PropertyAccessorConverter<Value, Edit> {
  const factory PropertyAccessorConverter({
    required PropertyValueToEdit<Edit, Value> toEdit,
    required PropertyEditToValue<Edit, Value> toValue,
  }) = _PropertyAccessorConverter<Value, Edit>;
}

@freezed
class Property<Value, Options> with _$Property<Value, Options> {
  const factory Property({
    String? label,
    required Value value,
    required PropertyValidator<Value> validate,
    required PropertyUpdate<Value> update,
    @Default(false) bool isDisabled,
    Options? options,
  }) = _Property<Value, Options>;
}

PropertyValidationResult<int> stringToInt(String edit) {
  final parsed = int.tryParse(edit);
  if (parsed == null) {
    return const PropertyValidationResult(error: 'Must be integer');
  }
  return PropertyValidationResult(value: parsed);
}

PropertyValidationResult<String> stringNotEmpty(String value) {
  if (value.isEmpty) {
    return const PropertyValidationResult(error: 'Must not be empty');
  }
  return PropertyValidationResult(value: value);
}

PropertyValidator<String> stringNotEqual(String string) {
  return (value) {
    if (value == string) {
      return PropertyValidationResult(error: 'Must not be equal to $string');
    }
    return PropertyValidationResult(value: value);
  };
}

PropertyValidator<Value> compoundValidator<Value>(
  List<PropertyValidator<Value>> validators,
) {
  return (value) {
    var result = PropertyValidationResult<Value>(error: 'No validators');
    for (final validator in validators) {
      result = validator(value);
      if (result.error != null) {
        return result;
      }
    }
    return result;
  };
}

PropertyValidationResult<Value> noopValidator<Value>(Value value) {
  return PropertyValidationResult(value: value);
}

final intToStringConverter = PropertyAccessorConverter<int, String>(
  toEdit: (value) => value.toString(),
  toValue: (edit) {
    final parsed = int.tryParse(edit);
    if (parsed == null) {
      return const PropertyValidationResult(error: 'Must be integer');
    }
    return PropertyValidationResult(value: parsed);
  },
);

final stringToStringConverter = PropertyAccessorConverter<String, String>(
  toEdit: (value) => value.trim().toString(),
  toValue: (edit) => PropertyValidationResult(value: edit.trim().toString()),
);

final intToIntConverter = PropertyAccessorConverter<int, int>(
  toEdit: (value) => value,
  toValue: (edit) => PropertyValidationResult(value: edit),
);
