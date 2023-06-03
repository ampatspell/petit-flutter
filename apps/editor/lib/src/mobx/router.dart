part of 'mobx.dart';

class RouterHelper extends _RouterHelper with _$RouterHelper {}

abstract class _RouterHelper with Store {
  _RouterHelper() {
    _subscribe();
  }

  @observable
  bool canPop = false;

  @action
  void _setCanPop(bool value) {
    canPop = value;
  }

  void _subscribe() {
    router.addListener(() {
      SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
        _setCanPop(router.canPop());
      });
    });
  }
}
