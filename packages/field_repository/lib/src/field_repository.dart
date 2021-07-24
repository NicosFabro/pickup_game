import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:field_repository/field_repository.dart';

class FieldRepository {
  final fieldsCollection = FirebaseFirestore.instance.collection('fields');

  Stream<List<Field>> getFields() {
    return fieldsCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Field.fromEntity(FieldEntity.fromSnapshot(doc)))
        .toList());
  }

  Future<Field> getFieldById(String id) async {
    DocumentSnapshot documentSnapshot = await fieldsCollection.doc(id).get();
    return Field.fromEntity(FieldEntity.fromSnapshot(documentSnapshot));
  }
}
