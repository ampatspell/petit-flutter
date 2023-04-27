import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:petit_editor/src/stores/firestore/utils.dart';

import '../get_it.dart';
import 'firestore/project.dart';

part 'projects.g.dart';

class NewProjectStore extends _NewProjectStore with _$NewProjectStore {}

abstract class _NewProjectStore with Store {
  @observable
  String? name;

  @computed
  get isValid {
    return name != null && name!.trim().isNotEmpty;
  }

  @observable
  bool isBusy = false;

  @observable
  bool isCreated = false;

  @computed
  bool get canCommit => isValid && !isBusy && !isCreated;

  FirebaseFirestore get firestore => it.get();

  @action
  Future<DocumentReference<ProjectData>?> commit() async {
    if (!canCommit) {
      return null;
    }
    isBusy = true;
    try {
      var reference = ProjectData.collection().doc();
      await reference.set(ProjectData(
        name: name,
        createdAt: FirestoreDateTime.serverTimestamp(),
      ));
      isCreated = true;
      return reference;
    } finally {
      isBusy = false;
    }
  }
}
