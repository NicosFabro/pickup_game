import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Fields
import 'package:field_repository/field_repository.dart';
import 'package:pickup_game/fields/bloc/fields_bloc.dart';

class MockFieldRepository extends Mock implements FieldRepository {}

void main() {
  group('FieldsBloc', () {
    late FieldRepository fieldRepository;
    late FieldsBloc fieldsBloc;

    setUp(() {
      fieldRepository = MockFieldRepository();
      fieldsBloc = FieldsBloc(fieldRepository: fieldRepository);
    });

    test('initial state is empty', () {
      expect(fieldsBloc.state, equals(const FieldsState()));
    });

    group('FieldsFetchRequested', () {
      var fields = const <Field>[
        Field(
          id: 'abc123',
          name: 'name',
          address: 'address',
          logoUrl: 'logoUrl',
        ),
      ];

      var fieldsStream = Stream.value(fields);

      blocTest<FieldsBloc, FieldsState>(
        'emits [loading, failure] when FieldsFetchRequested fails',
        build: () {
          when(
            () => fieldRepository.getFields(),
          ).thenThrow(Exception());
          return fieldsBloc;
        },
        act: (bloc) => bloc.add(FieldsFetchRequested()),
        expect: () => [
          const FieldsState(status: FieldsStatus.loading),
          const FieldsState(status: FieldsStatus.failure),
        ],
      );

      blocTest<FieldsBloc, FieldsState>(
        'emits [loading, success] when FieldsFetchRequested success',
        build: () {
          when(
            () => fieldRepository.getFields(),
          ).thenAnswer((_) => fieldsStream);
          return fieldsBloc;
        },
        act: (bloc) => bloc.add(FieldsFetchRequested()),
        expect: () => [
          const FieldsState(status: FieldsStatus.loading),
          FieldsState(status: FieldsStatus.success, fields: fields),
        ],
      );
    });

    group('FieldFetchRequested', () {
      var field = const Field(
        id: 'abc123',
        name: 'name',
        address: 'address',
        logoUrl: 'logoUrl',
      );

      blocTest<FieldsBloc, FieldsState>(
        'emits [loading, failure] when FieldFetchRequested fails',
        build: () {
          when(
            () => fieldRepository.getFieldById(field.id),
          ).thenThrow(Exception());
          return fieldsBloc;
        },
        act: (bloc) => bloc.add(FieldFetchRequested(id: field.id)),
        expect: () => [
          const FieldsState(status: FieldsStatus.loading),
          const FieldsState(status: FieldsStatus.failure),
        ],
      );

      blocTest<FieldsBloc, FieldsState>(
          'emits [loading, success] when FieldFetchRequested success',
          build: () {
            when(
              () => fieldRepository.getFieldById(field.id),
            ).thenAnswer((invocation) async => await Future.value(field));
            return fieldsBloc;
          },
          act: (bloc) => bloc.add(FieldFetchRequested(id: field.id)),
          expect: () => [
                const FieldsState(status: FieldsStatus.loading),
                FieldsState(status: FieldsStatus.success, fields: [field]),
              ]);
    });

    group('FieldsUpdated', () {
      var fields = const <Field>[
        Field(
          id: 'abc123',
          name: 'name',
          address: 'address',
          logoUrl: 'logoUrl',
        ),
      ];

      blocTest<FieldsBloc, FieldsState>(
        'emits [success] when FieldsUpdated success',
        build: () => fieldsBloc,
        act: (bloc) => bloc.add(FieldsUpdated(fields: fields)),
        expect: () => [
          FieldsState(status: FieldsStatus.success, fields: fields),
        ],
      );
    });
  });
}
