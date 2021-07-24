import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:game_repository/src/models/models.dart';

enum FootballType { Football5, Football7 }

enum GameType { TeamVsTeam, KingOfTheCourt }

class Game extends Equatable {
  const Game({
    required this.id,
    required this.fieldId,
    required this.dateStart,
    required this.dateEnd,
    required this.gameType,
    required this.footballType,
    required this.players,
  });

  final String id;
  final String fieldId;
  final DateTime dateStart;
  final DateTime dateEnd;
  final GameType gameType;
  final FootballType footballType;
  final Map<String, String> players;

  Game copyWith({
    String? id,
    String? fieldId,
    DateTime? dateStart,
    DateTime? dateEnd,
    GameType? gameType,
    FootballType? footballType,
    Map<String, String>? players,
  }) {
    return Game(
      id: id ?? this.id,
      fieldId: fieldId ?? this.fieldId,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      gameType: gameType ?? this.gameType,
      footballType: footballType ?? this.footballType,
      players: players ?? this.players,
    );
  }

  GameEntity toEntity() => GameEntity(
        id,
        fieldId,
        dateStart,
        dateEnd,
        describeEnum(gameType),
        describeEnum(footballType),
        players,
      );

  static Game fromEntity(GameEntity entity) => Game(
        id: entity.id,
        fieldId: entity.fieldId,
        dateStart: entity.dateStart,
        dateEnd: entity.dateEnd,
        gameType: stringToGameType(entity.gameType),
        footballType: stringToFootballType(entity.footballType),
        players: entity.players,
      );

  static GameType stringToGameType(String s) {
    switch (s) {
      case 'TeamVsTeam':
        return GameType.TeamVsTeam;
      case 'KingOfTheCourt':
        return GameType.KingOfTheCourt;
      default:
        return GameType.TeamVsTeam;
    }
  }

  static FootballType stringToFootballType(String s) {
    switch (s) {
      case 'Football5':
        return FootballType.Football5;
      case 'Football7':
        return FootballType.Football7;
      default:
        return FootballType.Football5;
    }
  }

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
