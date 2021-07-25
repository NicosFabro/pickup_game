import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:equatable/equatable.dart';

class GameEntity extends Equatable {
  const GameEntity(
    this.id,
    this.fieldId,
    this.dateStart,
    this.dateEnd,
    this.gameType,
    this.footballType,
    this.players,
  );

  final String id;
  final String fieldId;
  final DateTime dateStart;
  final DateTime dateEnd;
  final String gameType;
  final String footballType;
  final Map<String, String> players;

  Map<String, dynamic> toJson() => {
        'id': id,
        'fieldId': fieldId,
        'dateStart': dateStart,
        'dateEnd': dateEnd,
        'gameType': gameType,
        'footballType': footballType,
        'players': players,
      };

  static GameEntity fromJson(Map<String, dynamic> json) => GameEntity(
        json['id'] as String,
        json['fieldId'] as String,
        json['dateStart'] as DateTime,
        json['dateEnd'] as DateTime,
        json['gameType'] as String,
        json['footballType'] as String,
        json['players'] as Map<String, String>,
      );

  static GameEntity fromSnapshot(DocumentSnapshot snap) => GameEntity(
        snap.get('id'),
        snap.get('fieldId'),
        (snap.get('dateStart') as Timestamp).toDate(),
        (snap.get('dateEnd') as Timestamp).toDate(),
        snap.get('gameType'),
        snap.get('footballType'),
        (snap.get('players') as Map).map<String, String>(
          (key, value) => MapEntry(key, value),
        ),
      );

  Map<String, dynamic> toDocument() => {
        'id': id,
        'fieldId': fieldId,
        'dateStart': dateStart,
        'dateEnd': dateEnd,
        'gameType': gameType,
        'footballType': footballType,
        'players': players,
      };

  @override
  List<Object?> get props => [
        id,
        fieldId,
        dateStart,
        dateEnd,
        gameType,
        footballType,
        players,
      ];
}
