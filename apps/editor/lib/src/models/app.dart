import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app.freezed.dart';

@freezed
class FirebaseServicesData with _$FirebaseServicesData {
  const factory FirebaseServicesData({
    required FirebaseApp app,
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) = _FirebaseServices;
}
