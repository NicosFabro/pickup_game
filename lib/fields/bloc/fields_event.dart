part of 'fields_bloc.dart';

abstract class FieldsEvent extends Equatable {
  const FieldsEvent();

  @override
  List<Object> get props => [];
}

class FieldsFetchRequested extends FieldsEvent {}

class FieldFetchRequested extends FieldsEvent {
  const FieldFetchRequested({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}

class FieldsUpdated extends FieldsEvent {
  const FieldsUpdated({required this.fields});
  final List<Field> fields;

  @override
  List<Object> get props => [fields];
}
