// import 'package:mobx/mobx.dart';
// import 'activatable.dart';
// import 'query_array.dart';
//
// part 'thing.g.dart';
//
// class ThingArgs {
//   final bool ok;
//
//   ThingArgs({
//     required this.ok,
//   });
//
//   ThingArgs toggle() {
//     return ThingArgs(ok: !ok);
//   }
//
//   @override
//   String toString() {
//     return 'ThingArgs{ok: $ok}';
//   }
//
//   @override
//   bool operator ==(Object other) {
//     return identical(this, other) ||
//         other is ThingArgs &&
//             runtimeType == other.runtimeType &&
//             ok == other.ok;
//   }
//
//   @override
//   int get hashCode => ok.hashCode;
// }
//
// class Thing extends _Thing with _$Thing {
//   final ThingArgs args;
//
//   Thing({
//     required this.args,
//   }) {
//     id = 'one';
//   }
//
//   @override
//   void activate() {
//     super.activate();
//     print('activate $this');
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     print('dispose $this');
//   }
//
//   @override
//   String toString() {
//     return 'Thing{'
//         'hash: ${identityHashCode(this)}, '
//         'args: $args, '
//         'activated: $isActivated, '
//         'id: $id, '
//         '}';
//   }
// }
//
// abstract class _Thing extends Activatable with Store {
//   @observable
//   String? id;
//
//   QueryArray? _query;
//
//   @computed
//   QueryArray get query {
//     if (_query == null || _query!.id != id) {
//       if (_query != null) {
//         _query!.dispose();
//       }
//       _query = QueryArray(id: id);
//       _query!.activate();
//     }
//     return _query!;
//   }
//
//   @action
//   void toggleId() {
//     id = id == 'one' ? 'two' : 'one';
//   }
// }
