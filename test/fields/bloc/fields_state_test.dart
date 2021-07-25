import 'package:flutter_test/flutter_test.dart';
import 'package:pickup_game/fields/bloc/fields_bloc.dart';

void main() {
  group('FieldsState', () {
    const state = FieldsState();

    test('support state equality', () {
      expect(state.copyWith(), equals(state));
    });
  });
}
