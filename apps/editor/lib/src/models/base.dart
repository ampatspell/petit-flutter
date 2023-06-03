import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base.freezed.dart';

@Deprecated('use mobx')
@freezed
class FirebaseServices with _$FirebaseServices {
  const factory FirebaseServices({
    required FirebaseApp app,
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) = _FirebaseServices;
}

@Deprecated('use mobx')
@freezed
class AppState with _$AppState {
  const factory AppState({
    required User? user,
    @Default(false) bool isLoaded,
  }) = _AppState;
}
