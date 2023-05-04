import 'package:fluent_ui/fluent_ui.dart';
import 'package:mobx/mobx.dart';

part 'activatable.g.dart';

class Activatable extends _Activatable with _$Activatable {}

abstract class _Activatable with Store {
  @observable
  bool isActivated = false;

  @mustCallSuper
  @action
  void activate() {
    isActivated = true;
  }

  @mustCallSuper
  @action
  void dispose() {
    isActivated = false;
  }
}
