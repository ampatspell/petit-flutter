// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:mobx/mobx.dart';
//
// part 'activatable.g.dart';
//
// class Activatable extends _Activatable with _$Activatable {}
//
// abstract class _Activatable with Store {
//   final List<Activatable> _activatableChildren = [];
//
//   void registerActivatable(Activatable child) {
//     _activatableChildren.add(child);
//   }
//
//   @observable
//   bool isActivated = false;
//
//   @mustCallSuper
//   @action
//   void activate() {
//     for (var activatable in _activatableChildren) {
//       activatable.activate();
//     }
//     isActivated = true;
//   }
//
//   @mustCallSuper
//   @action
//   void dispose() {
//     for (var activatable in _activatableChildren) {
//       activatable.dispose();
//     }
//     isActivated = false;
//   }
//
//   @computed
//   String get asString => toString();
// }
