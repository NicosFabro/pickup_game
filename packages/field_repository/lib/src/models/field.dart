import 'package:equatable/equatable.dart';

import 'package:field_repository/field_repository.dart';

class Field extends Equatable {
  const Field({
    required this.id,
    required this.name,
    required this.address,
    required this.logoUrl,
  });

  final String id;
  final String name;
  final String address;
  final String logoUrl;

  FieldEntity toEntity() => FieldEntity(
        id,
        name,
        address,
        logoUrl,
      );

  static Field fromEntity(FieldEntity entity) => Field(
        id: entity.id,
        name: entity.name,
        address: entity.address,
        logoUrl: entity.logoUrl,
      );

  @override
  List<Object> get props => [id, name, address, logoUrl];
}
