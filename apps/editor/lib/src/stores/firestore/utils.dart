import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDateTime {
  DateTime? estimate;
  FieldValue? fieldValue;
  Timestamp? timestamp;

  FirestoreDateTime({
    this.fieldValue,
    this.timestamp,
  }) {
    if (fieldValue != null) {
      estimate = DateTime.now();
    } else {
      estimate = null;
    }
  }

  factory FirestoreDateTime.serverTimestamp() {
    return FirestoreDateTime(
      fieldValue: FieldValue.serverTimestamp(),
    );
  }

  factory FirestoreDateTime.fromFirestore(Object? value) {
    if (value is Timestamp) {
      return FirestoreDateTime(timestamp: value);
    }
    return FirestoreDateTime();
  }

  DateTime? get dateTime {
    return timestamp?.toDate() ?? estimate;
  }

  Object? toFirestore() {
    return fieldValue ?? timestamp;
  }

  @override
  String toString() {
    return 'FirestoreDate{fieldValue: $fieldValue, timestamp: $timestamp}';
  }
}
