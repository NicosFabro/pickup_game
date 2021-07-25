part of 'fields_bloc.dart';

enum FieldsStatus {
  loading,
  success,
  failure,
}

class FieldsState extends Equatable {
  const FieldsState({
    this.fields = const [],
    this.status = FieldsStatus.loading,
  });

  final List<Field> fields;
  final FieldsStatus status;

  FieldsState copyWith({
    List<Field>? fields,
    FieldsStatus? status,
  }) {
    return FieldsState(
      fields: fields ?? this.fields,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [fields, status];
}
