import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:petit_zug/petit_zug.dart';

import '../get_it.dart';

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
  Future<DocumentReference<FirestoreData>?> commit() async {
    if (!canCommit) {
      return null;
    }
    isBusy = true;
    try {
      var reference = firestore.collection('projects').doc();
      await reference.set({
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      isCreated = true;
      return reference;
    } finally {
      isBusy = false;
    }
  }
}
