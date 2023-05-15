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
}

extension Exists<S, T> on T? {
  S? exists(S Function(T) f) => (this == null) ? null : f(this as T);
}

void foobar() {}
