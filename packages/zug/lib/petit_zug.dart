library petit_zug;

export './src/base.dart';
export './src/entity.dart';
export './src/hook.dart';
export './src/query_array.dart';
export './src/stream.dart';
export './src/utils.dart';

/*

var collection = it.get<FirebaseFirestore>().collection('projects');
var reference = collection.orderBy('index');

final models = useSubscribable(FirestoreModels<Project>(
  reference: reference,
  model: (reference) {
    return Project(reference);
  },
  canUpdate: null,
));

class Project extends _Project with _$Project {
  Project(super.reference);

  @computed
  String? get name => data['name'];

  @override
  String toString() {
    return 'Project{path: ${reference.path}, data: $data}';
  }
}

abstract class _Project extends FirestoreEntity with Store {
  _Project(super.reference);
}

*/
