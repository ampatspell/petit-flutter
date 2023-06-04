import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:zug/zug.dart';

import '../firebase_options.dart';
import 'mobx/mobx.dart';
import 'mobx/references.dart';

final it = GetIt.instance;

Future<void> registerEditor() async {
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  firestore.settings = firestore.settings.copyWith(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  final auth = FirebaseAuth.instance;

  it.registerSingleton(app);
  it.registerSingleton(firestore);
  it.registerSingleton(auth);
  it.registerSingleton(FirestoreReferences());
  it.registerSingleton(Auth());
  it.registerSingleton(RouterHelper());

  await registerZug();
}
