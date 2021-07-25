part of 'games_bloc.dart';

abstract class GamesEvent extends Equatable {
  const GamesEvent();

  @override
  List<Object> get props => [];
}

class GamesFetchRequested extends GamesEvent {}

class GamePostRequested extends GamesEvent {
  const GamePostRequested({required this.game});
  final Game game;

  @override
  List<Object> get props => [game];
}

class GamePushRequested extends GamesEvent {
  const GamePushRequested({required this.game});
  final Game game;

  @override
  List<Object> get props => [game];
}

class GamesUpdated extends GamesEvent {
  const GamesUpdated(this.games);
  final List<Game> games;

  @override
  List<Object> get props => [games];
}
