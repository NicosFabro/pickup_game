import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:equatable/equatable.dart';

class FieldEntity extends Equatable {
  const FieldEntity(
    this.id,
    this.name,
    this.address,
    this.logoUrl,
  );

  final String id;
  final String name;
  final String address;
  final String logoUrl;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "logoUrl": logoUrl,
      };

  static FieldEntity fromJson(Map<String, dynamic> json) => FieldEntity(
        json['id'] as String,
        json['name'] as String,
        json['address'] as String,
        json['logoUrl'] as String,
      );

  static FieldEntity fromSnapshot(DocumentSnapshot snap) => FieldEntity(
        snap.id,
        snap.get('name'),
        snap.get('address'),
        snap.get('logoUrl'),
      );

  Map<String, dynamic> toDocument() => {
        "name": name,
        "address": address,
        "logoUrl": logoUrl,
      };

  @override
  List<Object> get props => [id, name, address, logoUrl];
}
