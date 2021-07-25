import 'package:flutter_test/flutter_test.dart';
import 'package:pickup_game/games/bloc/games_bloc.dart';

void main() {
  group('FieldsState', () {
    const state = GamesState();

    test('support state equality', () {
      expect(state.copyWith(), equals(state));
    });
  });
}
