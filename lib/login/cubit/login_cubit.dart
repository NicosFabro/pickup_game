import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Packages
import 'package:auth_repository/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      await _authRepository.logInWithGoogle();
      emit(state.copyWith(status: LoginStatus.success));
    } on Exception {
      emit(state.copyWith(status: LoginStatus.failure));
    } on NoSuchMethodError {
      emit(state.copyWith(status: LoginStatus.pure));
    }
  }
}
