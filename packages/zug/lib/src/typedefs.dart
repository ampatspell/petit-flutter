part of '../zug.dart';

typedef FirestoreMap = Map<String, dynamic>;
typedef MapQuery = Query<FirestoreMap>;
typedef MapQuerySnapshot = QuerySnapshot<FirestoreMap>;
typedef MapDocumentReference = DocumentReference<FirestoreMap>;
typedef MapDocumentSnapshot = DocumentSnapshot<FirestoreMap>;
typedef MapDocumentReferenceProvider = MapDocumentReference? Function()?;
typedef MapQueryProvider = MapQuery? Function()?;
typedef MapCollectionReference = CollectionReference<FirestoreMap>;
