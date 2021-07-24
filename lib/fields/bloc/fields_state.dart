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
    FieldsStatus? status,
    List<Field>? fields,
  }) {
    return FieldsState(
      fields: fields ?? this.fields,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [fields, status];
}
