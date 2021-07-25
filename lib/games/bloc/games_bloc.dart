import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Packages
import 'package:game_repository/game_repository.dart';

part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  GamesBloc({
    required this.gameRepository,
  }) : super(const GamesState(status: GamesStatus.loading));

  final GameRepository gameRepository;
  StreamSubscription? _gamesSubscription;

  @override
  Stream<GamesState> mapEventToState(GamesEvent event) async* {
    if (event is GamesFetchRequested) {
      yield* _mapGamesFetchRequestedToState(event);
    } else if (event is GamePostRequested) {
      yield* _mapGamePostRequestedToState(event);
    } else if (event is GamePushRequested) {
      yield* _mapGamePushRequestedToState(event);
    } else if (event is GamesUpdated) {
      yield* _mapGamesUpdatedToState(event);
    }
  }

  Stream<GamesState> _mapGamesFetchRequestedToState(
    GamesFetchRequested event,
  ) async* {
    yield state.copyWith(status: GamesStatus.loading);
    await _gamesSubscription?.cancel();
    try {
      _gamesSubscription = gameRepository.getGames().listen(
            (games) => add(GamesUpdated(games)),
          );
    } catch (_) {
      yield state.copyWith(status: GamesStatus.failure);
    }
  }

  Stream<GamesState> _mapGamePostRequestedToState(
    GamePostRequested event,
  ) async* {
    yield state.copyWith(status: GamesStatus.loading);
    try {
      await gameRepository.addNewGame(event.game);
      yield state.copyWith(status: GamesStatus.success);
    } catch (_) {
      yield state.copyWith(status: GamesStatus.failure);
    }
  }

  Stream<GamesState> _mapGamePushRequestedToState(
    GamePushRequested event,
  ) async* {
    yield state.copyWith(status: GamesStatus.loading);
    try {
      await gameRepository.editGame(event.game);
      yield state.copyWith(status: GamesStatus.success);
    } catch (_) {
      yield state.copyWith(status: GamesStatus.failure);
    }
  }

  Stream<GamesState> _mapGamesUpdatedToState(
    GamesUpdated event,
  ) async* {
    yield state.copyWith(status: GamesStatus.loading);
    try {
      yield state.copyWith(games: event.games, status: GamesStatus.success);
    } catch (_) {
      yield state.copyWith(status: GamesStatus.failure);
    }
  }

  @override
  Future<void> close() {
    _gamesSubscription?.cancel();
    return super.close();
  }
}
