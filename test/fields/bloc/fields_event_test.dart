import 'package:flutter_test/flutter_test.dart';
import 'package:pickup_game/fields/bloc/fields_bloc.dart';

void main() {
  group('FieldsEvent', () {
    group('FieldsFetchRequested', () {
      final instanceA = FieldsFetchRequested();
      final instanceB = FieldsFetchRequested();

      test('support props equality', () {
        expect(instanceA, equals(instanceB));
      });
    });

    group('FieldFetchRequested', () {
      const instanceA = FieldFetchRequested(id: 'A');
      const instanceB = FieldFetchRequested(id: 'A');

      test('support props equality', () {
        expect(instanceA.props, equals(instanceB.props));
      });
    });

    group('FieldsUpdated ', () {
      const instanceA = FieldsUpdated(fields: []);
      const instanceB = FieldsUpdated(fields: []);

      test('support props equality', () {
        expect(instanceA.props, equals(instanceB.props));
      });
    });
  });
}
