part of 'games_bloc.dart';

enum GamesStatus {
  loading,
  success,
  failure,
}

class GamesState extends Equatable {
  const GamesState({
    this.games = const [],
    this.status = GamesStatus.loading,
  });

  final List<Game> games;
  final GamesStatus status;

  GamesState copyWith({
    List<Game>? games,
    GamesStatus? status,
  }) {
    return GamesState(
      games: games ?? this.games,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [games, status];
}
