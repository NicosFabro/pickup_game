import 'package:flutter_test/flutter_test.dart';
import 'package:game_repository/game_repository.dart';
import 'package:pickup_game/games/bloc/games_bloc.dart';

void main() {
  group('GamesEvent', () {
    final game = Game(
      id: 'id',
      fieldId: 'fieldId',
      dateStart: DateTime(2021),
      dateEnd: DateTime(2021),
      gameType: GameType.TeamVsTeam,
      footballType: FootballType.Football5,
      players: const {},
    );

    group('GamesFetchRequested', () {
      final instanceA = GamesFetchRequested();
      final instanceB = GamesFetchRequested();

      test('support props equality', () {
        expect(instanceA.props, equals(instanceB.props));
      });
    });

    group('GamePushRequested', () {
      final instanceA = GamePostRequested(game: game);
      final instanceB = GamePostRequested(game: game);

      test('support props equality', () {
        expect(instanceA.props, equals(instanceB.props));
      });
    });

    group('GamePushRequested', () {
      final instanceA = GamePushRequested(game: game);
      final instanceB = GamePushRequested(game: game);

      test('support props equality', () {
        expect(instanceA.props, equals(instanceB.props));
      });
    });

    group('GamesUpdated', () {
      const instanceA = GamesUpdated([]);
      const instanceB = GamesUpdated([]);

      test('support props equality', () {
        expect(instanceA.props, equals(instanceB.props));
      });
    });
  });
}
