export 'package:cloud_firestore/cloud_firestore.dart';
export 'hook.dart';
export 'query_array.dart';
export 'entity.dart';

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
