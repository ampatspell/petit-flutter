import 'package:mobx/mobx.dart';
import 'package:petit_editor/src/get_it.dart';

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

  static App get get => it.get();
}

abstract class _App with Store {}
