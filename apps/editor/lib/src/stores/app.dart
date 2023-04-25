import 'package:mobx/mobx.dart';

import 'editor/area.dart';

part 'app.g.dart';

class App extends _App with _$App {
  EditorArea createEditorArea() {
    return EditorArea();
  }

  @override
  String toString() {
    return 'App{}';
  }
}

abstract class _App with Store {}
