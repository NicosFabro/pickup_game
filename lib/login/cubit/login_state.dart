part of 'login_cubit.dart';

enum LoginStatus {
  pure,
  inProgress,
  success,
  failure,
}

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.pure,
  });

  final LoginStatus status;

  @override
  List<Object> get props => [status];

  LoginState copyWith({
    LoginStatus? status,
  }) {
    return LoginState(status: status ?? this.status);
  }
}
