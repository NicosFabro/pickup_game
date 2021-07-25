import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Packages
import 'package:field_repository/field_repository.dart';

part 'fields_event.dart';
part 'fields_state.dart';

class FieldsBloc extends Bloc<FieldsEvent, FieldsState> {
  FieldsBloc({
    required this.fieldRepository,
  }) : super(const FieldsState(status: FieldsStatus.loading));

  final FieldRepository fieldRepository;
  StreamSubscription? _fieldsSubscription;

  @override
  Stream<FieldsState> mapEventToState(FieldsEvent event) async* {
    if (event is FieldsFetchRequested) {
      yield* _mapFieldsFetchRequestedToState(event);
    } else if (event is FieldFetchRequested) {
      yield* _mapFieldFetchRequestedToState(event);
    } else if (event is FieldsUpdated) {
      yield* _mapFieldsUpdated(event);
    }
  }

  Stream<FieldsState> _mapFieldFetchRequestedToState(
    FieldFetchRequested event,
  ) async* {
    yield state.copyWith(status: FieldsStatus.loading);
    try {
      final field = await fieldRepository.getFieldById(event.id);
      yield state.copyWith(
        status: FieldsStatus.success,
        fields: [field],
      );
    } catch (_) {
      yield state.copyWith(status: FieldsStatus.failure);
    }
  }

  Stream<FieldsState> _mapFieldsFetchRequestedToState(
    FieldsFetchRequested event,
  ) async* {
    yield state.copyWith(status: FieldsStatus.loading);
    await _fieldsSubscription?.cancel();
    try {
      _fieldsSubscription = fieldRepository.getFields().listen(
            (fields) => add(FieldsUpdated(fields: fields)),
          );
    } catch (_) {
      yield state.copyWith(status: FieldsStatus.failure);
    }
  }

  Stream<FieldsState> _mapFieldsUpdated(
    FieldsUpdated event,
  ) async* {
    yield state.copyWith(fields: event.fields, status: FieldsStatus.success);
  }

  @override
  Future<void> close() {
    _fieldsSubscription?.cancel();
    return super.close();
  }
}
