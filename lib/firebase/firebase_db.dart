import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

Future<void> addUser() async {
  await db.collection('users').add({
    'name': 'Mohan',
    'age': 25,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
