import 'package:freezed_annotation/freezed_annotation.dart';

part 'projects.freezed.dart';

@Deprecated('use mobx')
@freezed
class NewProjectModel with _$NewProjectModel {
  const factory NewProjectModel({
    @Default(false) bool isBusy,
    @Default('') String name,
  }) = _NewProjectModel;

  const NewProjectModel._();

  bool get isValid => name.isNotEmpty;
}
