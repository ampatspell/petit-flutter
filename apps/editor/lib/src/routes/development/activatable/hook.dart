// import 'package:flutter/widgets.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
//
// import 'activatable.dart';
//
// R useActivatable<A, R extends Activatable>({
//   required A args,
//   required R Function(A args) build,
// }) {
//   return use(ActivatableHook(args: args, create: build));
// }
//
// class ActivatableHook<A, R extends Activatable> extends Hook<R> {
//   final A args;
//   final R Function(A args) create;
//
//   const ActivatableHook({
//     required this.args,
//     required this.create,
//   });
//
//   @override
//   ActivatableHookState<A, R> createState() {
//     return ActivatableHookState<A, R>();
//   }
// }
//
// class ActivatableHookState<A, R extends Activatable> extends HookState<R, ActivatableHook<A, R>> {
//   R? value;
//
//   ActivatableHookState();
//
//   @override
//   R build(BuildContext context) {
//     if (value == null) {
//       value = hook.create(hook.args);
//       value!.activate();
//     }
//     return value!;
//   }
//
//   @override
//   void didUpdateHook(ActivatableHook oldHook) {
//     if (oldHook.args != hook.args) {
//       if (value != null) {
//         value!.dispose();
//         value = hook.create(hook.args);
//         value!.activate();
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     if (value != null) {
//       value!.dispose();
//     }
//   }
// }
