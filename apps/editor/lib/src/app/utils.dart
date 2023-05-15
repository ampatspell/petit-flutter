extension BoolB3Additions on bool {
  T? ifTrue<T>(T arg) {
    if (this == true) {
      return arg;
    }
    return null;
  }

  T? ifFalse<T>(T arg) {
    if (this == false) {
      return arg;
    }
    return null;
  }

  T? when<T>(T? ifTrue, T? ifFalse) {
    if (this == true) {
      return ifTrue;
    }
    return ifFalse;
  }
}

extension Exists<S, T> on T? {
  S? exists(S Function(T self) f) => (this == null) ? null : f(this as T);
}
