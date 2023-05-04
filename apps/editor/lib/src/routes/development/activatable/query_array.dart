import 'package:mobx/mobx.dart';
import 'activatable.dart';

part 'query_array.g.dart';

class QueryArray<T> extends _QueryArray<T> with _$QueryArray {
  @override
  String toString() {
    return 'QueryArray{type: $T, hash: ${identityHashCode(this)}, isActivated: $isActivated}';
  }
}

abstract class _QueryArray<T> extends Activatable with Store {
  @override
  @action
  void activate() {
    super.activate();
    print('activate $this');
  }

  @override
  @action
  void dispose() {
    super.dispose();
    print('dispose $this');
  }
}
