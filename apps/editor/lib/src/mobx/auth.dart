part of 'mobx.dart';

class Auth = _Auth with _$Auth;

abstract class _Auth with Store implements Loadable {
  _Auth() {
    _subscribe();
  }

  FirebaseAuth get _auth => it.get();

  void _subscribe() {
    _auth.authStateChanges().listen(_onEvent);
  }

  @override
  @observable
  bool isLoaded = false;

  @override
  final bool isMissing = false;

  @observable
  User? user;

  @action
  void _onEvent(User? next) {
    isLoaded = true;
    user = next;
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  String toString() {
    return '_Auth{isLoaded: $isLoaded, user: $user}';
  }
}
