import 'package:localstorage/localstorage.dart';
import 'package:mobx/mobx.dart';

import 'editor/area.dart';

part 'app.g.dart';

class App extends _App with _$App {
  EditorArea createEditorArea() {
    return EditorArea();
  }

  @override
  String toString() {
    return 'App{isReady: $isReady}';
  }
}

abstract class _App with Store {
  @observable
  bool isReady = false;

  final LocalStorage storage = LocalStorage('app.json');

  @action
  void setReady() {
    isReady = true;
  }

  Future<void> get ready async {
    await storage.ready;
    setReady();
  }
}
