import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:game_repository/game_repository.dart';
import 'package:pickup_game/games/bloc/games_bloc.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  group('GamesBloc', () {
    late GameRepository gameRepository;
    late GamesBloc gamesBloc;

    setUp(() {
      gameRepository = MockGameRepository();
      gamesBloc = GamesBloc(gameRepository: gameRepository);
    });

    test('initial state is empty', () {
      expect(gamesBloc.state, equals(const GamesState()));
    });

    group('GamesFetchRequested', () {
      var games = <Game>[
        Game(
          id: 'acb123',
          fieldId: 'def456',
          dateStart: DateTime(2021, 07, 24, 10, 00),
          dateEnd: DateTime(2021, 07, 24, 11, 30),
          gameType: GameType.KingOfTheCourt,
          footballType: FootballType.Football5,
          players: const {'Nicos': 'blue'},
        ),
      ];

      var gamesStream = Stream.value(games);

      blocTest<GamesBloc, GamesState>(
        'emits [loading, failure] when GamesFetchRequested fails',
        build: () {
          when(
            () => gameRepository.getGames(),
          ).thenThrow(Exception());
          return gamesBloc;
        },
        act: (bloc) => bloc.add(GamesFetchRequested()),
        expect: () => [
          const GamesState(status: GamesStatus.loading),
          const GamesState(status: GamesStatus.failure),
        ],
      );

      blocTest<GamesBloc, GamesState>(
        'emits [loading, success] when GamesFetchRequested success',
        build: () {
          when(
            () => gameRepository.getGames(),
          ).thenAnswer((_) => gamesStream);
          return gamesBloc;
        },
        act: (bloc) => bloc.add(GamesFetchRequested()),
        expect: () => [
          const GamesState(status: GamesStatus.loading),
          GamesState(status: GamesStatus.success, games: games),
        ],
      );
    });

    group('GamePostRequested', () {
      var game = Game(
        id: 'acb123',
        fieldId: 'def456',
        dateStart: DateTime(2021, 07, 24, 10, 00),
        dateEnd: DateTime(2021, 07, 24, 11, 30),
        gameType: GameType.KingOfTheCourt,
        footballType: FootballType.Football5,
        players: const {'Nicos': 'blue'},
      );

      blocTest<GamesBloc, GamesState>(
        'emits [loading, failure] when GamePostRequested fails',
        build: () {
          when(
            () => gameRepository.addNewGame(game),
          ).thenThrow(Exception());
          return gamesBloc;
        },
        act: (bloc) => bloc.add(GamePostRequested(game: game)),
        expect: () => [
          const GamesState(status: GamesStatus.loading),
          const GamesState(status: GamesStatus.failure),
        ],
      );

      blocTest<GamesBloc, GamesState>(
        'emits [loading, success] when GamePostRequested success',
        build: () {
          when(
            () => gameRepository.addNewGame(game),
          ).thenAnswer((_) async => await Future.value());
          return gamesBloc;
        },
        act: (bloc) => bloc.add(GamePostRequested(game: game)),
        expect: () => [
          const GamesState(status: GamesStatus.loading),
          const GamesState(status: GamesStatus.success),
        ],
      );
    });

    group('GamePushRequested', () {
      var game = Game(
        id: 'acb123',
        fieldId: 'def456',
        dateStart: DateTime(2021, 07, 24, 10, 00),
        dateEnd: DateTime(2021, 07, 24, 11, 30),
        gameType: GameType.KingOfTheCourt,
        footballType: FootballType.Football5,
        players: const {'Nicos': 'blue'},
      );

      blocTest<GamesBloc, GamesState>(
        'emits [loading, failure] when GamePushRequested fails',
        build: () {
          when(
            () => gameRepository.editGame(game),
          ).thenThrow(Exception());
          return gamesBloc;
        },
        act: (bloc) => bloc.add(GamePushRequested(game: game)),
        expect: () => [
          const GamesState(status: GamesStatus.loading),
          const GamesState(status: GamesStatus.failure),
        ],
      );

      blocTest<GamesBloc, GamesState>(
        'emits [loading, success] when GamePushRequested success',
        build: () {
          when(
            () => gameRepository.editGame(game),
          ).thenAnswer((_) async => await Future.value());
          return gamesBloc;
        },
        act: (bloc) => bloc.add(GamePushRequested(game: game)),
        expect: () => [
          const GamesState(status: GamesStatus.loading),
          const GamesState(status: GamesStatus.success),
        ],
      );
    });

    group('GamesUpdated', () {
      var games = <Game>[
        Game(
          id: 'acb123',
          fieldId: 'def456',
          dateStart: DateTime(2021, 07, 24, 10, 00),
          dateEnd: DateTime(2021, 07, 24, 11, 30),
          gameType: GameType.KingOfTheCourt,
          footballType: FootballType.Football5,
          players: const {'Nicos': 'blue'},
        ),
      ];

      blocTest<GamesBloc, GamesState>(
        'emits [success] when GamesUpdated sucess',
        build: () => gamesBloc,
        act: (bloc) => bloc.add(GamesUpdated(games)),
        expect: () => [
          GamesState(status: GamesStatus.success, games: games),
        ],
      );
    });
  });
}
