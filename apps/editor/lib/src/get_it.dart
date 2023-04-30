import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

import '../firebase_options.dart';
import 'stores/app.dart';

final GetIt it = GetIt.instance;

Future<bool> _registerGetIt() async {
  final app = await Firebase.initializeApp(
    name: 'default',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firestore = FirebaseFirestore.instanceFor(app: app);
  firestore.settings = firestore.settings.copyWith(
    persistenceEnabled: true,
  );
  final auth = FirebaseAuth.instanceFor(app: app);
  it.registerSingleton(app);
  it.registerSingleton(firestore);
  it.registerSingleton(auth);
  it.registerLazySingleton(() => App());
  return true;
}

Future<bool>? _getItFuture;

Future<bool> get getItReady {
  _getItFuture ??= _registerGetIt();
  return _getItFuture!;
}
