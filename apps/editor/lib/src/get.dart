import 'package:get_it/get_it.dart';
import 'package:zug/zug.dart';

import 'mobx/firestore_references.dart';
import 'models/base.dart';

final it = GetIt.instance;

Future<void> registerEditor(FirebaseServices services) async {
  it.registerSingleton(services.app);
  it.registerSingleton(services.firestore);
  it.registerSingleton(services.auth);
  it.registerSingleton(FirestoreReferences());
  await registerZug();
}
