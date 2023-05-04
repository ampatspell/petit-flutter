import 'package:mobx/mobx.dart';
import 'activatable.dart';

part 'thing.g.dart';

class ThingArgs {
  final bool ok;

  ThingArgs({
    required this.ok,
  });

  ThingArgs toggle() {
    return ThingArgs(ok: !ok);
  }

  @override
  String toString() {
    return 'ThingArgs{ok: $ok}';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is ThingArgs && runtimeType == other.runtimeType && ok == other.ok;
  }

  @override
  int get hashCode => ok.hashCode;
}

class Thing extends _Thing with _$Thing {
  final ThingArgs args;

  Thing({
    required this.args,
  });

  @override
  void activate() {
    super.activate();
    print('activate $this');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose $this');
  }

  @override
  String toString() {
    return 'Thing{hash: ${identityHashCode(this)}, args: $args, activated: $isActivated}';
  }
}

abstract class _Thing extends Activatable with Store {}
