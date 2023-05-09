import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

import '../typedefs.dart';

part 'project.freezed.dart';

@freezed
class Project with _$Project {
  const Project._();

  const factory Project({
    required MapDocumentReference reference,
    required FirestoreMap data,
  }) = _Project;

  String get name => data['name'] as String;
}

@freezed
class NewProjectData with _$NewProjectData {
  const NewProjectData._();

  const factory NewProjectData({
    @Default(false) bool isBusy,
    @Default('') String name,
  }) = _NewProjectData;

  bool get isValid => name.isNotEmpty;
}
