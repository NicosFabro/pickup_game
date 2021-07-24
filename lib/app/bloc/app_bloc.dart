import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:auth_repository/auth_repository.dart';
import 'package:profile_repository/profile_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
  })  : _authRepository = authRepository,
        _profileRepository = profileRepository,
        super(authRepository.currentUser.isNotEmpty
            ? AppState.authenticated(authRepository.currentUser)
            : const AppState.unauthenticated()) {
    _userSubscription = _authRepository.user.listen(_onUserChanged);
  }

  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription<Profile> _profileSubscription;

  void _onUserChanged(User user) => add(AppUserChanged(user));

  @override
  Future<void> close() {
    _profileSubscription.cancel();
    _userSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is AppUserChanged) {
      yield* _mapUserChangedToState(event, state);
    } else if (event is AppLogOutRequested) {
      yield* _mapAppLogOutRequestedToState(state);
    }
  }

  Stream<AppState> _mapUserChangedToState(
    AppUserChanged event,
    AppState state,
  ) async* {
    if (event.user.isNotEmpty) {
      final profile = await _profileRepository.getProfileById(event.user.id);
      yield AppState.authenticated(event.user, profile: profile);
    } else {
      yield const AppState.unauthenticated();
    }
  }

  Stream<AppState> _mapAppLogOutRequestedToState(
    AppState event,
  ) async* {
    await _authRepository.logOut();
    yield const AppState.unauthenticated();
  }
}
