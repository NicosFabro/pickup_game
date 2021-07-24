part of 'games_bloc.dart';

abstract class GamesEvent extends Equatable {
  const GamesEvent();

  @override
  List<Object> get props => [];
}

class GamesUpdated extends GamesEvent {
  const GamesUpdated(this.games);
  final List<Game> games;
}

class GamesFetchRequested extends GamesEvent {}

class GamePostRequested extends GamesEvent {
  const GamePostRequested({required this.game});
  final Game game;
}

class GamePushRequested extends GamesEvent {
  const GamePushRequested({required this.game});
  final Game game;
}
