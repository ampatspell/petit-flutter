import 'package:mobx/mobx.dart';
import 'package:petit_zug/petit_zug.dart';

part 'project.g.dart';

class Project extends _Project with _$Project {
  Project(super.reference);

  @computed
  String? get name => data['name'];

  @computed
  DateTime? get createdAt => timestampToDateTime(data['createdAt']);

  @override
  String toString() {
    return 'Project{path: ${reference.path}, data: $data}';
  }
}

abstract class _Project extends FirestoreEntity with Store {
  _Project(super.reference);
}
