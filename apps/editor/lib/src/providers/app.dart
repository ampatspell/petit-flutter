import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../firebase_options.dart';
import '../models/firebase.dart';

part 'app.g.dart';

Future<FirebaseServices> initializeFirebase() async {
  final app = await Firebase.initializeApp(
    name: 'default',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firestore = FirebaseFirestore.instanceFor(app: app);
  firestore.settings = firestore.settings.copyWith(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  final auth = FirebaseAuth.instanceFor(app: app);
  return FirebaseServices(
    app: app,
    firestore: firestore,
    auth: auth,
  );
}

@Riverpod(keepAlive: true, dependencies: [])
FirebaseServices firebaseServices(FirebaseServicesRef ref) => throw UnimplementedError('override');

@Riverpod(keepAlive: true, dependencies: [firebaseServices])
class AuthStateChanges extends _$AuthStateChanges {
  @override
  Stream<User?> build() {
    final services = ref.watch(firebaseServicesProvider);
    return services.auth.authStateChanges();
  }
}
